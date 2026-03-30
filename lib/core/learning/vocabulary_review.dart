import '../database/app_database.dart';
import 'review_logic.dart';

/// Detailed review status for a single vocabulary word.
///
/// It tracks when the word was last seen and when it should be reviewed again.
class VocabularyReviewInfo {
  const VocabularyReviewInfo({
    required this.wordId,
    required this.status,
    required this.lastResult,
    required this.leitnerBox,
    required this.reviewCount,
    required this.lapseCount,
    required this.lastReviewedAt,
    required this.nextReviewAt,
    required this.masteredAt,
  });

  final String wordId;
  final VocabularyReviewStatus status;
  final ReviewResult? lastResult;
  final int leitnerBox;
  final int reviewCount;
  final int lapseCount;
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewAt;
  final DateTime? masteredAt;

  bool get isMastered => status == VocabularyReviewStatus.mastered;

  bool get isDue => status == VocabularyReviewStatus.due;
}

/// A summary of how many words are at each learning stage (New, Due, Learning, Mastered).
class VocabularyReviewSummary {
  const VocabularyReviewSummary({
    required this.totalWords,
    required this.newCount,
    required this.dueCount,
    required this.learningCount,
    required this.masteredCount,
  });

  final int totalWords;
  final int newCount;
  final int dueCount;
  final int learningCount;
  final int masteredCount;
}

/// The complete state of the vocabulary review system.
///
/// It holds the raw data, the review info for each word, and a summary.
class VocabularyReviewState {
  const VocabularyReviewState({
    required this.wordRows,
    required this.byWordId,
    required this.summary,
  });

  final List<VocabularyWord> wordRows;
  final Map<String, VocabularyReviewInfo> byWordId;
  final VocabularyReviewSummary summary;
}

typedef VocabularyReviewFilters = ({
  String search,
  String? category,
  bool favoritesOnly,
});

/// Builds the [VocabularyReviewState] by looking at words and their progress.
VocabularyReviewState buildVocabularyReviewState({
  required List<VocabularyWord> vocabularyWords,
  required List<VocabularyProgressData> vocabularyProgress,
  required DateTime now,
}) {
  final progressByWordId = <String, VocabularyProgressData>{};
  for (final row in vocabularyProgress) {
    progressByWordId[row.wordId] = row;
  }

  final byWordId = <String, VocabularyReviewInfo>{};
  var newCount = 0;
  var dueCount = 0;
  var learningCount = 0;
  var masteredCount = 0;

  for (final word in vocabularyWords) {
    final wordId = word.id;
    final info = _buildReviewInfo(
      wordId: wordId,
      progress: progressByWordId[wordId],
      now: now,
    );
    byWordId[wordId] = info;

    switch (info.status) {
      case VocabularyReviewStatus.newWord:
        newCount++;
      case VocabularyReviewStatus.due:
        dueCount++;
      case VocabularyReviewStatus.learning:
        learningCount++;
      case VocabularyReviewStatus.mastered:
        masteredCount++;
    }
  }

  return VocabularyReviewState(
    wordRows: List<VocabularyWord>.unmodifiable(vocabularyWords),
    byWordId: Map<String, VocabularyReviewInfo>.unmodifiable(byWordId),
    summary: VocabularyReviewSummary(
      totalWords: vocabularyWords.length,
      newCount: newCount,
      dueCount: dueCount,
      learningCount: learningCount,
      masteredCount: masteredCount,
    ),
  );
}

/// Creates a list of word IDs for the user to review, sorted by priority.
///
/// It can filter by search text, category, or favorite status.
List<String> buildVocabularyReviewQueue({
  required List<VocabularyWord> vocabularyWords,
  required Map<String, VocabularyReviewInfo> reviewByWordId,
  required DateTime now,
  String search = '',
  String? category,
  bool favoritesOnly = false,
}) {
  final normalizedSearch = search.trim().toLowerCase();
  final queueItems = <_VocabularyQueueItem>[];

  for (final word in vocabularyWords) {
    final wordId = word.id;

    if (favoritesOnly && !word.isFavorite) {
      continue;
    }

    if (category != null && category.isNotEmpty && word.category != category) {
      continue;
    }

    if (normalizedSearch.isNotEmpty) {
      final haystack = [
        word.german,
        word.english,
        word.dari,
        word.category,
        word.tag,
      ].join(' ').toLowerCase();
      if (!haystack.contains(normalizedSearch)) {
        continue;
      }
    }

    final reviewInfo = reviewByWordId[wordId] ??
        _buildReviewInfo(wordId: wordId, progress: null, now: now);

    queueItems.add(_VocabularyQueueItem(
      wordId: wordId,
      german: word.german,
      reviewInfo: reviewInfo,
    ));
  }

  queueItems.sort((left, right) => _compareQueueItems(left, right, now));
  return queueItems.map((item) => item.wordId).toList(growable: false);
}

/// Returns a German label showing when the next review is scheduled.
///
/// For example: 'Jetzt fällig' (Due now) or 'Wieder in 2d'.
String formatVocabularyNextReviewLabel(
  VocabularyReviewInfo info,
  DateTime now,
) {
  if (info.isMastered) {
    return 'Gemeistert';
  }

  if (info.nextReviewAt == null) {
    return info.status == VocabularyReviewStatus.newWord
        ? 'Noch nicht gestartet'
        : 'Ohne Termin';
  }

  final delta = info.nextReviewAt!.difference(now);
  if (delta.isNegative || delta.inSeconds == 0) {
    final elapsed = delta.abs();
    if (elapsed.inMinutes < 1) {
      return 'Jetzt fällig';
    }
    return 'Überfällig seit ${_formatDuration(elapsed)}';
  }

  return 'Wieder in ${_formatDuration(delta)}';
}

VocabularyReviewInfo _buildReviewInfo({
  required String wordId,
  required VocabularyProgressData? progress,
  required DateTime now,
}) {
  if (progress == null) {
    return VocabularyReviewInfo(
      wordId: wordId,
      status: VocabularyReviewStatus.newWord,
      lastResult: null,
      leitnerBox: 0,
      reviewCount: 0,
      lapseCount: 0,
      lastReviewedAt: null,
      nextReviewAt: null,
      masteredAt: null,
    );
  }

  final status = deriveReviewStatus(
    now: now,
    nextReviewAt: progress.nextReviewAt,
    masteredAt: progress.masteredAt,
    storedStatus: progress.status,
    reviewCount: progress.reviewCount,
  );

  return VocabularyReviewInfo(
    wordId: wordId,
    status: status,
    lastResult: (progress.lastResult == null || progress.lastResult!.isEmpty)
        ? null
        : ReviewResultX.fromValue(progress.lastResult!),
    leitnerBox: progress.leitnerBox,
    reviewCount: progress.reviewCount,
    lapseCount: progress.lapseCount,
    lastReviewedAt: progress.lastReviewedAt,
    nextReviewAt: progress.nextReviewAt,
    masteredAt: progress.masteredAt,
  );
}

int _compareQueueItems(
  _VocabularyQueueItem left,
  _VocabularyQueueItem right,
  DateTime now,
) {
  final leftBucket = _queueBucket(left.reviewInfo, now);
  final rightBucket = _queueBucket(right.reviewInfo, now);
  final byBucket = leftBucket.compareTo(rightBucket);
  if (byBucket != 0) {
    return byBucket;
  }

  final byNextReview = _compareDateTime(
    left.reviewInfo.nextReviewAt,
    right.reviewInfo.nextReviewAt,
  );
  if (leftBucket <= 2 && byNextReview != 0) {
    return byNextReview;
  }

  final byGerman = left.german.compareTo(right.german);
  if (byGerman != 0) {
    return byGerman;
  }

  return left.wordId.compareTo(right.wordId);
}

int _queueBucket(VocabularyReviewInfo info, DateTime now) {
  switch (info.status) {
    case VocabularyReviewStatus.due:
      final nextReviewAt = info.nextReviewAt;
      if (nextReviewAt != null && nextReviewAt.isBefore(now)) {
        return 0;
      }
      return 1;
    case VocabularyReviewStatus.learning:
      return 2;
    case VocabularyReviewStatus.newWord:
      return 3;
    case VocabularyReviewStatus.mastered:
      return 4;
  }
}

int _compareDateTime(DateTime? left, DateTime? right) {
  if (left == null && right == null) {
    return 0;
  }
  if (left == null) {
    return 1;
  }
  if (right == null) {
    return -1;
  }
  return left.compareTo(right);
}

String _formatDuration(Duration duration) {
  if (duration.inDays >= 1) {
    return '${duration.inDays}d';
  }
  if (duration.inHours >= 1) {
    return '${duration.inHours}h';
  }
  if (duration.inMinutes >= 1) {
    return '${duration.inMinutes}m';
  }
  return '${duration.inSeconds}s';
}

class _VocabularyQueueItem {
  const _VocabularyQueueItem({
    required this.wordId,
    required this.german,
    required this.reviewInfo,
  });

  final String wordId;
  final String german;
  final VocabularyReviewInfo reviewInfo;
}

