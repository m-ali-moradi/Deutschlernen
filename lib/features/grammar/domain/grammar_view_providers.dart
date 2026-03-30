/// Presentation-level providers for the Grammar section.
///
/// These providers bridge the gap between UI state (like search visibility,
/// filter toggles) and the underlying data layer. By lifting this state out
/// of the `GrammarScreen`, we enable smaller, deeply-focused widget components.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'grammar_logic.dart';

/// Tracks whether the user is actively using the search bar.
final grammarIsSearchingProvider = StateProvider<bool>((ref) => false);

/// Tracks whether the filter chips (level, category) are currently visible.
final grammarShowFiltersProvider = StateProvider<bool>((ref) => false);

/// Compares two GrammarTopic entries for a stable curriculum order.
///
/// Sort order:
/// 1. Standard semantic sorting based on ID numeric part (easier to harder).
/// 2. Alphabetical fallback on display title.
int compareGrammarEntries(GrammarTopic left, GrammarTopic right) {
  // 1. Sort by Level Rank (A1 < A2 < B1...)
  final levelA = left.level;
  final levelB = right.level;
  final rankA = grammarLevelRank(levelA);
  final rankB = grammarLevelRank(levelB);
  if (rankA != rankB) return rankA.compareTo(rankB);

  // 2. Sort by Category Rank (Pedagogical sequence of topics)
  final catA = left.category;
  final catB = right.category;
  final cRankA = grammarCategoryRank(catA);
  final cRankB = grammarCategoryRank(catB);
  if (cRankA != cRankB) return cRankA.compareTo(cRankB);

  // 3. Sort by Natural Numeric ID (g1 < g2 < g10) within category
  final idRankA = grammarTopicIdRank(left.id);
  final idRankB = grammarTopicIdRank(right.id);
  if (idRankA != idRankB) return idRankA.compareTo(idRankB);

  // 4. Fallback to Display Title
  return left.title.compareTo(right.title);
}
