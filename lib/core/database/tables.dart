import 'package:drift/drift.dart';

/// This table stores all the German words the user can learn.
/// It includes translations in English and Dari, categories, and examples.
class VocabularyWords extends Table {
  TextColumn get id => text()();
  TextColumn get german => text()();
  TextColumn get english => text()();
  TextColumn get dari => text()();
  TextColumn get category => text()();
  TextColumn get tag => text()();
  TextColumn get example => text()();
  TextColumn get context => text()();
  TextColumn get contextDari => text()();
  TextColumn get difficulty => text()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isDifficult => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// This table tracks the user's progress for each vocabulary word.
/// It uses the Leitner system to decide when a word should be reviewed next.
class VocabularyProgress extends Table {
  TextColumn get wordId => text()();
  IntColumn get leitnerBox => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('new'))();
  TextColumn get lastResult => text().nullable()();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
  IntColumn get lapseCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  DateTimeColumn get nextReviewAt => dateTime().nullable()();
  DateTimeColumn get masteredAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {wordId};
}

/// This table is for grammar lessons.
/// Each row represents a topic like "Präsens", "Artikel", or "Passiv".
class GrammarTopics extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get level => text()();
  TextColumn get category => text()();
  TextColumn get icon => text()();
  TextColumn get rule => text()();
  TextColumn get explanation => text()();
  TextColumn get examplesJson => text()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// This table stores all the practice questions (exercises).
/// Exercises are linked to specific grammar topics or vocabulary categories.
class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get question => text()();
  TextColumn get optionsJson => text()();
  IntColumn get correctAnswer => integer()();
  TextColumn get topic => text()();
  TextColumn get level => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// This table records every time a user answers an exercise question.
/// This data is used to calculate progress and find "weak areas".
class ExerciseAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exerciseId => text()();
  TextColumn get topic => text()();
  TextColumn get level => text()();
  BoolColumn get isCorrect => boolean()();
  DateTimeColumn get answeredAt => dateTime().withDefault(currentDateAndTime)();
}

/// This table is for user achievements (medals or badges).
/// It tracks which achievements the user has unlocked.
class Achievements extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get icon => text()();
  BoolColumn get unlocked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// This table is for general user statistics like total XP and daily streak.
/// This table usually has only one row for the current user.
class UserStats extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  IntColumn get wordsLearned => integer().withDefault(const Constant(0))();
  IntColumn get exercisesCompleted =>
      integer().withDefault(const Constant(0))();
  IntColumn get grammarTopicsCompleted =>
      integer().withDefault(const Constant(0))();
  IntColumn get weeklyProgress => integer().withDefault(const Constant(0))();
  TextColumn get level => text().withDefault(const Constant('A1'))();
  TextColumn get weakAreasJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// This table is for app settings and user preferences.
/// It stores things like dark mode, native language, and onboarding status.
class UserPreferences extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get darkMode => boolean().withDefault(const Constant(false))();
  TextColumn get nativeLanguage => text().withDefault(const Constant('en'))();
  TextColumn get displayLanguage => text().withDefault(const Constant('en'))();
  BoolColumn get hasSeenOnboarding =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
