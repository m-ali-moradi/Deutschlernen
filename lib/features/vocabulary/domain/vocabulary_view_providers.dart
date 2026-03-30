/// This file contains presentation-specific providers and utilities for the vocabulary feature.
/// 
/// These providers are responsible for bridging the gap between raw data providers
/// and the user interface. They handle tasks like filtering lists based on user 
/// selections (e.g., pinned groups, tabs) and safely parsing data objects.
/// 
/// Extracting this logic here ensures the UI widgets remain clean, highly cohesive,
/// focused solely on rendering, and makes testing the business logic much easier.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/content/sync/sync_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/learning/review_logic.dart'; // provides ReviewResult
import 'vocabulary_providers.dart';
import 'vocabulary_category_metrics.dart'; // provides vocabularyEntryCategory

/// Holds short-lived optimistic review state to immediately reflect user choices 
/// (e.g., swiping "Easy") in the UI before they are fully persisted to the database.
final vocabularyOptimisticReviewsProvider = StateProvider<Map<String, ReviewResult>>((ref) => {});

/// Provides a list of vocabulary entries filtered by the currently pinned groups.
/// 
/// If there are no pinned groups, it simply returns all available filtered entries.
/// Otherwise, it cross-references the pinned group IDs with the available 
/// categories to emit only words that belong to the user's selected groups.
/// This prevents the UI from having to recalculate lists on every build.
final visibleVocabularyEntriesProvider = Provider<List<SyncEntry<VocabularyWord>>>((ref) {
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
  }).toList();
});

/// A utility function to safely extract a [VocabularyWord] from a [SyncEntry].
/// 
/// This function centralizes the fallback logic: it first attempts to use
/// the locally cached data. If that is unavailable, it gracefully falls back 
/// to parsing the cloud metadata maps. This heavily reduces boilerplate in the UI.
VocabularyWord extractWordFromEntry(SyncEntry<VocabularyWord> entry) {
  final local = entry.localData;
  if (local != null) {
    return local;
  }

  // Safely parse cloud metadata avoiding null pointer errors.
  final metadata = entry.cloudMetadata ?? const <String, dynamic>{};
  return VocabularyWord(
    id: entry.id,
    german: metadata['german']?.toString() ?? '',
    english: metadata['english']?.toString() ?? '',
    dari: metadata['dari']?.toString() ?? '',
    category: metadata['category']?.toString() ?? '',
    tag: metadata['tag']?.toString() ?? '',
    example: metadata['example']?.toString() ?? '',
    context: metadata['context']?.toString() ?? '',
    contextDari: metadata['context_dari']?.toString() ?? '',
    level: metadata['level']?.toString() ?? 'A1',
    difficulty: metadata['difficulty']?.toString() ?? 'medium',
    isFavorite: (metadata['is_favorite'] as bool?) ?? false,
    isDifficult: (metadata['is_difficult'] as bool?) ?? false,
    updatedAt: DateTime.tryParse(metadata['updated_at']?.toString() ?? '') ??
        DateTime.now(),
  );
}

/// A pure utility function to filter a list of entries for a specific category.
List<SyncEntry<VocabularyWord>> entriesForCategory(
  List<SyncEntry<VocabularyWord>> entries,
  String categoryId,
) {
  return entries
      .where((entry) => vocabularyEntryCategory(entry) == categoryId)
      .toList(growable: false);
}
