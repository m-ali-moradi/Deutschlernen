import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';

// We can move specific vocabulary providers here if they are only used in this feature.
// For now, many are in database_providers.dart but we could wrap them or add feature-specific ones.

final vocabularySearchQueryProvider = StateProvider<String>((ref) => '');
final vocabularySelectedCategoryProvider =
    StateProvider<String?>((ref) => null);
final vocabularyPinnedGroupProvider =
    StateProvider<Set<String>>((ref) => <String>{});
final vocabularyTabProvider = StateProvider<String>((ref) => 'words');
final vocabularyFlashcardModeProvider = StateProvider<bool>((ref) => false);

final localVocabularyEntriesProvider = Provider<List<VocabularyWord>>((ref) {
  final localWords = ref.watch(vocabularyWordsStreamProvider).valueOrNull ??
      const <VocabularyWord>[];

  return localWords.toList(growable: false);
});
