import 'package:drift/drift.dart';

/// Internal metadata for the user's statistics and current level.
///
/// This table stores a single row (id=1) representing the local user's profile state.
class UserStats extends Table {
  /// Unique identifier for the user stats record. Typically 1.
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// Total experience points accumulated by the user.
  IntColumn get xp => integer().withDefault(const Constant(0))();

  /// Current daily streak of using the app.
  IntColumn get streak => integer().withDefault(const Constant(0))();

  /// Total number of vocabulary words learned.
  IntColumn get wordsLearned => integer().withDefault(const Constant(0))();

  /// Total number of exercises completed.
  IntColumn get exercisesCompleted =>
      integer().withDefault(const Constant(0))();

  /// Total number of grammar topics completed.
  IntColumn get grammarTopicsCompleted =>
      integer().withDefault(const Constant(0))();

  /// User's progress within the current week.
  IntColumn get weeklyProgress => integer().withDefault(const Constant(0))();

  /// Current proficiency level of the user (e.g., 'A1', 'B2').
  TextColumn get level => text().withDefault(const Constant('A1'))();

  /// JSON string representing areas where the user struggles.
  TextColumn get weakAreasJson => text().withDefault(const Constant('[]'))();

  /// Timestamp of the last update to user statistics.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Global application settings and flags.
///
/// This table stores app settings like dark mode, native language, and onboarding status.
class UserPreferences extends Table {
  /// Unique identifier for the user preferences record. Typically 1.
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// Flag indicating if dark mode is enabled.
  BoolColumn get darkMode => boolean().withDefault(const Constant(false))();

  /// The user's native (source) language code (e.g., 'en', 'fa').
  TextColumn get nativeLanguage => text().withDefault(const Constant('en'))();

  /// The language code for the app's interface (e.g., 'en', 'de').
  TextColumn get displayLanguage => text().withDefault(const Constant('en'))();

  /// Flag indicating if the user has completed the onboarding process.
  BoolColumn get hasSeenOnboarding =>
      boolean().withDefault(const Constant(false))();

  /// Flag indicating if automatic data synchronization is enabled.
  BoolColumn get autoSync => boolean().withDefault(const Constant(false))();

  /// Timestamp of the last update to user preferences.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Top-level buckets for vocabulary (e.g., "Daily Life", "Work").
@DataClassName('VocabularyGroupEntity')
class VocabularyGroups extends Table {
  /// Unique identifier for the vocabulary group.
  TextColumn get id => text()();

  /// Display name of the group.
  TextColumn get name => text()();

  /// CEFR level range covered by this group.
  TextColumn get levelRange => text()();

  /// Order in which the group appears in lists.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Last update timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Logical categories within a group (e.g., "Greetings", "Meetings").
@DataClassName('VocabularyCategoryEntity')
class VocabularyCategories extends Table {
  /// Unique identifier for the category.
  TextColumn get id => text()();

  /// ID of the group this category belongs to.
  TextColumn get groupId => text().references(VocabularyGroups, #id)();

  /// Display name of the category.
  TextColumn get name => text()();

  /// Icon or emoji used for visual identification.
  TextColumn get icon => text()();

  /// JSON-encoded list of hex colors for UI gradients.
  TextColumn get gradientColorsJson => text()();

  /// Order in which the category appears in lists.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Number of words contained in this category (cached).
  IntColumn get wordCount => integer().withDefault(const Constant(0))();

  /// Flag indicating if this category's content is available offline.
  BoolColumn get isCached => boolean().withDefault(const Constant(true))();

  /// Last update timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Placeholder for categories that exist in the cloud but aren't downloaded yet.
@DataClassName('VocabularyPendingCategoryEntity')
class VocabularyPendingCategories extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get gradientColorsJson => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Core dictionary entries. Stores German words and their multi-lingual translations.
class VocabularyWords extends Table {
  /// Unique identifier for the word.
  TextColumn get id => text()();

  /// The word or phrase in German.
  TextColumn get german => text()();

  /// English translation.
  TextColumn get english => text()();

  /// Dari (Farsi) translation.
  TextColumn get dari => text()();

  /// Category name this word belongs to (denormalized for quick filtering).
  TextColumn get category => text()();

  /// Optional specific tag for sub-categorization.
  TextColumn get tag => text()();

  /// Example sentence in German using the word.
  TextColumn get example => text()();

  /// Descriptive context explaining usage.
  TextColumn get context => text()();

  /// Translation of the context explanation into Dari.
  TextColumn get contextDari => text()();

  /// CEFR level (A1-C2).
  TextColumn get level => text().withDefault(const Constant('A1'))();

  /// User-defined or content-suggested difficulty level.
  TextColumn get difficulty => text()();

  /// Flag for words marked as favorites by the user.
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  /// Flag for words marked as difficult during practice.
  BoolColumn get isDifficult => boolean().withDefault(const Constant(false))();

  /// Last time this record was updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Per-word Spaced Repetition System (SRS) state.
///
/// Records how well the user knows a specific word and when to show it again.
class VocabularyProgress extends Table {
  /// Foreign key to the [VocabularyWords] table.
  TextColumn get wordId => text()();

  /// current box in the Leitner system (1 to 5).
  IntColumn get leitnerBox => integer().withDefault(const Constant(0))();

  /// SRS status (e.g., 'new', 'learning', 'reviewing', 'mastered').
  TextColumn get status => text().withDefault(const Constant('new'))();

  /// Result of the most recent review session.
  TextColumn get lastResult => text().nullable()();

  /// Total number of times this word has been reviewed.
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();

  /// Total number of times the user forgot this word.
  IntColumn get lapseCount => integer().withDefault(const Constant(0))();

  /// Timestamp of the last review.
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();

  /// Timestamp for the next scheduled review.
  DateTimeColumn get nextReviewAt => dateTime().nullable()();

  /// Timestamp when the word reached the 'mastered' state.
  DateTimeColumn get masteredAt => dateTime().nullable()();

  /// Last modification timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {wordId};
}

/// High-level curriculum topics for grammar lessons.
class GrammarTopics extends Table {
  /// Unique identifier for the grammar topic.
  TextColumn get id => text()();

  /// Display title of the topic.
  TextColumn get title => text()();

  /// CEFR proficiency level (e.g., 'A1').
  TextColumn get level => text()();

  /// Pedagogical category (e.g., 'Verbs', 'Pronouns').
  TextColumn get category => text()();

  /// Icon identifier for UI display.
  TextColumn get icon => text()();

  /// Brief statement of the grammar rule.
  TextColumn get rule => text()();

  /// Detailed pedagogical explanation.
  TextColumn get explanation => text()();

  /// JSON-encoded list of usage examples.
  TextColumn get examplesJson => text()();

  /// User progress through the topic (0 to 100 percentage).
  IntColumn get progress => integer().withDefault(const Constant(0))();

  /// Last update timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Rich content cache for grammar topics, potentially multi-lingual.
class GrammarDetails extends Table {
  /// Foreign key to [GrammarTopics].
  TextColumn get topicId => text()();

  /// ISO language code for the detailed content.
  TextColumn get languageCode => text()();

  /// Override title for this language.
  TextColumn get title => text().nullable()();

  /// Override category for this language.
  TextColumn get category => text().nullable()();

  /// Rule stated in the target language.
  TextColumn get rule => text().nullable()();

  /// Explanation translated to the target language.
  TextColumn get explanation => text().nullable()();

  /// Translated examples in JSON format.
  TextColumn get examplesJson => text().nullable()();

  /// Deep rich-text or HTML content payload.
  TextColumn get detailJson => text().nullable()();

  /// Cache maintenance timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {topicId, languageCode};
}

/// Collection of practice questions (exercises).
class Exercises extends Table {
  /// Unique identifier for the exercise.
  TextColumn get id => text()();

  /// Question type (e.g., 'multiple_choice', 'fill_blanks').
  TextColumn get type => text()();

  /// The question text.
  TextColumn get question => text()();

  /// JSON-encoded list of available answers.
  TextColumn get optionsJson => text()();

  /// Zero-based index of the correct option.
  IntColumn get correctAnswer => integer()();

  /// Associated grammar topic or theme.
  TextColumn get topic => text()();

  /// Recommended proficiency level.
  TextColumn get level => text()();

  /// Last definition update.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Historical log of exercise sessions for analytics and SRS.
class ExerciseAttempts extends Table {
  /// Incrementing ID for the log entry.
  IntColumn get id => integer().autoIncrement()();

  /// ID of the exercise performed.
  TextColumn get exerciseId => text().references(Exercises, #id)();

  /// Context in which the exercise was taken ('exercises' or 'lesson').
  TextColumn get scope => text().withDefault(const Constant('exercises'))();

  /// Subject tag of the attempt.
  TextColumn get topic => text()();

  /// Proficiency level at the time of the attempt.
  TextColumn get level => text()();

  /// binary result: true if correct, false otherwise.
  BoolColumn get isCorrect => boolean()();

  /// Timestamp of the interaction.
  DateTimeColumn get answeredAt => dateTime().withDefault(currentDateAndTime)();
}

/// Achievements and badges for user gamification.
class Achievements extends Table {
  /// Unique milestone ID.
  TextColumn get id => text()();

  /// Display name of the achievement.
  TextColumn get title => text()();

  /// Criteria to unlock.
  TextColumn get description => text()();

  /// Identifier for the badge graphic.
  TextColumn get icon => text()();

  /// State flag: true if the user met the criteria.
  BoolColumn get unlocked => boolean().withDefault(const Constant(false))();

  /// Timestamp when the achievement was first unlocked.
  DateTimeColumn get unlockedAt => dateTime().nullable()();

  /// Last updated timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tracking table for cloud synchronization state per collection.
class SyncMetadata extends Table {
  /// The collection path or entity identifier (e.g., 'grammar_topics').
  TextColumn get id => text()();

  /// The timestamp of the last successful synchronization.
  DateTimeColumn get lastSyncAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Interactive dialogue scenarios for conversational practice.
class Dialogues extends Table {
  /// Unique identifier for the dialogue scenario.
  TextColumn get id => text()();

  /// Primary display title in German.
  TextColumn get title => text()();

  /// Secondary display title in English.
  TextColumn get englishTitle => text().withDefault(const Constant(''))();

  /// Brief scenario description.
  TextColumn get description => text().withDefault(const Constant(''))();

  /// CEFR proficiency level.
  TextColumn get level => text()();

  /// Category for group filtering.
  TextColumn get category => text()();

  /// Icon identifier for the UI.
  TextColumn get icon => text().withDefault(const Constant(''))();

  /// JSON-encoded list of [DialogueEntry] objects.
  TextColumn get entriesJson => text()();

  /// Last update timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
