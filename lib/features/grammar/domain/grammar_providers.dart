import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/content/sync/sync_service.dart';
import 'grammar_view_providers.dart';

/// Provider for the currently selected grammar level filter.
final selectedGrammarLevelProvider = StateProvider<String>((ref) => 'Alle');

/// Provider for the currently selected grammar category filter.
final selectedGrammarCategoryProvider = StateProvider<String>((ref) => 'Alle');

/// Provider for the grammar search query.
final grammarSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider that filters grammar topics based on level, category, and search query.
final filteredGrammarTopicsProvider =
    Provider<AsyncValue<List<SyncEntry<GrammarTopic>>>>((ref) {
  final grammarAsync = ref.watch(hybridGrammarProvider);
  final level = ref.watch(selectedGrammarLevelProvider);
  final category = ref.watch(selectedGrammarCategoryProvider);
  final query = ref.watch(grammarSearchQueryProvider).toLowerCase();

  return grammarAsync.whenData((allEntries) {
    return allEntries.where((entry) {
      // Level filter
      if (level != 'Alle' && entry.displayLevel != level) {
        return false;
      }

      // Category filter
      if (category != 'Alle') {
        final cat = category.toLowerCase();
        final tCat = entry.localData?.category.toLowerCase() ?? '';
        if (!tCat.contains(cat) && !cat.contains(tCat.split(' ').first)) {
          return false;
        }
      }

      // Search query filter
      if (query.isNotEmpty) {
        return entry.displayTitle.toLowerCase().contains(query);
      }

      return true;
    }).toList()
      ..sort(compareGrammarEntries);
  });
});

/// Provider for grouping filtered grammar topics by level.
final groupedGrammarTopicsProvider =
    Provider<AsyncValue<Map<String, List<SyncEntry<GrammarTopic>>>>>((ref) {
  final filteredAsync = ref.watch(filteredGrammarTopicsProvider);

  return filteredAsync.whenData((topics) {
    final map = <String, List<SyncEntry<GrammarTopic>>>{};
    for (final t in topics) {
      final lv = t.displayLevel;
      map.putIfAbsent(lv, () => []).add(t);
    }
    return map;
  });
});
