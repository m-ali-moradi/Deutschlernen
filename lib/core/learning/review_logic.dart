/// Represents the user's self-reported difficulty for a vocabulary word during review.
///
/// This feedback drives the Spaced Repetition System (SRS) intervals.
enum ReviewResult {
  /// The user did not remember the word or found it very difficult.
  hard,

  /// The user remembered the word after some effort.
  medium,

  /// The user remembered the word immediately and with full confidence.
  easy,
}

/// The current lifecycle stage of a vocabulary word within the learning process.
enum VocabularyReviewStatus {
  /// The word has not been seen or practiced yet.
  newWord,

  /// The word is ready for a scheduled review session.
  due,

  /// The word is currently being learned (active in the SRS cycle).
  learning,

  /// The word has reached the highest proficiency level and no longer requires active scheduling.
  mastered,
}

/// The maximum level/box a word can reach in the Leitner system.
///
/// When a word reaches this box, it is considered [VocabularyReviewStatus.mastered].
const int kMaxLeitnerBox = 5;

/// Defines the wait duration before the next review for each Leitner box.
///
/// Index 0 corresponds to Box 1, Index 1 to Box 2, and so on.
/// Higher boxes have longer intervals, reinforcing long-term memory.
const List<Duration> kLeitnerIntervals = [
  Duration(minutes: 10), // Box 1: Immediate reinforcement
  Duration(days: 1), // Box 2: Next day
  Duration(days: 3), // Box 3: 3 days later
  Duration(days: 7), // Box 4: 1 week later
  Duration(days: 14), // Box 5: 2 weeks later
];

extension ReviewResultX on ReviewResult {
  /// Serializes the enum to a string value for database storage.
  String get value => switch (this) {
        ReviewResult.hard => 'hard',
        ReviewResult.medium => 'medium',
        ReviewResult.easy => 'easy',
      };

  /// Deserializes a string value from the database into a [ReviewResult].
  static ReviewResult? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    return switch (value.toLowerCase()) {
      'hard' => ReviewResult.hard,
      'medium' => ReviewResult.medium,
      'easy' => ReviewResult.easy,
      _ => null,
    };
  }
}

extension VocabularyReviewStatusX on VocabularyReviewStatus {
  /// Serializes the status to a string value for database storage.
  String get value => switch (this) {
        VocabularyReviewStatus.newWord => 'new',
        VocabularyReviewStatus.due => 'due',
        VocabularyReviewStatus.learning => 'learning',
        VocabularyReviewStatus.mastered => 'mastered',
      };

  /// Returns the localized German label for the status to be shown in the UI.
  String get label => switch (this) {
        VocabularyReviewStatus.newWord => 'Neu',
        VocabularyReviewStatus.due => 'Fällig',
        VocabularyReviewStatus.learning => 'In Arbeit',
        VocabularyReviewStatus.mastered => 'Gemeistert',
      };
}

/// A snapshot of the current review metrics for a vocabulary word.
///
/// Used as input for calculating the next review interval.
class ReviewSnapshot {
  const ReviewSnapshot({
    required this.leitnerBox,
    required this.reviewCount,
    required this.lapseCount,
  });

  /// The current box in the Leitner system (1 to [kMaxLeitnerBox]).
  final int leitnerBox;

  /// Total number of times this word has been reviewed.
  final int reviewCount;

  /// Total number of times the user marked this word as [ReviewResult.hard].
  final int lapseCount;
}

/// Contains the calculated updates for a vocabulary word's progress after a review session.
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

  /// The new Leitner box the word has moved to.
  final int leitnerBox;

  /// The updated learning status.
  final VocabularyReviewStatus status;

  /// The most recent feedback provided by the user.
  final ReviewResult lastResult;

  /// The updated total review count.
  final int reviewCount;

  /// The updated lapse count (increments on 'hard' result).
  final int lapseCount;

  /// The exact time when this review occurred.
  final DateTime lastReviewedAt;

  /// The calculated time when the word should be reviewed again.
  /// Null if the word is [VocabularyReviewStatus.mastered].
  final DateTime? nextReviewAt;

  /// The time when the word reached [kMaxLeitnerBox], if applicable.
  final DateTime? masteredAt;
}

/// Calculates the next review schedule for a word based on the user's feedback.
///
/// Implementation of the **Leitner System**:
/// - [ReviewResult.hard]: Resets the word to Box 1 for immediate restudy.
/// - [ReviewResult.medium]: Advances the word by 1 box.
/// - [ReviewResult.easy]: Advances the word by 2 boxes, rewarding confidence.
///
/// Returns a [ReviewUpdate] containing the new database values.
ReviewUpdate calculateReviewUpdate({
  required ReviewResult result,
  required DateTime now,
  ReviewSnapshot? current,
}) {
  final currentBox = current?.leitnerBox ?? 0;
  final nextReviewCount = (current?.reviewCount ?? 0) + 1;
  final nextLapseCount =
      (current?.lapseCount ?? 0) + (result == ReviewResult.hard ? 1 : 0);

  // Determine the next box based on the feedback complexity.
  final nextBox = switch (result) {
    ReviewResult.hard => 1,
    ReviewResult.medium =>
      currentBox <= 0 ? 1 : (currentBox + 1).clamp(1, kMaxLeitnerBox),
    ReviewResult.easy =>
      currentBox <= 0 ? 2 : (currentBox + 2).clamp(1, kMaxLeitnerBox),
  };

  // If we've reached the maximum proficiency level, mark as mastered.
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

  // Calculate the next interval based on the newly assigned box.
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

/// Dynamically determines the current display status of a word based on its timestamps and storage.
///
/// This allows the UI to show 'Fällig' (Due) if the [nextReviewAt] date has passed,
/// without requiring a background database update.
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

/// Assigns a priority integer for sorting vocabulary in the UI.
///
/// Priority: [due] (0) > [learning] (1) > [newWord] (2) > [mastered] (3).
int reviewPriorityForStatus(VocabularyReviewStatus status) => switch (status) {
      VocabularyReviewStatus.due => 0,
      VocabularyReviewStatus.learning => 1,
      VocabularyReviewStatus.newWord => 2,
      VocabularyReviewStatus.mastered => 3,
    };

