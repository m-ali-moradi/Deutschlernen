import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/learning/learning_progress_service.dart';
import 'package:deutschmate_mobile/features/learning_path/domain/dashboard_logic.dart';
import 'package:deutschmate_mobile/features/learning_path/domain/continue_learning_logic.dart';
import 'package:deutschmate_mobile/core/content/sync/grammar_localization_repository.dart';
import 'package:deutschmate_mobile/features/grammar/data/models/grammar_detail_models.dart';
import 'package:deutschmate_mobile/core/learning/review_logic.dart';
import 'package:deutschmate_mobile/core/learning/vocabulary_review.dart';

/// Provides the single database instance for the entire app.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.disposeDatabase);
  return db;
});

/// Streams the user's statistics (XP, level, streak) from the database.
final userStatsStreamProvider = StreamProvider.autoDispose<UserStat>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.userStats)..where((tbl) => tbl.id.equals(1)))
      .watchSingle();
});

/// Streams the user's app settings (dark mode, languages) from the database.
final userPreferencesStreamProvider =
    StreamProvider.autoDispose<UserPreference>((ref) {
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

final nativeLanguageProvider = Provider<String>((ref) {
  return ref.watch(userPreferencesStreamProvider).maybeWhen(
        data: (prefs) => prefs.nativeLanguage,
        orElse: () => 'en',
      );
});

final achievementsStreamProvider =
    StreamProvider.autoDispose<List<Achievement>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.achievements).watch();
});

final vocabularyWordsStreamProvider =
    StreamProvider.autoDispose<List<VocabularyWord>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.vocabularyWords).watch();
});

final vocabularyProgressStreamProvider =
    StreamProvider.autoDispose<List<VocabularyProgressData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.vocabularyProgress).watch();
});

final grammarTopicsStreamProvider =
    StreamProvider.autoDispose<List<GrammarTopic>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.grammarTopics).watch();
});

final exercisesStreamProvider =
    StreamProvider.autoDispose<List<Exercise>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.exercises).watch();
});

final exerciseAttemptsStreamProvider =
    StreamProvider.autoDispose<List<ExerciseAttempt>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.exerciseAttempts).watch();
});

/// Provides a computed stream of the user's current XP.
final userXpProvider = Provider.autoDispose<AsyncValue<int>>((ref) {
  return ref.watch(userStatsStreamProvider.select(
    (s) => s.whenData((stats) => stats.xp),
  ));
});

/// Provides a computed stream of the user's current level.
final userLevelProvider = Provider.autoDispose<AsyncValue<String>>((ref) {
  return ref.watch(userStatsStreamProvider.select(
    (s) => s.whenData((stats) => stats.level),
  ));
});

/// Provides only the weekly progress percentage.
final weeklyProgressProvider = Provider.autoDispose<AsyncValue<int>>((ref) {
  return ref.watch(dashboardSummaryProvider.select(
    (s) => s.whenData((summary) => summary.weeklyProgress),
  ));
});

/// Provides the count of words learned.
final wordsLearnedCountProvider = Provider.autoDispose<AsyncValue<int>>((ref) {
  return ref.watch(dashboardSummaryProvider.select(
    (s) => s.whenData((summary) => summary.wordsLearned),
  ));
});

/// Provides the count of exercise attempts.
final exerciseAttemptCountProvider =
    Provider.autoDispose<AsyncValue<int>>((ref) {
  return ref.watch(dashboardSummaryProvider.select(
    (s) => s.whenData((summary) => summary.exerciseAttemptCount),
  ));
});

/// Provides a complete summary of the user's progress for the dashboard.
///
/// It composes smaller stream providers instead of owning manual subscriptions.
final dashboardSummaryProvider =
    Provider.autoDispose<AsyncValue<DashboardSummary>>((ref) {
  // We keep this for backward compatibility, but UI should prefer granular providers.
  final vocabularyWords = ref.watch(vocabularyWordsStreamProvider);
  final vocabularyProgress = ref.watch(vocabularyProgressStreamProvider);
  final grammarTopics = ref.watch(grammarTopicsStreamProvider);
  final exercises = ref.watch(exercisesStreamProvider);
  final exerciseAttempts = ref.watch(exerciseAttemptsStreamProvider);
  final achievements = ref.watch(achievementsStreamProvider);
  final userStats = ref.watch(userStatsStreamProvider);

  final asyncValues = [
    vocabularyWords,
    vocabularyProgress,
    grammarTopics,
    exercises,
    exerciseAttempts,
    achievements,
    userStats,
  ];

  for (final asyncValue in asyncValues) {
    if (asyncValue.hasError) {
      return AsyncValue.error(
        asyncValue.error!,
        asyncValue.stackTrace ?? StackTrace.current,
      );
    }
  }

  if (asyncValues.any((v) => v.isLoading)) {
    return const AsyncValue.loading();
  }

  final stats = userStats.value;
  final words = vocabularyWords.value;
  final progress = vocabularyProgress.value;
  final topics = grammarTopics.value;
  final ex = exercises.value;
  final attempts = exerciseAttempts.value;
  final ach = achievements.value;

  if (stats == null ||
      words == null ||
      progress == null ||
      topics == null ||
      ex == null ||
      attempts == null ||
      ach == null) {
    return const AsyncValue.loading();
  }

  return AsyncValue.data(
    buildDashboardSummary(
      userStats: stats,
      vocabularyWords: words,
      vocabularyProgress: progress,
      grammarTopics: topics,
      exercises: ex,
      exerciseAttempts: attempts,
      achievements: ach,
      now: DateTime.now(),
    ),
  );
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
  final vocabularyWords = ref.watch(vocabularyWordsStreamProvider).valueOrNull;
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

final vocabularyReviewStateProvider =
    Provider.autoDispose<AsyncValue<VocabularyReviewState>>((ref) {
  final words = ref.watch(vocabularyWordsStreamProvider);
  final progress = ref.watch(vocabularyProgressStreamProvider);

  if (words.hasError) return AsyncValue.error(words.error!, words.stackTrace!);
  if (progress.hasError) {
    return AsyncValue.error(progress.error!, progress.stackTrace!);
  }

  if (words.isLoading || progress.isLoading) {
    return const AsyncValue.loading();
  }

  final wordsVal = words.value;
  final progressVal = progress.value;

  if (wordsVal == null || progressVal == null) {
    return const AsyncValue.loading();
  }

  return AsyncValue.data(
    buildVocabularyReviewState(
      vocabularyWords: wordsVal,
      vocabularyProgress: progressVal,
      now: DateTime.now(),
    ),
  );
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

final vocabularyGroupsStreamProvider =
    StreamProvider.autoDispose<List<VocabularyGroupEntity>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.vocabularyGroups)
        ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
      .watch();
});

final vocabularyCategoriesStreamProvider =
    StreamProvider.autoDispose<List<VocabularyCategoryEntity>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.vocabularyCategories)
        ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
      .watch();
});

final vocabularyPendingCategoriesStreamProvider =
    StreamProvider.autoDispose<List<VocabularyPendingCategoryEntity>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.vocabularyPendingCategories)
        ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
      .watch();
});

/// Provides a set of actions to update app settings and learning progress.
final appSettingsActionsProvider = Provider<_AppSettingsActions>((ref) {
  return _AppSettingsActions(
    ref.watch(appDatabaseProvider),
    ref.watch(learningProgressServiceProvider),
  );
});

final learningProgressServiceProvider =
    Provider<LearningProgressService>((ref) {
  return LearningProgressService(ref.watch(appDatabaseProvider));
});

class _AppSettingsActions {
  _AppSettingsActions(this._db, this._learningProgressService);

  final AppDatabase _db;
  final LearningProgressService _learningProgressService;

  Future<void> setDarkMode(bool value) => _db.userDao.setDarkMode(value);

  Future<void> setNativeLanguage(String lang) {
    return (_db.update(_db.userPreferences)..where((tbl) => tbl.id.equals(1)))
        .write(UserPreferencesCompanion(nativeLanguage: Value(lang)));
  }

  Future<void> toggleFavorite(String wordId) =>
      _db.vocabularyDao.toggleFavorite(wordId);

  Future<void> setWordDifficulty(String wordId, String difficulty) =>
      _db.vocabularyDao.setWordDifficulty(wordId, difficulty);

  Future<void> recordVocabularyReview({
    required String wordId,
    required ReviewResult result,
  }) =>
      _db.vocabularyDao.recordVocabularyReview(wordId: wordId, result: result);

  Future<void> setDisplayLanguage(String lang) {
    return (_db.update(_db.userPreferences)..where((tbl) => tbl.id.equals(1)))
        .write(UserPreferencesCompanion(displayLanguage: Value(lang)));
  }

  Future<void> updateGrammarProgress(String topicId, int progress) =>
      _learningProgressService.updateGrammarProgress(topicId, progress);

  Future<void> resetGrammarTopicExercises(String topicTitle) =>
      _learningProgressService.resetGrammarTopicExercises(topicTitle);

  Future<void> recordExerciseOutcome({
    required String exerciseId,
    required bool isCorrect,
    required int xpGained,
    required String scope,
    bool syncGrammarFromAttempt = true,
  }) =>
      _learningProgressService.recordExerciseOutcome(
        exerciseId: exerciseId,
        isCorrect: isCorrect,
        xpGained: xpGained,
        scope: scope,
        syncGrammarFromAttempt: syncGrammarFromAttempt,
      );

  Future<void> reseedContent() => _db.reseedContent();

  Future<void> resetAllUserProgress() => _db.resetAllUserProgress();

  Future<void> markOnboardingAsSeen() => _db.userDao.markOnboardingAsSeen();

  Future<void> setAutoSync(bool value) => _db.userDao.setAutoSync(value);
}

final localizedGrammarTopicsProvider =
    FutureProvider.autoDispose<List<GrammarTopic>>((ref) async {
  final baseTopics = await ref.watch(grammarTopicsStreamProvider.future);
  final langCode = ref.watch(displayLanguageProvider);
  final repo = ref.watch(grammarLocalizationRepositoryProvider);

  return repo.getLocalizedTopics(baseTopics, langCode);
});

final grammarDetailProvider = FutureProvider.family
    .autoDispose<GrammarDetailData?, String>((ref, topicId) async {
  final baseTopics = await ref.watch(grammarTopicsStreamProvider.future);
  final baseTopic = baseTopics.where((t) => t.id == topicId).firstOrNull;
  final level = baseTopic?.level ?? 'A1';

  final repo = ref.watch(grammarLocalizationRepositoryProvider);
  final langCode = ref.watch(displayLanguageProvider);

  return repo.getDetailTopic(topicId, level, langCode);
});
