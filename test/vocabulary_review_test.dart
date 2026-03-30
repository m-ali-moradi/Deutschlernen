import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/learning/review_logic.dart';
import 'package:deutschmate_mobile/core/learning/vocabulary_review.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calculateReviewUpdate advances boxes and masters at the top box', () {
    final now = DateTime(2026, 3, 18, 12, 0);

    final hard = calculateReviewUpdate(result: ReviewResult.hard, now: now);
    expect(hard.leitnerBox, 1);
    expect(hard.status, VocabularyReviewStatus.learning);
    expect(hard.nextReviewAt, now.add(const Duration(minutes: 10)));
    expect(hard.masteredAt, isNull);

    final easy = calculateReviewUpdate(
      result: ReviewResult.easy,
      now: now,
      current:
          const ReviewSnapshot(leitnerBox: 0, reviewCount: 0, lapseCount: 0),
    );
    expect(easy.leitnerBox, 2);
    expect(easy.status, VocabularyReviewStatus.learning);
    expect(easy.nextReviewAt, now.add(const Duration(days: 1)));

    final mastered = calculateReviewUpdate(
      result: ReviewResult.medium,
      now: now,
      current:
          const ReviewSnapshot(leitnerBox: 4, reviewCount: 3, lapseCount: 1),
    );
    expect(mastered.leitnerBox, 5);
    expect(mastered.status, VocabularyReviewStatus.mastered);
    expect(mastered.nextReviewAt, isNull);
    expect(mastered.masteredAt, now);
  });

  test('buildVocabularyReviewState and queue order due words first', () {
    final now = DateTime(2026, 3, 18, 12, 0);

    final words = [
      VocabularyWord(
        id: 'a1',
        german: 'Alpha',
        english: 'Alpha',
        dari: 'الفا',
        category: 'Cat 1',
        tag: 'Tag',
        example: '',
        context: '',
        contextDari: '',
        level: 'A1',
        difficulty: 'easy',
        isFavorite: false,
        isDifficult: false,
        updatedAt: now,
      ),
      VocabularyWord(
        id: 'a2',
        german: 'Beta',
        english: 'Beta',
        dari: 'بتا',
        category: 'Cat 1',
        tag: 'Tag',
        example: '',
        context: '',
        contextDari: '',
        level: 'A1',
        difficulty: 'easy',
        isFavorite: true,
        isDifficult: false,
        updatedAt: now,
      ),
      VocabularyWord(
        id: 'a3',
        german: 'Gamma',
        english: 'Gamma',
        dari: 'گاما',
        category: 'Cat 2',
        tag: 'Tag',
        example: '',
        context: '',
        contextDari: '',
        level: 'A1',
        difficulty: 'easy',
        isFavorite: false,
        isDifficult: false,
        updatedAt: now,
      ),
      VocabularyWord(
        id: 'a4',
        german: 'Delta',
        english: 'Delta',
        dari: 'دلتا',
        category: 'Cat 1',
        tag: 'Tag',
        example: '',
        context: '',
        contextDari: '',
        level: 'A1',
        difficulty: 'easy',
        isFavorite: false,
        isDifficult: false,
        updatedAt: now,
      ),
    ];

    final progress = [
      VocabularyProgressData(
        wordId: 'a1',
        leitnerBox: 1,
        status: 'due',
        reviewCount: 1,
        lapseCount: 0,
        nextReviewAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now,
      ),
      VocabularyProgressData(
        wordId: 'a2',
        leitnerBox: 2,
        status: 'due',
        reviewCount: 1,
        lapseCount: 0,
        nextReviewAt: now,
        updatedAt: now,
      ),
      VocabularyProgressData(
        wordId: 'a3',
        leitnerBox: 2,
        status: 'learning',
        reviewCount: 2,
        lapseCount: 0,
        nextReviewAt: now.add(const Duration(days: 1)),
        updatedAt: now,
      ),
    ];

    final state = buildVocabularyReviewState(
      vocabularyWords: words,
      vocabularyProgress: progress,
      now: now,
    );

    expect(state.summary.totalWords, 4);
    expect(state.summary.dueCount, 2);
    expect(state.summary.learningCount, 1);
    expect(state.summary.masteredCount, 0);
    expect(state.summary.newCount, 1);
    expect(state.byWordId['a4']?.status, VocabularyReviewStatus.newWord);

    final queue = buildVocabularyReviewQueue(
      vocabularyWords: words,
      reviewByWordId: state.byWordId,
      now: now,
      search: '',
      category: null,
      favoritesOnly: false,
    );

    expect(queue, ['a1', 'a2', 'a3', 'a4']);

    final filtered = buildVocabularyReviewQueue(
      vocabularyWords: words,
      reviewByWordId: state.byWordId,
      now: now,
      search: 'be',
      category: 'Cat 1',
      favoritesOnly: true,
    );

    expect(filtered, ['a2']);
    expect(
      formatVocabularyNextReviewLabel(state.byWordId['a1']!, now),
      contains('Überfällig'),
    );
  });
}
