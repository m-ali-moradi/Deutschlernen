import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import '../learning/continue_learning.dart';
import '../learning/dashboard_summary.dart';
import '../learning/review_logic.dart';
import '../learning/vocabulary_review.dart';

/// Provides the single database instance for the entire app.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.disposeDatabase);
  return db;
});

/// Streams the user's statistics (XP, level, streak) from the database.
final userStatsStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.userStats)..where((tbl) => tbl.id.equals(1)))
      .watchSingle();
});

/// Streams the user's app settings (dark mode, languages) from the database.
final userPreferencesStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.userPreferences)..where((tbl) => tbl.id.equals(1)))
      .watchSingle();
});

final displayLanguageProvider = Provider<String>((ref) {
  return ref.watch(userPreferencesStreamProvider).maybeWhen(
        data: (prefs) => prefs.displayLanguage,
        orElse: () => 'en',
      );
});

final achievementsStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.achievements).watch();
});

/// Provides a complete summary of the user's progress for the dashboard.
///
/// It watches all learning tables and updates the UI automatically.
final dashboardSummaryProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);

  List<Map<String, Object?>> vocabularyWords = const [];
  List<Map<String, Object?>> vocabularyProgress = const [];
  List<Map<String, Object?>> grammarTopics = const [];
  List<Map<String, Object?>> exercises = const [];
  List<Map<String, Object?>> exerciseAttempts = const [];
  List<Map<String, Object?>> achievements = const [];
  Map<String, Object?> userStats = const {};

  StreamSubscription<List<QueryRow>>? vocabularyWordsSub;
  StreamSubscription<List<QueryRow>>? vocabularyProgressSub;
  StreamSubscription<List<QueryRow>>? grammarTopicsSub;
  StreamSubscription<List<QueryRow>>? exercisesSub;
  StreamSubscription<List<QueryRow>>? exerciseAttemptsSub;
  StreamSubscription<List<QueryRow>>? achievementsSub;
  StreamSubscription<QueryRow>? userStatsSub;

  void emit(StreamController<DashboardSummary> controller) {
    if (!controller.isClosed) {
      controller.add(
        buildDashboardSummary(
          userStats: userStats,
          vocabularyWords: vocabularyWords,
          vocabularyProgress: vocabularyProgress,
          grammarTopics: grammarTopics,
          exercises: exercises,
          exerciseAttempts: exerciseAttempts,
          achievements: achievements,
          now: DateTime.now(),
        ),
      );
    }
  }

  final controller = StreamController<DashboardSummary>();

  controller.onListen = () async {
    try {
      vocabularyWords = (await db.customSelect('''
SELECT id, german, english, dari, category, tag, example, context, context_dari, difficulty, is_favorite, is_difficult, updated_at
FROM vocabulary_words
''').get()).map((row) => row.data).toList(growable: false);

      vocabularyProgress = (await db.customSelect('''
SELECT word_id, leitner_box, status, last_result, review_count, lapse_count, last_reviewed_at, next_review_at, mastered_at, updated_at
FROM vocabulary_progress
''').get()).map((row) => row.data).toList(growable: false);

      grammarTopics = (await db.customSelect('''
SELECT id, title, level, category, icon, rule, explanation, examples_json, progress, updated_at
FROM grammar_topics
''').get()).map((row) => row.data).toList(growable: false);

      exercises = (await db.customSelect('''
SELECT id, type, question, options_json, correct_answer, topic, level, updated_at
FROM exercises
''').get()).map((row) => row.data).toList(growable: false);

      exerciseAttempts = (await db.customSelect('''
SELECT id, exercise_id, topic, level, is_correct, answered_at
FROM exercise_attempts
''').get()).map((row) => row.data).toList(growable: false);

      achievements = (await db.customSelect('''
SELECT id, title, description, icon, unlocked, updated_at
FROM achievements
''').get()).map((row) => row.data).toList(growable: false);

      userStats = (await db.customSelect('''
SELECT xp, level, streak, words_learned, exercises_completed, grammar_topics_completed, weekly_progress, weak_areas_json
FROM user_stats
WHERE id = 1
''').getSingle()).data;

      emit(controller);

      vocabularyWordsSub = db.customSelect('''
SELECT id, german, english, dari, category, tag, example, context, context_dari, difficulty, is_favorite, is_difficult, updated_at
FROM vocabulary_words
''').watch().listen((rows) {
            vocabularyWords =
                rows.map((row) => row.data).toList(growable: false);
            emit(controller);
          }, onError: controller.addError);

      vocabularyProgressSub = db.customSelect('''
SELECT word_id, leitner_box, status, last_result, review_count, lapse_count, last_reviewed_at, next_review_at, mastered_at, updated_at
FROM vocabulary_progress
''').watch().listen((rows) {
            vocabularyProgress =
                rows.map((row) => row.data).toList(growable: false);
            emit(controller);
          }, onError: controller.addError);

      grammarTopicsSub = db.customSelect('''
SELECT id, title, level, category, icon, rule, explanation, examples_json, progress, updated_at
FROM grammar_topics
''').watch().listen((rows) {
            grammarTopics = rows.map((row) => row.data).toList(growable: false);
            emit(controller);
          }, onError: controller.addError);

      exercisesSub = db.customSelect('''
SELECT id, type, question, options_json, correct_answer, topic, level, updated_at
FROM exercises
''').watch().listen((rows) {
            exercises = rows.map((row) => row.data).toList(growable: false);
            emit(controller);
          }, onError: controller.addError);

      exerciseAttemptsSub = db.customSelect('''
SELECT id, exercise_id, topic, level, is_correct, answered_at
FROM exercise_attempts
''').watch().listen((rows) {
            exerciseAttempts =
                rows.map((row) => row.data).toList(growable: false);
            emit(controller);
          }, onError: controller.addError);

      achievementsSub = db.customSelect('''
SELECT id, title, description, icon, unlocked, updated_at
FROM achievements
''').watch().listen((rows) {
            achievements = rows.map((row) => row.data).toList(growable: false);
            emit(controller);
          }, onError: controller.addError);

      userStatsSub = db.customSelect('''
SELECT xp, level, streak, words_learned, exercises_completed, grammar_topics_completed, weekly_progress, weak_areas_json
FROM user_stats
WHERE id = 1
''').watchSingle().listen((row) {
            userStats = row.data;
            emit(controller);
          }, onError: controller.addError);
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
  };

  ref.onDispose(() {
    unawaited(vocabularyWordsSub?.cancel());
    unawaited(vocabularyProgressSub?.cancel());
    unawaited(grammarTopicsSub?.cancel());
    unawaited(exercisesSub?.cancel());
    unawaited(exerciseAttemptsSub?.cancel());
    unawaited(achievementsSub?.cancel());
    unawaited(userStatsSub?.cancel());
    unawaited(controller.close());
  });

  return controller.stream;
});

/// Lists the topics the user should practice more (where they made mistakes).
final exerciseWeakAreasProvider = Provider.autoDispose<List<String>>((ref) {
  final summary = ref.watch(dashboardSummaryProvider).valueOrNull;
  return summary?.weakAreas ?? const [];
});

/// Suggests the best "Next Action" for the user based on their progress.
final dashboardNextActionProvider = Provider.autoDispose<DashboardNextAction?>(
  (ref) {
    final summary = ref.watch(dashboardSummaryProvider).valueOrNull;
    if (summary == null) {
      return null;
    }
    return buildDashboardNextAction(summary);
  },
);

final continueLearningItemsProvider =
    Provider.autoDispose<List<ContinueLearningItem>>((ref) {
  final dashboardSummary = ref.watch(dashboardSummaryProvider).valueOrNull;
  final grammarTopics = ref.watch(grammarTopicsStreamProvider).valueOrNull;
  final vocabularyWords = ref.watch(vocabularyStreamProvider).valueOrNull;
  final vocabularyReviewState =
      ref.watch(vocabularyReviewStateProvider).valueOrNull;
  final exercises = ref.watch(exercisesStreamProvider).valueOrNull;

  return buildContinueLearningItems(
    grammarTopics: grammarTopics,
    vocabularyWords: vocabularyWords,
    vocabularyReviewState: vocabularyReviewState,
    exercises: exercises,
    dashboardSummary: dashboardSummary,
  );
});

final vocabularyReviewStateProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);

  List<Map<String, Object?>> vocabularyWords = const [];
  List<Map<String, Object?>> vocabularyProgress = const [];
  StreamSubscription<List<QueryRow>>? vocabularyWordsSub;
  StreamSubscription<List<QueryRow>>? vocabularyProgressSub;

  void emit(StreamController<VocabularyReviewState> controller) {
    if (!controller.isClosed) {
      controller.add(
        buildVocabularyReviewState(
          vocabularyWords: vocabularyWords,
          vocabularyProgress: vocabularyProgress,
          now: DateTime.now(),
        ),
      );
    }
  }

  final controller = StreamController<VocabularyReviewState>();

  controller.onListen = () async {
    try {
      vocabularyWords = (await db.customSelect('''
SELECT id, german, english, dari, category, tag, example, context, context_dari, difficulty, is_favorite, is_difficult, updated_at
FROM vocabulary_words
''').get()).map((row) => row.data).toList(growable: false);

      vocabularyProgress = (await db.customSelect('''
SELECT word_id, leitner_box, status, last_result, review_count, lapse_count, last_reviewed_at, next_review_at, mastered_at, updated_at
FROM vocabulary_progress
''').get()).map((row) => row.data).toList(growable: false);

      emit(controller);

      vocabularyWordsSub = db.customSelect('''
SELECT id, german, english, dari, category, tag, example, context, context_dari, difficulty, is_favorite, is_difficult, updated_at
FROM vocabulary_words
''').watch().listen((rows) {
            vocabularyWords =
                rows.map((row) => row.data).toList(growable: false);
            emit(controller);
          }, onError: controller.addError);

      vocabularyProgressSub = db.customSelect('''
SELECT word_id, leitner_box, status, last_result, review_count, lapse_count, last_reviewed_at, next_review_at, mastered_at, updated_at
FROM vocabulary_progress
''').watch().listen((rows) {
            vocabularyProgress =
                rows.map((row) => row.data).toList(growable: false);
            emit(controller);
          }, onError: controller.addError);
    } catch (error, stackTrace) {
      controller.addError(error, stackTrace);
    }
  };

  ref.onDispose(() {
    unawaited(vocabularyWordsSub?.cancel());
    unawaited(vocabularyProgressSub?.cancel());
    unawaited(controller.close());
  });

  return controller.stream;
});

final vocabularyReviewQueueProvider = Provider.family
    .autoDispose<List<String>, VocabularyReviewFilters>((ref, filters) {
  final reviewState = ref.watch(vocabularyReviewStateProvider).valueOrNull;
  if (reviewState == null) {
    return const [];
  }

  return buildVocabularyReviewQueue(
    vocabularyWords: reviewState.wordRows,
    reviewByWordId: reviewState.byWordId,
    now: DateTime.now(),
    search: filters.search,
    category: filters.category,
    favoritesOnly: filters.favoritesOnly,
  );
});

final vocabularyStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.vocabularyWords).watch();
});

final exercisesStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.exercises).watch();
});

final grammarTopicsStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.grammarTopics).watch();
});

/// Provides a set of actions to update app settings and learning progress.
final appSettingsActionsProvider = Provider<_AppSettingsActions>((ref) {
  return _AppSettingsActions(ref.watch(appDatabaseProvider));
});

class _AppSettingsActions {
  _AppSettingsActions(this._db);

  final AppDatabase _db;

  Future<void> setDarkMode(bool value) => _db.setDarkMode(value);

  Future<void> setNativeLanguage(String lang) {
    return (_db.update(_db.userPreferences)..where((tbl) => tbl.id.equals(1)))
        .write(UserPreferencesCompanion(nativeLanguage: Value(lang)));
  }

  Future<void> toggleFavorite(String wordId) => _db.toggleFavorite(wordId);

  Future<void> setWordDifficulty(String wordId, String difficulty) =>
      _db.setWordDifficulty(wordId, difficulty);

  Future<void> recordVocabularyReview({
    required String wordId,
    required ReviewResult result,
  }) =>
      _db.recordVocabularyReview(wordId: wordId, result: result);

  Future<void> setDisplayLanguage(String lang) {
    return (_db.update(_db.userPreferences)..where((tbl) => tbl.id.equals(1)))
        .write(UserPreferencesCompanion(displayLanguage: Value(lang)));
  }

  Future<void> updateGrammarProgress(String topicId, int progress) =>
      _db.updateGrammarProgress(topicId, progress);

  Future<void> resetGrammarTopicExercises(String topicTitle) =>
      _db.resetGrammarTopicExercises(topicTitle);

  Future<void> recordExerciseOutcome({
    required String exerciseId,
    required bool isCorrect,
    required int xpGained,
  }) =>
      _db.recordExerciseOutcome(
        exerciseId: exerciseId,
        isCorrect: isCorrect,
        xpGained: xpGained,
      );

  Future<void> reseedContent() => _db.reseedContent();

  Future<void> resetAllUserProgress() => _db.resetAllUserProgress();

  Future<void> markOnboardingAsSeen() => _db.markOnboardingAsSeen();
}
