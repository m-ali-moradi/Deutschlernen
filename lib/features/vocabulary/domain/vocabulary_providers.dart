import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/content/sync/connectivity_service.dart';
import '../../../core/content/sync/firebase_content_repository.dart';
import '../../../core/content/sync/sync_service.dart';
import '../../../core/database/app_database.dart';
import 'vocabulary_category_metrics.dart';

// We can move specific vocabulary providers here if they are only used in this feature.
// For now, many are in database_providers.dart but we could wrap them or add feature-specific ones.

final vocabularySearchQueryProvider = StateProvider<String>((ref) => '');
final vocabularySelectedCategoryProvider =
    StateProvider<String?>((ref) => null);
final vocabularyPinnedGroupProvider =
    StateProvider<Set<String>>((ref) => <String>{});
final vocabularyTabProvider = StateProvider<String>((ref) => 'words');
final vocabularyFlashcardModeProvider = StateProvider<bool>((ref) => false);

final vocabularyCategoryWordCountProvider =
    FutureProvider.family<int, String>((ref, categoryId) async {
  final isOnline = ref.watch(connectivityProvider).valueOrNull ?? false;
  if (!isOnline) {
    return 0;
  }

  final repo = ref.read(firebaseContentRepositoryProvider);
  final words = await repo.getVocabularyWordsByCategoryMetadata(categoryId);
  return words.length;
});

final vocabularyCategoryRemoteEntriesProvider =
    FutureProvider.family<List<SyncEntry<VocabularyWord>>, String>(
        (ref, categoryId) async {
  // When a category is available only online, fetch its live words so the
  // vocabulary screen can still show the same review breakdown as cached data.
  final isOnline = ref.watch(connectivityProvider).valueOrNull ?? false;
  if (!isOnline) {
    return const [];
  }

  final repo = ref.read(firebaseContentRepositoryProvider);
  final words = await repo.getVocabularyWordsByCategoryMetadata(categoryId);
  return vocabularyEntriesFromRemoteCategoryData(words, categoryId);
});

// A provider that filters vocabulary based on current UI state
final filteredVocabularyProvider =
    Provider<List<SyncEntry<VocabularyWord>>>((ref) {
  final allWords = ref.watch(hybridVocabularyProvider).valueOrNull ?? [];
  final search = ref.watch(vocabularySearchQueryProvider).toLowerCase();
  final category = ref.watch(vocabularySelectedCategoryProvider);
  final tab = ref.watch(vocabularyTabProvider);

  return allWords.where((entry) {
    final isFav = entry.localData?.isFavorite ?? false;
    final cat =
        entry.localData?.category ?? entry.cloudMetadata?['category'] ?? '';

    if (tab == 'favorites' && !isFav) return false;
    if (category != null && cat != category) return false;

    if (search.isNotEmpty) {
      final title = entry.displayTitle.toLowerCase();
      final eng = entry.displayEnglishTitle?.toLowerCase() ?? '';
      final tag = entry.localData?.tag.toLowerCase() ??
          entry.cloudMetadata?['tag']?.toLowerCase() ??
          '';

      if (!title.contains(search) &&
          !eng.contains(search) &&
          !cat.toLowerCase().contains(search) &&
          !tag.contains(search)) {
        return false;
      }
    }
    return true;
  }).toList();
});
