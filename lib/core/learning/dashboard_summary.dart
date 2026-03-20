import '../learning/weak_area_routes.dart';

/// A summary of the user's learning progress.
///
/// This class holds all the numbers and data shown on the home and profile pages.
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

  final int xp;
  final String level;
  final int wordsLearned;
  final int vocabularyMasteredCount;
  final int vocabularyDueCount;
  final int vocabularyNewCount;
  final int vocabularyLearningCount;
  final int exerciseAttemptCount;
  final int exerciseCorrectCount;
  final int exerciseIncorrectCount;
  final int grammarCompletedCount;
  final int achievementTotalCount;
  final int achievementUnlockedCount;
  final int weeklyProgress;
  final List<String> weakAreas;
}

/// Information for the "Next Step" suggestion on the dashboard.
///
/// It tells the user which learning activity they should do right now.
class DashboardNextAction {
  const DashboardNextAction({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.route,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String ctaLabel;
  final String route;
  final String icon;
}

/// Calculates the [DashboardSummary] by looking at all user data.
///
/// It counts mastered words, correct exercises, and finds "weak areas" to improve.
DashboardSummary buildDashboardSummary({
  required Map<String, Object?> userStats,
  required List<Map<String, Object?>> vocabularyWords,
  required List<Map<String, Object?>> vocabularyProgress,
  required List<Map<String, Object?>> grammarTopics,
  required List<Map<String, Object?>> exercises,
  required List<Map<String, Object?>> exerciseAttempts,
  required List<Map<String, Object?>> achievements,
  required DateTime now,
}) {
  final progressByWordId = <String, Map<String, Object?>>{};
  for (final row in vocabularyProgress) {
    final wordId = _stringValue(row['word_id']);
    if (wordId.isNotEmpty) {
      progressByWordId[wordId] = row;
    }
  }

  final learnedCount = progressByWordId.values.where((row) {
    final status = _stringValue(row['status']);
    return status != 'new';
  }).length;

  final masteredCount = progressByWordId.values.where((row) {
    final status = _stringValue(row['status']);
    final masteredAt = _dateTimeValue(row['mastered_at']);
    return status == 'mastered' || masteredAt != null;
  }).length;

  final dueCount = progressByWordId.values.where((row) {
    final status = _stringValue(row['status']);
    final masteredAt = _dateTimeValue(row['mastered_at']);
    if (status == 'mastered' || masteredAt != null) {
      return false;
    }
    final nextReviewAt = _dateTimeValue(row['next_review_at']);
    return nextReviewAt != null && !nextReviewAt.isAfter(now);
  }).length;

  final learningCount = progressByWordId.values.where((row) {
    final status = _stringValue(row['status']);
    final masteredAt = _dateTimeValue(row['mastered_at']);
    if (status == 'mastered' || masteredAt != null) {
      return false;
    }
    final nextReviewAt = _dateTimeValue(row['next_review_at']);
    final reviewCount = _intValue(row['review_count']);
    return status == 'learning' ||
        (reviewCount > 0 &&
            (nextReviewAt == null || nextReviewAt.isAfter(now)));
  }).length;

  final newCount = (vocabularyWords.length - progressByWordId.length)
      .clamp(0, vocabularyWords.length)
      .toInt();
  final grammarCompletedCount =
      grammarTopics.where((row) => _intValue(row['progress']) >= 100).length;
  final exerciseAttemptCount = exerciseAttempts.length;
  final exerciseCorrectCount =
      exerciseAttempts.where((row) => _boolValue(row['is_correct'])).length;
  final exerciseIncorrectCount = exerciseAttemptCount - exerciseCorrectCount;
  final achievementUnlockedCount =
      achievements.where((row) => _boolValue(row['unlocked'])).length;
  final achievementTotalCount = achievements.length;

  final recentWindow = now.subtract(const Duration(days: 14));
  final recentIncorrectAttempts = exerciseAttempts.where((row) {
    final isCorrect = _boolValue(row['is_correct']);
    final answeredAt = _dateTimeValue(row['answered_at']);
    return !isCorrect &&
        answeredAt != null &&
        !answeredAt.isBefore(recentWindow);
  }).toList();
  final weakSource = recentIncorrectAttempts.isNotEmpty
      ? recentIncorrectAttempts
      : exerciseAttempts
          .where((row) => !_boolValue(row['is_correct']))
          .toList();

  final exerciseById = <String, Map<String, Object?>>{};
  for (final row in exercises) {
    final exerciseId = _stringValue(row['id']);
    if (exerciseId.isNotEmpty) {
      exerciseById[exerciseId] = row;
    }
  }

  final validGrammarTitles =
      grammarTopics.map((row) => _stringValue(row['title'])).toSet();

  final weakGrammarAreaCounts = <String, int>{};
  for (final row in weakSource) {
    final exerciseId = _stringValue(row['exercise_id']);
    final topic = _stringValue(row['topic']);
    final grammarTitle = _grammarTitleForAttempt(
      exerciseId: exerciseId,
      topic: topic,
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
      if (byCount != 0) {
        return byCount;
      }
      return left.key.compareTo(right.key);
    });

  final weakAreas = weakGrammarAreas.map((entry) => entry.key).toList();

  // Filter attempts to current week for metrics

  // Filter attempts to current week for metrics
  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  final weekStartTime = DateTime(weekStart.year, weekStart.month, weekStart.day);
  
  final thisWeekAttempts = exerciseAttempts.where((row) {
    final answeredAt = _dateTimeValue(row['answered_at']);
    return answeredAt != null && !answeredAt.isBefore(weekStartTime);
  }).toList();

  final weekAttemptCount = thisWeekAttempts.length;
  final weekCorrectCount = thisWeekAttempts.where((row) => _boolValue(row['is_correct'])).length;
  final weekAccuracy = weekAttemptCount == 0 ? 0.0 : weekCorrectCount / weekAttemptCount;
  
  // Weekly progress is a blend of participation and accuracy this week
  final weeklyProgress = ((weekAttemptCount.clamp(0, 50) / 50 * 60) + (weekAccuracy * 40)).round().clamp(0, 100);

  return DashboardSummary(
    xp: _intValue(userStats['xp']),
    level: _stringValue(userStats['level']),
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

String? _grammarTitleForAttempt({
  required String exerciseId,
  required String topic,
  required Map<String, Map<String, Object?>> exerciseById,
  required List<Map<String, Object?>> grammarTopics,
}) {
  final eT = topic.toLowerCase();
  if (eT.isEmpty) return null;

  for (final g in grammarTopics) {
    final tT = _stringValue(g['title']).toLowerCase();
    final tC = _stringValue(g['category']).toLowerCase();
    
    if (tT == eT || tT.contains(eT) || eT.contains(tT) ||
        tC == eT || tC.contains(eT) || eT.contains(tC)) {
      return _stringValue(g['title']);
    }
  }

  // Fallback to searching the exercise by ID if topic is generic
  final mappedExercise = exerciseById[exerciseId];
  if (mappedExercise != null) {
    final mappedTopic = _stringValue(mappedExercise['topic']).toLowerCase();
    if (mappedTopic.isNotEmpty && mappedTopic != eT) {
      for (final g in grammarTopics) {
        final tT = _stringValue(g['title']).toLowerCase();
        final tC = _stringValue(g['category']).toLowerCase();
        if (tT == mappedTopic || tT.contains(mappedTopic) || mappedTopic.contains(tT) ||
            tC == mappedTopic || tC.contains(mappedTopic) || mappedTopic.contains(tC)) {
          return _stringValue(g['title']);
        }
      }
    }
  }

  return null;
}

/// Decides what the user should do next based on their current progress.
///
/// For example, if words are due for review, it suggests a vocabulary session.
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
      route: '/exercises',
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

int _intValue(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _boolValue(Object? value) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  final normalized = value?.toString().toLowerCase();
  return normalized == 'true' || normalized == '1';
}

String _stringValue(Object? value) => value?.toString() ?? '';

DateTime? _dateTimeValue(Object? value) {
  if (value is DateTime) {
    return value;
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  if (value is num) {
    return DateTime.fromMillisecondsSinceEpoch(value.toInt());
  }
  final text = value?.toString();
  if (text == null || text.isEmpty) {
    return null;
  }
  return DateTime.tryParse(text);
}
