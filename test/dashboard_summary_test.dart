import 'package:deutschlernen_mobile/features/learning_path/domain/dashboard_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dashboard summary derives live counts from persisted rows', () {
    final now = DateTime(2026, 3, 18, 12, 0);

    final summary = buildDashboardSummary(
      vocabularyWords: const [
        {'id': 'w1'},
        {'id': 'w2'},
        {'id': 'w3'},
      ],
      vocabularyProgress: [
        {
          'word_id': 'w1',
          'status': 'mastered',
          'mastered_at': now.subtract(const Duration(days: 1)),
          'review_count': 3,
          'next_review_at': null,
        },
        {
          'word_id': 'w2',
          'status': 'learning',
          'review_count': 1,
          'next_review_at': now.add(const Duration(hours: 3)),
        },
        {
          'word_id': 'w3',
          'status': 'due',
          'review_count': 2,
          'next_review_at': now.subtract(const Duration(hours: 2)),
        },
      ],
      grammarTopics: const [
        {'progress': 100},
        {'progress': 40},
      ],
      exercises: const [
        {'id': 'e1'},
        {'id': 'e2'},
        {'id': 'e3'},
      ],
      exerciseAttempts: [
        {
          'topic': 'Kasus',
          'is_correct': true,
          'answered_at': now.subtract(const Duration(days: 1)),
        },
        {
          'topic': 'Konjunktiv',
          'is_correct': false,
          'answered_at': now.subtract(const Duration(days: 2)),
        },
        {
          'topic': 'Konjunktiv',
          'is_correct': false,
          'answered_at': now.subtract(const Duration(days: 3)),
        },
      ],
      achievements: const [
        {'unlocked': true},
        {'unlocked': false},
      ],
      userStats: const {
        'xp': 100,
        'level': 'A1',
      },
      now: now,
    );

    expect(summary.wordsLearned, 1);
    expect(summary.vocabularyMasteredCount, 1);
    expect(summary.vocabularyDueCount, 1);
    expect(summary.vocabularyLearningCount, 1);
    expect(summary.vocabularyNewCount, 0);
    expect(summary.grammarCompletedCount, 1);
    expect(summary.exerciseAttemptCount, 3);
    expect(summary.exerciseCorrectCount, 1);
    expect(summary.exerciseIncorrectCount, 2);
    expect(summary.achievementUnlockedCount, 1);
    expect(summary.weakAreas, ['Konjunktiv II']);
    expect(summary.weeklyProgress, greaterThan(0));
  });

  test('dashboard next action prefers due words and weak areas', () {
    final dueSummary = DashboardSummary(
      xp: 0,
      level: 'A1',
      wordsLearned: 0,
      vocabularyMasteredCount: 0,
      vocabularyDueCount: 4,
      vocabularyNewCount: 10,
      vocabularyLearningCount: 2,
      exerciseAttemptCount: 0,
      exerciseCorrectCount: 0,
      exerciseIncorrectCount: 0,
      grammarCompletedCount: 0,
      achievementTotalCount: 6,
      achievementUnlockedCount: 1,
      weeklyProgress: 0,
      weakAreas: const ['Konjunktiv'],
    );

    final weakSummary = DashboardSummary(
      xp: 0,
      level: 'A1',
      wordsLearned: 0,
      vocabularyMasteredCount: 0,
      vocabularyDueCount: 0,
      vocabularyNewCount: 10,
      vocabularyLearningCount: 2,
      exerciseAttemptCount: 1,
      exerciseCorrectCount: 0,
      exerciseIncorrectCount: 1,
      grammarCompletedCount: 0,
      achievementTotalCount: 6,
      achievementUnlockedCount: 1,
      weeklyProgress: 0,
      weakAreas: const ['Konjunktiv'],
    );

    final noWeakSummary = DashboardSummary(
      xp: 0,
      level: 'A1',
      wordsLearned: 0,
      vocabularyMasteredCount: 0,
      vocabularyDueCount: 0,
      vocabularyNewCount: 10,
      vocabularyLearningCount: 2,
      exerciseAttemptCount: 0,
      exerciseCorrectCount: 0,
      exerciseIncorrectCount: 0,
      grammarCompletedCount: 0,
      achievementTotalCount: 6,
      achievementUnlockedCount: 1,
      weeklyProgress: 0,
      weakAreas: const [],
    );

    final dueAction = buildDashboardNextAction(dueSummary);
    expect(dueAction.title, 'Vokabeln wiederholen');
    expect(dueAction.route, '/vocabulary?tab=words');

    final weakAction = buildDashboardNextAction(weakSummary);
    expect(weakAction.title, 'Schwachstelle bearbeiten');
    expect(weakAction.route, '/grammar?category=Konjunktiv&showFilters=1');

    final fallbackAction = buildDashboardNextAction(noWeakSummary);
    expect(fallbackAction.title, 'Grammatik fortsetzen');
    expect(fallbackAction.route, '/grammar');
  });
}
