import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/features/learning_path/domain/dashboard_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dashboard summary derives live counts from persisted rows', () {
    final now = DateTime(2026, 3, 18, 12, 0);

    final summary = buildDashboardSummary(
      vocabularyWords: [
        VocabularyWord(
          id: 'w1',
          german: 'G1',
          english: 'E1',
          dari: 'D1',
          category: 'C1',
          tag: 'T1',
          example: 'Ex1',
          context: 'Cx1',
          contextDari: 'CD1',
          level: 'A1',
          difficulty: 'easy',
          isFavorite: false,
          isDifficult: false,
          updatedAt: now,
        ),
        VocabularyWord(
          id: 'w2',
          german: 'G2',
          english: 'E2',
          dari: 'D2',
          category: 'C2',
          tag: 'T2',
          example: 'Ex2',
          context: 'Cx2',
          contextDari: 'CD2',
          level: 'A1',
          difficulty: 'easy',
          isFavorite: false,
          isDifficult: false,
          updatedAt: now,
        ),
        VocabularyWord(
          id: 'w3',
          german: 'G3',
          english: 'E3',
          dari: 'D3',
          category: 'C3',
          tag: 'T3',
          example: 'Ex3',
          context: 'Cx3',
          contextDari: 'CD3',
          level: 'A1',
          difficulty: 'easy',
          isFavorite: false,
          isDifficult: false,
          updatedAt: now,
        ),
      ],
      vocabularyProgress: [
        VocabularyProgressData(
          wordId: 'w1',
          status: 'mastered',
          masteredAt: now.subtract(const Duration(days: 1)),
          reviewCount: 3,
          lapseCount: 0,
          leitnerBox: 5,
          nextReviewAt: null,
          updatedAt: now,
        ),
        VocabularyProgressData(
          wordId: 'w2',
          status: 'learning',
          reviewCount: 1,
          lapseCount: 0,
          leitnerBox: 2,
          nextReviewAt: now.add(const Duration(hours: 3)),
          updatedAt: now,
        ),
        VocabularyProgressData(
          wordId: 'w3',
          status: 'due',
          reviewCount: 2,
          lapseCount: 0,
          leitnerBox: 1,
          nextReviewAt: now.subtract(const Duration(hours: 2)),
          updatedAt: now,
        ),
      ],
      grammarTopics: [
        GrammarTopic(
          id: 'g1',
          title: 'Kasus',
          level: 'A1',
          category: 'Basics',
          icon: 'icon',
          rule: 'rule',
          explanation: 'explanation',
          examplesJson: '[]',
          progress: 100,
          updatedAt: now,
        ),
        GrammarTopic(
          id: 'g2',
          title: 'Konjunktiv II',
          level: 'B1',
          category: 'Advanced',
          icon: 'icon',
          rule: 'rule',
          explanation: 'explanation',
          examplesJson: '[]',
          progress: 40,
          updatedAt: now,
        ),
      ],
      exercises: [
        Exercise(
          id: 'e1',
          type: 'multi',
          question: 'Q1',
          optionsJson: '[]',
          correctAnswer: 0,
          topic: 'Kasus',
          level: 'A1',
          updatedAt: now,
        ),
        Exercise(
          id: 'e2',
          type: 'multi',
          question: 'Q2',
          optionsJson: '[]',
          correctAnswer: 0,
          topic: 'Konjunktiv II',
          level: 'B1',
          updatedAt: now,
        ),
        Exercise(
          id: 'e3',
          type: 'multi',
          question: 'Q3',
          optionsJson: '[]',
          correctAnswer: 0,
          topic: 'Konjunktiv II',
          level: 'B1',
          updatedAt: now,
        ),
      ],
      exerciseAttempts: [
        ExerciseAttempt(
          id: 1,
          exerciseId: 'e1',
          scope: 'exercises',
          topic: 'Kasus',
          level: 'A1',
          isCorrect: true,
          answeredAt: now.subtract(const Duration(days: 1)),
        ),
        ExerciseAttempt(
          id: 2,
          exerciseId: 'e2',
          scope: 'exercises',
          topic: 'Konjunktiv II',
          level: 'B1',
          isCorrect: false,
          answeredAt: now.subtract(const Duration(days: 2)),
        ),
        ExerciseAttempt(
          id: 3,
          exerciseId: 'e3',
          scope: 'exercises',
          topic: 'Konjunktiv II',
          level: 'B1',
          isCorrect: false,
          answeredAt: now.subtract(const Duration(days: 3)),
        ),
      ],
      achievements: [
        Achievement(
          id: 'a1',
          title: 'T1',
          description: 'D1',
          icon: 'I1',
          unlocked: true,
          updatedAt: now,
        ),
        Achievement(
          id: 'a2',
          title: 'T2',
          description: 'D2',
          icon: 'I2',
          unlocked: false,
          updatedAt: now,
        ),
      ],
      userStats: UserStat(
        id: 1,
        xp: 100,
        level: 'A1',
        streak: 5,
        wordsLearned: 10,
        exercisesCompleted: 20,
        grammarTopicsCompleted: 5,
        weeklyProgress: 50,
        weakAreasJson: '[]',
        updatedAt: now,
      ),
      now: now,
    );

    expect(summary.wordsLearned, 3);
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
