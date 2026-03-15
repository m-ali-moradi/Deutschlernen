import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.disposeDatabase);
  return db;
});

final userStatsStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.userStats)..where((tbl) => tbl.id.equals(1)))
      .watchSingle();
});

final userPreferencesStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.userPreferences)..where((tbl) => tbl.id.equals(1)))
      .watchSingle();
});

final achievementsStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.achievements).watch();
});

final vocabularyStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.vocabularyWords).watch();
});

final exercisesStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.exercises).watch();
});

final appSettingsActionsProvider = Provider<_AppSettingsActions>((ref) {
  return _AppSettingsActions(ref.watch(appDatabaseProvider));
});

class _AppSettingsActions {
  _AppSettingsActions(this._db);

  final AppDatabase _db;

  Future<void> setDarkMode(bool value) {
    return (_db.update(_db.userPreferences)..where((tbl) => tbl.id.equals(1)))
        .write(UserPreferencesCompanion(darkMode: Value(value)));
  }

  Future<void> setNativeLanguage(String lang) {
    return (_db.update(_db.userPreferences)..where((tbl) => tbl.id.equals(1)))
        .write(UserPreferencesCompanion(nativeLanguage: Value(lang)));
  }

  Future<void> toggleFavorite(String wordId) async {
    final word = await (_db.select(_db.vocabularyWords)
          ..where((tbl) => tbl.id.equals(wordId)))
        .getSingleOrNull();
    if (word == null) return;

    await (_db.update(_db.vocabularyWords)
          ..where((tbl) => tbl.id.equals(wordId)))
        .write(
      VocabularyWordsCompanion(
        isFavorite: Value(!word.isFavorite),
      ),
    );
  }

  Future<void> setWordDifficulty(String wordId, String difficulty) {
    return (_db.update(_db.vocabularyWords)
          ..where((tbl) => tbl.id.equals(wordId)))
        .write(
      VocabularyWordsCompanion(
        difficulty: Value(difficulty),
        isDifficult: Value(difficulty == 'hard'),
      ),
    );
  }

  Future<void> recordExerciseOutcome({
    required int correctAnswers,
    required int total,
  }) async {
    final stats = await (_db.select(_db.userStats)
          ..where((tbl) => tbl.id.equals(1)))
        .getSingleOrNull();

    if (stats == null) return;

    final gainedXp = correctAnswers * 10;
    final nextExercisesCompleted = stats.exercisesCompleted + 1;
    final ratio = total == 0 ? 0 : (correctAnswers / total);
    final nextWeekly =
        ((stats.weeklyProgress + (ratio * 12)).round()).clamp(0, 100);

    await (_db.update(_db.userStats)..where((tbl) => tbl.id.equals(1))).write(
      UserStatsCompanion(
        xp: Value(stats.xp + gainedXp),
        exercisesCompleted: Value(nextExercisesCompleted),
        weeklyProgress: Value(nextWeekly),
      ),
    );
  }

  Future<void> reseedContent() {
    return _db.reseedContent();
  }
}
