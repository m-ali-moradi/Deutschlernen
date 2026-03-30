import 'package:deutschmate_mobile/core/database/app_database.dart';

/// Encapsulates all the user's learning metrics for display on the Home screen dashboard.
class DashboardSummary {
  const DashboardSummary({
    required this.xp,
    required this.level,
    required this.wordsLearned,
    required this.vocabularyMasteredCount,
    required this.vocabularyDueCount,
    required this.vocabularyNewCount,
    required this.vocabularyLearningCount,
    required this.exerciseAttemptCount,
    required this.exerciseCorrectCount,
    required this.exerciseIncorrectCount,
    required this.grammarCompletedCount,
    required this.achievementTotalCount,
    required this.achievementUnlockedCount,
    required this.weeklyProgress,
    required this.weakAreas,
  });

  /// Total experience points earned by the user.
  final int xp;

  /// The current German level (A1, A2, etc.) of the user.
  final String level;

  /// Count of words that have been started (status is not 'new').
  final int wordsLearned;

  /// Count of vocabulary words that have reached the 'mastered' level in the SRS.
  final int vocabularyMasteredCount;

  /// Count of words currently scheduled for a review session.
  final int vocabularyDueCount;

  /// Count of words that haven't been seen by the user yet.
  final int vocabularyNewCount;

  /// Count of words that are in the middle of being learned (active boxes in SRS).
  final int vocabularyLearningCount;

  /// Total number of exercises the user has attempted across all time.
  final int exerciseAttemptCount;

  /// Count of exercises answered correctly.
  final int exerciseCorrectCount;

  /// Count of exercises answered incorrectly.
  final int exerciseIncorrectCount;

  /// Number of grammar topics fully completed (progress = 100%).
  final int grammarCompletedCount;

  /// Total number of achievements available in the app.
  final int achievementTotalCount;

  /// Number of achievements currently unlocked by the user.
  final int achievementUnlockedCount;

  /// A percentage (0-100) representing how much of the weekly target has been met.
  final int weeklyProgress;

  /// Top 3 grammar topics where the user has struggled recently.
  final List<String> weakAreas;
}

/// Represents the most relevant next action for the user to take, suggested by the dashboard.
class DashboardNextAction {
  const DashboardNextAction({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.route,
    required this.icon,
  });

  /// Main heading for the recommendation.
  final String title;

  /// Contextual details like "X words are due".
  final String subtitle;

  /// Label for the action button.
  final String ctaLabel;

  /// The internal route to navigate to.
  final String route;

  /// Suggested icon/emoji for visual identification.
  final String icon;
}

/// Computes the complete learning state represented by [DashboardSummary].
///
/// This involves:
/// 1. Mapping vocabulary words to their progress snapshots.
/// 2. Analyzing exercise history to find errors (identifying weak areas).
/// 3. Calculating weekly progress against targets (50 weekly questions).
/// 4. Aggregating grammar and achievement status.
DashboardSummary buildDashboardSummary({
  required UserStat userStats,
  required List<VocabularyWord> vocabularyWords,
  required List<VocabularyProgressData> vocabularyProgress,
  required List<GrammarTopic> grammarTopics,
  required List<Exercise> exercises,
  required List<ExerciseAttempt> exerciseAttempts,
  required List<Achievement> achievements,
  required DateTime now,
}) {
  final progressByWordId = <String, VocabularyProgressData>{};
  for (final row in vocabularyProgress) {
    progressByWordId[row.wordId] = row;
  }

  final learnedCount = progressByWordId.values.where((row) {
    return row.status != 'new';
  }).length;

  final masteredCount = progressByWordId.values.where((row) {
    return row.status == 'mastered' || row.masteredAt != null;
  }).length;

  final dueCount = progressByWordId.values.where((row) {
    if (row.status == 'mastered' || row.masteredAt != null) {
      return false;
    }
    return row.nextReviewAt != null && !row.nextReviewAt!.isAfter(now);
  }).length;

  final learningCount = progressByWordId.values.where((row) {
    if (row.status == 'mastered' || row.masteredAt != null) {
      return false;
    }
    return row.status == 'learning' ||
        (row.reviewCount > 0 &&
            (row.nextReviewAt == null || row.nextReviewAt!.isAfter(now)));
  }).length;

  final newCount = (vocabularyWords.length - progressByWordId.length)
      .clamp(0, vocabularyWords.length)
      .toInt();
  final grammarCompletedCount =
      grammarTopics.where((row) => row.progress >= 100).length;
  final exerciseScopeAttempts =
      exerciseAttempts.where((row) => row.scope == 'exercises').toList();
  final exerciseAttemptCount = exerciseScopeAttempts.length;
  final exerciseCorrectCount =
      exerciseScopeAttempts.where((row) => row.isCorrect).length;
  final exerciseIncorrectCount = exerciseAttemptCount - exerciseCorrectCount;
  final achievementUnlockedCount =
      achievements.where((row) => row.unlocked).length;
  final achievementTotalCount = achievements.length;

  // Weak area identification: 14-day window for recent struggles.
  final recentWindow = now.subtract(const Duration(days: 14));
  final recentIncorrectAttempts = exerciseScopeAttempts.where((row) {
    return !row.isCorrect && !row.answeredAt.isBefore(recentWindow);
  }).toList();
  final weakSource = recentIncorrectAttempts.isNotEmpty
      ? recentIncorrectAttempts
      : exerciseScopeAttempts.where((row) => !row.isCorrect).toList();

  final exerciseById = <String, Exercise>{};
  for (final row in exercises) {
    exerciseById[row.id] = row;
  }

  // Correlate failed exercises with their parent grammar topics.
  final validGrammarTitles = grammarTopics.map((row) => row.title).toSet();
  final weakGrammarAreaCounts = <String, int>{};
  for (final row in weakSource) {
    final grammarTitle = _grammarTitleForAttempt(
      exerciseAttempt: row,
      exerciseById: exerciseById,
      grammarTopics: grammarTopics,
    );

    if (grammarTitle != null && validGrammarTitles.contains(grammarTitle)) {
      weakGrammarAreaCounts[grammarTitle] =
          (weakGrammarAreaCounts[grammarTitle] ?? 0) + 1;
    }
  }

  final weakGrammarAreas = weakGrammarAreaCounts.entries.toList()
    ..sort((left, right) {
      final byCount = right.value.compareTo(left.value);
      if (byCount != 0) return byCount;
      return left.key.compareTo(right.key);
    });

  final weakAreas = weakGrammarAreas.map((entry) => entry.key).toList();

  // Weekly progress calculation: 60% based on volume (0-50 questions) and 40% based on accuracy.
  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  final weekStartTime =
      DateTime(weekStart.year, weekStart.month, weekStart.day);
  final thisWeekAttempts = exerciseScopeAttempts.where((row) {
    return !row.answeredAt.isBefore(weekStartTime);
  }).toList();

  final weekAttemptCount = thisWeekAttempts.length;
  final weekCorrectCount =
      thisWeekAttempts.where((row) => row.isCorrect).length;
  final weekAccuracy =
      weekAttemptCount == 0 ? 0.0 : weekCorrectCount / weekAttemptCount;
  final weeklyProgress =
      ((weekAttemptCount.clamp(0, 50) / 50 * 60) + (weekAccuracy * 40))
          .round()
          .clamp(0, 100);

  return DashboardSummary(
    xp: userStats.xp,
    level: userStats.level,
    wordsLearned: learnedCount,
    vocabularyMasteredCount: masteredCount,
    vocabularyDueCount: dueCount,
    vocabularyNewCount: newCount,
    vocabularyLearningCount: learningCount,
    exerciseAttemptCount: exerciseAttemptCount,
    exerciseCorrectCount: exerciseCorrectCount,
    exerciseIncorrectCount: exerciseIncorrectCount,
    grammarCompletedCount: grammarCompletedCount,
    achievementTotalCount: achievementTotalCount,
    achievementUnlockedCount: achievementUnlockedCount,
    weeklyProgress: weeklyProgress,
    weakAreas: weakAreas.take(3).toList(growable: false),
  );
}

/// Identifies the grammar topic identifier assigned to a specific exercise attempt.
///
/// Uses fuzzy string match logic to resolve different representations of topics.
String? _grammarTitleForAttempt({
  required ExerciseAttempt exerciseAttempt,
  required Map<String, Exercise> exerciseById,
  required List<GrammarTopic> grammarTopics,
}) {
  final topic = exerciseAttempt.topic;
  final eT = topic.toLowerCase();

  if (eT.isNotEmpty) {
    for (final g in grammarTopics) {
      final tT = g.title.toLowerCase();
      final tC = g.category.toLowerCase();
      if (tT == eT ||
          tT.contains(eT) ||
          eT.contains(tT) ||
          tC == eT ||
          tC.contains(eT) ||
          eT.contains(tC)) {
        return g.title;
      }
    }
  }

  final mappedExercise = exerciseById[exerciseAttempt.exerciseId];
  if (mappedExercise != null) {
    final mappedTopic = mappedExercise.topic.toLowerCase();
    if (mappedTopic.isNotEmpty && mappedTopic != eT) {
      for (final g in grammarTopics) {
        final tT = g.title.toLowerCase();
        final tC = g.category.toLowerCase();
        if (tT == mappedTopic ||
            tT.contains(mappedTopic) ||
            mappedTopic.contains(tT) ||
            tC == mappedTopic ||
            tC.contains(mappedTopic) ||
            mappedTopic.contains(tC)) {
          return g.title;
        }
      }
    }
  }
  return null;
}

/// Heuristic logic to pick the most urgent and relevant task for the user's dashboard.
///
/// Priority:
/// 1. Due vocabulary review (Urgent).
/// 2. Struggles in Weak Areas (Knowledge gap).
/// 3. Grammar topics if the user is a total beginner (Engagement).
/// 4. Vertigo session if they have no current struggles (Retention).
DashboardNextAction buildDashboardNextAction(DashboardSummary summary) {
  if (summary.vocabularyDueCount > 0) {
    return DashboardNextAction(
      title: 'Vokabeln wiederholen',
      subtitle: '${summary.vocabularyDueCount} Wörter sind fällig',
      ctaLabel: 'Review starten',
      route: '/vocabulary?tab=words',
      icon: '📚',
    );
  }

  if (summary.weakAreas.isNotEmpty) {
    final area = summary.weakAreas.first;
    return DashboardNextAction(
      title: 'Schwachstelle bearbeiten',
      subtitle: 'Übe als Nächstes: $area',
      ctaLabel: 'Jetzt üben',
      route: resolveWeakAreaRoute(area).route,
      icon: '⚠️',
    );
  }

  if (summary.grammarCompletedCount < 1) {
    return const DashboardNextAction(
      title: 'Grammatik fortsetzen',
      subtitle: 'Arbeite die offenen Grammatikthemen weiter durch',
      ctaLabel: 'Weiterlernen',
      route: '/grammar',
      icon: '📘',
    );
  }

  if (summary.exerciseAttemptCount > 0) {
    return const DashboardNextAction(
      title: 'Übungen vertiefen',
      subtitle: 'Sichere dein Wissen mit einer kurzen Übungsrunde',
      ctaLabel: 'Zu den Übungen',
      route: '/practice/exercises',
      icon: '✏️',
    );
  }

  return const DashboardNextAction(
    title: 'Mit Vokabeln starten',
    subtitle: 'Beginne mit den ersten Lernkarten und setze einen Rhythmus',
    ctaLabel: 'Vokabeln öffnen',
    route: '/vocabulary?tab=words',
    icon: '🚀',
  );
}

/// Provides a fallback route for "weak area" identifiers that might not clearly
/// indicate whether they are grammar lessons or standalone practice modules.
DashboardNextAction resolveWeakAreaRoute(String area) {
  final trimmed = area.trim();
  if (trimmed.isEmpty) {
    return const DashboardNextAction(
      title: 'Grammatik öffnen',
      subtitle: 'Wähle ein Thema zum Wiederholen',
      ctaLabel: 'Lernen',
      route: '/grammar',
      icon: '📘',
    );
  }

  if (area.contains('Exercise') || area.contains('Übung')) {
    final encoded = Uri.encodeComponent(trimmed);
    return DashboardNextAction(
      title: 'Schwache Übung',
      subtitle: trimmed,
      ctaLabel: 'Üben',
      route: '/practice/exercises?topic=$encoded',
      icon: '✏️',
    );
  }

  final encoded = Uri.encodeComponent(trimmed);
  return DashboardNextAction(
    title: 'Schwache Grammatik',
    subtitle: trimmed,
    ctaLabel: 'Lernen',
    route: '/grammar?category=$encoded&showFilters=1',
    icon: '📘',
  );
}



