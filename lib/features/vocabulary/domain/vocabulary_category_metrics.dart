import 'dart:math';

import '../../../../shared/localization/app_ui_text.dart';
import '../../../core/database/app_database.dart';
import '../../../core/learning/review_logic.dart';
import '../../../core/learning/vocabulary_review.dart';
import '../../../core/content/sync/sync_service.dart';

/// Converts live Firestore metadata into the same entry model used by cached
/// vocabulary rows.
List<SyncEntry<VocabularyWord>> vocabularyEntriesFromRemoteCategoryData(
  List<Map<String, dynamic>> remoteWords,
  String categoryId,
) {
  return remoteWords
      .map(
        (metadata) => SyncEntry<VocabularyWord>(
          id: metadata['id']?.toString() ?? '',
          cloudMetadata: metadata,
          isDownloaded: false,
        ),
      )
      .where((entry) => vocabularyEntryCategory(entry) == categoryId)
      .toList(growable: false);
}

/// Returns the category id for either a cached word or a remote entry.
String vocabularyEntryCategory(SyncEntry<VocabularyWord> entry) {
  return entry.localData?.category ??
      entry.cloudMetadata?['category']?.toString() ??
      '';
}

/// Counts the vocabulary entries that belong to a specific group.
int vocabularyCountForGroup(
  List<SyncEntry<VocabularyWord>> entries,
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

/// Builds the category count label shown under each vocabulary card.
String vocabularyCategoryCountLabel({
  required AppUiText strings,
  required int easy,
  required int total,
  required int medium,
  required int hard,
}) {
  return '$easy / $total ${strings.either(german: 'leichte Wörter', english: 'easy words')} · '
      '$medium ${strings.either(german: 'mittel', english: 'medium')} · '
      '$hard ${strings.either(german: 'schwer', english: 'hard')}';
}

/// Resolves the current review result, including optimistic updates.
ReviewResult? vocabularyReviewResultForWord(
  Map<String, ReviewResult> optimisticReviewResults,
  Map<String, VocabularyReviewInfo> reviewById,
  String wordId,
) {
  return optimisticReviewResults[wordId] ?? reviewById[wordId]?.lastResult;
}

/// Counts easy-reviewed vocabulary entries within a category.
int vocabularyCategoryEasyCount(
  List<SyncEntry<VocabularyWord>> entries,
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

/// Counts vocabulary entries for a specific review result.
int vocabularyCategoryResultCount(
  List<SyncEntry<VocabularyWord>> entries,
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

/// Counts all vocabulary entries within a category.
int vocabularyCategoryTotalCount(
  List<SyncEntry<VocabularyWord>> entries,
  String categoryId,
) {
  return entries
      .where((entry) => vocabularyEntryCategory(entry) == categoryId)
      .length;
}

/// Builds the review queue that prioritizes hard and medium words first.
List<String> vocabularyPriorityFlashcardQueue(
  List<SyncEntry<VocabularyWord>> entries,
  Map<String, VocabularyReviewInfo> reviewById,
  Map<String, ReviewResult> optimisticReviewResults,
) {
  final priority = <SyncEntry<VocabularyWord>>[];

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
