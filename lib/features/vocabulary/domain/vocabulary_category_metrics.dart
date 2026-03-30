import 'dart:math';

import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/learning/review_logic.dart';
import 'package:deutschmate_mobile/core/learning/vocabulary_review.dart';

/// Extracts the category identifier from a vocabulary word.
String vocabularyEntryCategory(VocabularyWord entry) {
  return entry.category;
}

/// Aggregates vocabulary counts for an entire [VocabularyGroupEntity].
///
/// Groups act as top-level collections (e.g., "A1 Core") containing multiple categories.
int vocabularyCountForGroup(
  List<VocabularyWord> entries,
  List<VocabularyCategoryEntity> categories,
  String groupId,
) {
  final categoryIds = categories
      .where((category) => category.groupId == groupId)
      .map((category) => category.id)
      .toSet();

  return entries.where((entry) {
    return categoryIds.contains(vocabularyEntryCategory(entry));
  }).length;
}

/// Counts the total number of words that have been successfully reviewed or are in the SRS cycle.
///
/// Unlike 'Easy', this includes all words that have some review history (Hard, Medium, or Easy).
int vocabularyCategoryLearnedCount(
  List<VocabularyWord> entries,
  Map<String, VocabularyReviewInfo> reviewById,
  String categoryId,
  Map<String, ReviewResult> optimisticReviewResults,
) {
  return entries
      .where(
        (entry) =>
            vocabularyEntryCategory(entry) == categoryId &&
            (optimisticReviewResults.containsKey(entry.id) ||
                (reviewById[entry.id]?.reviewCount ?? 0) > 0),
      )
      .length;
}

/// Generates a localized summary label for a vocabulary category card.
///
/// Displays progress as `Learned / Total` followed by a breakdown of current SRS Box states.
String vocabularyCategoryCountLabel({
  required AppUiText strings,
  required int learned,
  required int total,
}) {
  return '$learned / $total ${strings.either(german: 'gelernte Wörter', english: 'words learned')}';
}

/// Determines the current review status of a word, prioritizing pending optimistic updates.
///
/// This prevents UI lag by allowing users to see their progress immediately even before
/// the database write has fully finalized.
ReviewResult? vocabularyReviewResultForWord(
  Map<String, ReviewResult> optimisticReviewResults,
  Map<String, VocabularyReviewInfo> reviewById,
  String wordId,
) {
  return optimisticReviewResults[wordId] ?? reviewById[wordId]?.lastResult;
}

/// Determines the current review status of a word, prioritizing pending optimistic updates.
/// Counts the number of words in a category that the user has marked as 'Easy' in SRS.
int vocabularyCategoryEasyCount(
  List<VocabularyWord> entries,
  Map<String, VocabularyReviewInfo> reviewById,
  String categoryId,
  Map<String, ReviewResult> optimisticReviewResults,
) {
  return entries
      .where(
        (entry) =>
            vocabularyEntryCategory(entry) == categoryId &&
            vocabularyReviewResultForWord(
                  optimisticReviewResults,
                  reviewById,
                  entry.id,
                ) ==
                ReviewResult.easy,
      )
      .length;
}

/// Generic counter for vocabulary words matching a specific [ReviewResult] within a category.
int vocabularyCategoryResultCount(
  List<VocabularyWord> entries,
  Map<String, VocabularyReviewInfo> reviewById,
  String categoryId,
  ReviewResult result,
  Map<String, ReviewResult> optimisticReviewResults,
) {
  return entries
      .where(
        (entry) =>
            vocabularyEntryCategory(entry) == categoryId &&
            vocabularyReviewResultForWord(
                  optimisticReviewResults,
                  reviewById,
                  entry.id,
                ) ==
                result,
      )
      .length;
}

/// Returns the total number of words belonging to the specified [categoryId].
int vocabularyCategoryTotalCount(
  List<VocabularyWord> entries,
  String categoryId,
) {
  return entries
      .where((entry) => vocabularyEntryCategory(entry) == categoryId)
      .length;
}

/// Constructs an optimized flashcard queue based on common learning heuristics.
///
/// The algorithm:
/// 1. Filters for 'Hard' and 'Medium' words based on recent performance.
/// 2. Shuffles these prioritized words to keep the session fresh.
/// 3. Appends all other words in the category at the end of the list.
///
/// If no words require priority review, the entire list is returned as-is.
List<String> vocabularyPriorityFlashcardQueue(
  List<VocabularyWord> entries,
  Map<String, VocabularyReviewInfo> reviewById,
  Map<String, ReviewResult> optimisticReviewResults,
) {
  final priority = <VocabularyWord>[];

  for (final entry in entries) {
    final result = vocabularyReviewResultForWord(
      optimisticReviewResults,
      reviewById,
      entry.id,
    );
    if (result == ReviewResult.hard || result == ReviewResult.medium) {
      priority.add(entry);
    }
  }

  if (priority.isEmpty) {
    return entries.map((entry) => entry.id).toList(growable: false);
  }

  priority.shuffle(Random());

  final priorityIds = priority.map((entry) => entry.id).toList(growable: false);
  final priorityIdSet = priorityIds.toSet();
  final restIds = entries
      .map((entry) => entry.id)
      .where((id) => !priorityIdSet.contains(id))
      .toList(growable: false);

  return [...priorityIds, ...restIds];
}
