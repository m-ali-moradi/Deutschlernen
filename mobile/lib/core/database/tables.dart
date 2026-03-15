import 'package:drift/drift.dart';

class VocabularyWords extends Table {
  TextColumn get id => text()();
  TextColumn get german => text()();
  TextColumn get phonetic => text()();
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

class UserPreferences extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get darkMode => boolean().withDefault(const Constant(false))();
  TextColumn get nativeLanguage => text().withDefault(const Constant('en'))();
  TextColumn get displayLanguage => text().withDefault(const Constant('en'))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ContentManifest extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get contentVersion => integer().withDefault(const Constant(1))();
  TextColumn get checksum => text().withDefault(const Constant(''))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class MutationQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operation => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get payloadJson => text()();
  TextColumn get idempotencyKey => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get syncedAt => dateTime().nullable()();
}
