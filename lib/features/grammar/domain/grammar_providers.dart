import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'grammar_view_providers.dart';

/// Provider for the currently selected grammar level filter.
final selectedGrammarLevelProvider = StateProvider<String>((ref) => 'Alle');

/// Provider for the currently selected grammar category filter.
final selectedGrammarCategoryProvider = StateProvider<String>((ref) => 'Alle');

/// Provider for the grammar search query.
final grammarSearchQueryProvider = StateProvider<String>((ref) => '');

/// Local grammar topics loaded from the database.
final localGrammarTopicsProvider =
    Provider<AsyncValue<List<GrammarTopic>>>((ref) {
  return ref.watch(grammarTopicsStreamProvider);
});

/// Provider that filters grammar topics based on level, category, and search query.
final filteredGrammarTopicsProvider =
    Provider<AsyncValue<List<GrammarTopic>>>((ref) {
  final grammarAsync = ref.watch(localGrammarTopicsProvider);
  final level = ref.watch(selectedGrammarLevelProvider);
  final category = ref.watch(selectedGrammarCategoryProvider);
  final query = ref.watch(grammarSearchQueryProvider).toLowerCase();

  return grammarAsync.whenData((allEntries) {
    return allEntries.where((entry) {
      // Level filter
      if (level != 'Alle' && entry.level != level) {
        return false;
      }

      // Category filter
      if (category != 'Alle') {
        final cat = category.toLowerCase();
        final tCat = entry.category.toLowerCase();
        if (!tCat.contains(cat) && !cat.contains(tCat.split(' ').first)) {
          return false;
        }
      }

      // Search query filter
      if (query.isNotEmpty) {
        return entry.title.toLowerCase().contains(query);
      }

      return true;
    }).toList()
      ..sort(compareGrammarEntries);
  });
});

/// Provider for grouping filtered grammar topics by level.
final groupedGrammarTopicsProvider =
    Provider<AsyncValue<Map<String, List<GrammarTopic>>>>((ref) {
  final filteredAsync = ref.watch(filteredGrammarTopicsProvider);

  return filteredAsync.whenData((topics) {
    final map = <String, List<GrammarTopic>>{};
    for (final t in topics) {
      final lv = t.level;
      map.putIfAbsent(lv, () => []).add(t);
    }
    return map;
  });
});
