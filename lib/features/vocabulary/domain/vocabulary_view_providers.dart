/// This file contains presentation-specific providers and utilities for the vocabulary feature.
///
/// These providers are responsible for bridging the gap between raw data providers
/// and the user interface. They handle tasks like filtering lists based on user
/// selections (e.g., pinned groups, tabs) and safely parsing data objects.
///
/// Extracting this logic here ensures the UI widgets remain clean, highly cohesive,
/// focused solely on rendering, and makes testing the business logic much easier.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/core/learning/review_logic.dart'; // provides ReviewResult
import './vocabulary_providers.dart';
import './vocabulary_category_metrics.dart'; // provides vocabularyEntryCategory

/// Holds short-lived optimistic review state to immediately reflect user choices
/// (e.g., swiping "Easy") in the UI before they are fully persisted to the database.
final vocabularyOptimisticReviewsProvider =
    StateProvider<Map<String, ReviewResult>>((ref) => {});

/// A provider that filters vocabulary based on current UI state (search, categories, tabs).
final filteredVocabularyProvider = Provider<List<VocabularyWord>>((ref) {
  final allWords = ref.watch(localVocabularyEntriesProvider);
  final search = ref.watch(vocabularySearchQueryProvider).toLowerCase();
  final category = ref.watch(vocabularySelectedCategoryProvider);
  final tab = ref.watch(vocabularyTabProvider);

  return allWords.where((entry) {
    final isFav = entry.isFavorite;
    final cat = entry.category;

    if (tab == 'favorites' && !isFav) return false;

    if (tab == 'hard_words') {
      final reviewState =
          ref.watch(vocabularyReviewStateProvider).valueOrNull?.byWordId ?? {};
      final optimistic = ref.watch(vocabularyOptimisticReviewsProvider);
      final result = optimistic[entry.id] ?? reviewState[entry.id]?.lastResult;

      // We only show words currently marked as hard.
      if (result != ReviewResult.hard) return false;
    }

    if (category != null && cat != category) return false;

    if (search.isNotEmpty) {
      final title = entry.german.toLowerCase();
      final eng = entry.english.toLowerCase();
      final tag = entry.tag.toLowerCase();

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

/// Provides a list of vocabulary entries filtered by the currently pinned groups.
///
/// If there are no pinned groups, it simply returns all available filtered entries.
/// Otherwise, it cross-references the pinned group IDs with the available
/// categories to emit only words that belong to the user's selected groups.
/// This prevents the UI from having to recalculate lists on every build.
final visibleVocabularyEntriesProvider = Provider<List<VocabularyWord>>((ref) {
  // Watch the base list of vocabulary entries.
  final entries = ref.watch(filteredVocabularyProvider);

  // Watch the user's currently pinned groups.
  final pinnedGroupIds = ref.watch(vocabularyPinnedGroupProvider);

  // Early return if no filtering by group is needed.
  if (pinnedGroupIds.isEmpty) {
    return entries;
  }

  // Watch categories to know which category belongs to which group.
  final categoriesAsync = ref.watch(vocabularyCategoriesStreamProvider);
  final categories = categoriesAsync.valueOrNull;

  // If categories are not loaded yet, fallback to yielding all entries.
  if (categories == null || categories.isEmpty) {
    return entries;
  }

  // Compute all category IDs that belong to the pinned groups.
  final allowedCategories = categories
      .where((category) => pinnedGroupIds.contains(category.groupId))
      .map((category) => category.id)
      .toSet();

  if (allowedCategories.isEmpty) {
    return entries;
  }

  // Return only the entries whose category ID is in [allowedCategories].
  return entries.where((entry) {
    return allowedCategories.contains(vocabularyEntryCategory(entry));
  }).toList(growable: false);
});

/// A pure utility function to filter a list of entries for a specific category.
List<VocabularyWord> entriesForCategory(
  List<VocabularyWord> entries,
  String categoryId,
) {
  return entries
      .where((entry) => vocabularyEntryCategory(entry) == categoryId)
      .toList(growable: false);
}
