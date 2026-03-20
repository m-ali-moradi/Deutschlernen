/// The result of a vocabulary review chosen by the user.
///
/// 'Hard' means the user forgot the word.
/// 'Easy' means the user knows it very well.
enum ReviewResult { hard, medium, easy }

/// The current status of a word in the review system.
enum VocabularyReviewStatus { newWord, due, learning, mastered }

const int kMaxLeitnerBox = 5;
const List<Duration> kLeitnerIntervals = [
  Duration(minutes: 10),
  Duration(days: 1),
  Duration(days: 3),
  Duration(days: 7),
  Duration(days: 14),
];

extension ReviewResultX on ReviewResult {
  String get value => switch (this) {
        ReviewResult.hard => 'hard',
        ReviewResult.medium => 'medium',
        ReviewResult.easy => 'easy',
      };

  static ReviewResult fromValue(String value) => switch (value) {
        'hard' => ReviewResult.hard,
        'easy' => ReviewResult.easy,
        _ => ReviewResult.medium,
      };
}

extension VocabularyReviewStatusX on VocabularyReviewStatus {
  String get value => switch (this) {
        VocabularyReviewStatus.newWord => 'new',
        VocabularyReviewStatus.due => 'due',
        VocabularyReviewStatus.learning => 'learning',
        VocabularyReviewStatus.mastered => 'mastered',
      };

  String get label => switch (this) {
        VocabularyReviewStatus.newWord => 'Neu',
        VocabularyReviewStatus.due => 'Fällig',
        VocabularyReviewStatus.learning => 'In Arbeit',
        VocabularyReviewStatus.mastered => 'Gemeistert',
      };
}

/// A small piece of data showing the current review state for a word.
class ReviewSnapshot {
  const ReviewSnapshot({
    required this.leitnerBox,
    required this.reviewCount,
    required this.lapseCount,
  });

  final int leitnerBox;
  final int reviewCount;
  final int lapseCount;
}

/// The new review data for a word after the user practices it.
class ReviewUpdate {
  const ReviewUpdate({
    required this.leitnerBox,
    required this.status,
    required this.lastResult,
    required this.reviewCount,
    required this.lapseCount,
    required this.lastReviewedAt,
    required this.nextReviewAt,
    required this.masteredAt,
  });

  final int leitnerBox;
  final VocabularyReviewStatus status;
  final ReviewResult lastResult;
  final int reviewCount;
  final int lapseCount;
  final DateTime lastReviewedAt;
  final DateTime? nextReviewAt;
  final DateTime? masteredAt;
}

/// Calculates when the user should review a word next.
///
/// It uses the Leitner system. Easy words are reviewed less often.
ReviewUpdate calculateReviewUpdate({
  required ReviewResult result,
  required DateTime now,
  ReviewSnapshot? current,
}) {
  final currentBox = current?.leitnerBox ?? 0;
  final nextReviewCount = (current?.reviewCount ?? 0) + 1;
  final nextLapseCount =
      (current?.lapseCount ?? 0) + (result == ReviewResult.hard ? 1 : 0);

  final nextBox = switch (result) {
    ReviewResult.hard => 1,
    ReviewResult.medium =>
      currentBox <= 0 ? 1 : (currentBox + 1).clamp(1, kMaxLeitnerBox),
    ReviewResult.easy =>
      currentBox <= 0 ? 2 : (currentBox + 2).clamp(1, kMaxLeitnerBox),
  };

  if (nextBox >= kMaxLeitnerBox) {
    return ReviewUpdate(
      leitnerBox: kMaxLeitnerBox,
      status: VocabularyReviewStatus.mastered,
      lastResult: result,
      reviewCount: nextReviewCount,
      lapseCount: nextLapseCount,
      lastReviewedAt: now,
      nextReviewAt: null,
      masteredAt: now,
    );
  }

  return ReviewUpdate(
    leitnerBox: nextBox,
    status: VocabularyReviewStatus.learning,
    lastResult: result,
    reviewCount: nextReviewCount,
    lapseCount: nextLapseCount,
    lastReviewedAt: now,
    nextReviewAt: now.add(kLeitnerIntervals[nextBox - 1]),
    masteredAt: null,
  );
}

/// Figures out the current status of a word (e.g., 'due' or 'mastered').
VocabularyReviewStatus deriveReviewStatus({
  required DateTime now,
  DateTime? nextReviewAt,
  DateTime? masteredAt,
  String? storedStatus,
  int reviewCount = 0,
}) {
  if (masteredAt != null || storedStatus == 'mastered') {
    return VocabularyReviewStatus.mastered;
  }

  if (nextReviewAt != null && !nextReviewAt.isAfter(now)) {
    return VocabularyReviewStatus.due;
  }

  if (storedStatus == 'due') {
    return VocabularyReviewStatus.due;
  }

  if (reviewCount > 0 || storedStatus == 'learning') {
    return VocabularyReviewStatus.learning;
  }

  return VocabularyReviewStatus.newWord;
}

int reviewPriorityForStatus(VocabularyReviewStatus status) => switch (status) {
      VocabularyReviewStatus.due => 0,
      VocabularyReviewStatus.learning => 1,
      VocabularyReviewStatus.newWord => 2,
      VocabularyReviewStatus.mastered => 3,
    };
