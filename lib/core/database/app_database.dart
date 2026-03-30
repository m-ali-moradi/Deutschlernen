import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:deutschmate_mobile/core/content/content_assets.dart';
import 'package:deutschmate_mobile/core/content/content_loader.dart';
import 'package:deutschmate_mobile/core/database/tables.dart';

import 'package:deutschmate_mobile/core/database/daos/vocabulary_dao.dart';
import 'package:deutschmate_mobile/core/database/daos/grammar_dao.dart';
import 'package:deutschmate_mobile/core/database/daos/user_dao.dart';
import 'package:deutschmate_mobile/core/database/daos/exercise_dao.dart';

part 'app_database.g.dart';

/// The main database class for the application, built on top of the Drift persistence library.
///
/// This class centralizes all SQLite interactions, managing tables, data migrations,
/// and the initial seeding of content from localized JSON assets.
@DriftDatabase(
  tables: [
    VocabularyWords,
    VocabularyProgress,
    GrammarTopics,
    Exercises,
    ExerciseAttempts,
    Achievements,
    UserStats,
    UserPreferences,
    VocabularyGroups,
    VocabularyCategories,
    VocabularyPendingCategories,
    GrammarDetails,
    SyncMetadata,
    Dialogues,
  ],
  daos: [
    VocabularyDao,
    GrammarDao,
    UserDao,
    ExerciseDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  static const String _vocabularySyncMetadataId = 'local_vocabulary_assets';
  static const List<String> _dialogueIds = [
    'city_registration_appointment',
    'wohnungsbesichtigung',
    'doctor_appointment',
    'bank_account',
    'supermarket',
    'workplace_first_day',
    'job_interview',
    'emergency_call',
    'restaurant_cafe',
    'public_transport_ticket',
    'asking_directions',
    'hotel_check_in',
    'phone_appointment',
    'post_office',
    'pharmacy',
    'meeting_neighbors',
    'school_teacher_conversation',
    'landlord_repair',
  ];

  /// Internal constructor for creating a database with a specific executor.
  AppDatabase._(super.executor, {required bool seedContent})
      : _seedContent = seedContent;

  /// Default constructor that initializes the database File on the local filesystem.
  ///
  /// By default, it uses 'deutschmate.sqlite' in the application documents directory.
  AppDatabase()
      : _seedContent = true,
        super(
          driftDatabase(
            name: 'deutschmate.sqlite',
            native: DriftNativeOptions(
              databaseDirectory: getApplicationDocumentsDirectory,
              setup: (db) {
                db.execute('PRAGMA journal_mode = WAL;');
                db.execute('PRAGMA busy_timeout = 5000;');
              },
            ),
          ),
        );

  /// Helper constructor for unit tests, allowing a memory-based executor.
  AppDatabase.forTesting(QueryExecutor executor, {bool seedContent = false})
      : this._(executor, seedContent: seedContent);

  /// Flag indicating whether the database should attempt to seed content from assets.
  final bool _seedContent;

  /// The current schema version. Incremented whenever tables or column definitions change.
  @override
  int get schemaVersion => 14;

  /// Defines the logic for creating and upgrading the database schema.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await createManualIndexes();
          if (_seedContent) {
            await _seedInitialData();
          }
        },
        onUpgrade: (m, from, to) async {
          // Version 2: Added progress tracking for exercises and vocabulary.
          if (from < 2) {
            await m.createTable(vocabularyProgress);
            await m.createTable(exerciseAttempts);
          }
          // Version 3: Cleaned up vocabulary structure (removed phonetics).
          if (from < 3) {
            await m.deleteTable(vocabularyWords.actualTableName);
            await m.createTable(vocabularyWords);
          }
          // Version 4: Added onboarding tracking.
          if (from < 4) {
            try {
              await m.addColumn(
                  userPreferences, userPreferences.hasSeenOnboarding);
            } catch (_) {}
          }
          // Version 5: Added auto-sync preference.
          if (from < 5) {
            try {
              await m.addColumn(userPreferences, userPreferences.autoSync);
            } catch (_) {}
          }
          // Version 6: Added CEFR levels to vocabulary.
          if (from < 6) {
            try {
              await m.addColumn(vocabularyWords, vocabularyWords.level);
            } catch (_) {}
          }
          // Version 7: Introduced structured vocabulary groups and categories.
          if (from < 7) {
            await m.createTable(vocabularyGroups);
            await m.createTable(vocabularyCategories);
          }
          // Version 8: Cloud sync support; track which categories are local.
          if (from < 8) {
            await m.addColumn(
                vocabularyCategories, vocabularyCategories.isCached);
            await m.createTable(vocabularyPendingCategories);
          }
          // Version 9: Added metadata for progress bars (word counts).
          if (from < 9) {
            try {
              await m.addColumn(
                  vocabularyCategories, vocabularyCategories.wordCount);
            } catch (_) {}
            try {
              await m.addColumn(vocabularyPendingCategories,
                  vocabularyPendingCategories.wordCount);
            } catch (_) {}
          }
          // Version 10: Rich grammar detail caching.
          if (from < 10) {
            await m.createTable(grammarDetails);
          }
          // Version 11: Added category filtering for grammar details.
          if (from < 11) {
            try {
              await m.addColumn(grammarDetails, grammarDetails.category);
            } catch (_) {}
          }
          // Version 12: Scoped exercise attempts (differentiate between modules).
          if (from < 12) {
            try {
              await m.addColumn(exerciseAttempts, exerciseAttempts.scope);
            } catch (_) {}
            await customStatement(
              "UPDATE exercise_attempts SET scope = 'exercises' WHERE COALESCE(scope, '') = ''",
            );
          }

          // Version 13: Add missing columns to achievements table for improved tracking and normalization.
          if (from < 13) {
            try {
              await m.addColumn(achievements, achievements.unlockedAt);
              await m.addColumn(achievements, achievements.updatedAt);
            } catch (_) {
              // Ignore if columns already exist (e.g., from failed partial migrations)
            }
          }
          // Version 14: Central Content Synchronization Infrastructure.
          // - Creates 'sync_metadata' to track the lastSyncAt high-water mark per collection.
          // - Creates 'dialogues' table to migrate dialogue scenarios from local assets to database.
          // - Adds 'updatedAt' columns to all syncable content tables for delta-based cloud updates.
          if (from < 14) {
            await m.createTable(syncMetadata);
            await m.createTable(dialogues);
            try {
              await m.addColumn(vocabularyGroups, vocabularyGroups.updatedAt);
              await m.addColumn(
                  vocabularyCategories, vocabularyCategories.updatedAt);
              await m.addColumn(vocabularyWords, vocabularyWords.updatedAt);
              await m.addColumn(grammarTopics, grammarTopics.updatedAt);
              await m.addColumn(grammarDetails, grammarDetails.updatedAt);
              await m.addColumn(exercises, exercises.updatedAt);
            } catch (_) {
              // Ignore if columns already exist from a partially failed previous migration
            }
          }
          await createManualIndexes();
        },
        beforeOpen: (details) async {
          // Patch for SQLite versions that don't support modern DateTime formats.
          await _normalizeLegacyDateTimeStorage();

          if (_seedContent) {
            if (details.wasCreated) {
              await _seedInitialData(force: true);
            } else if ((details.versionBefore ?? 0) > 0 &&
                (details.versionBefore ?? 0) < schemaVersion) {
              // Forced reseed if moving from a very old version with missing relationships.
              if ((details.versionBefore ?? 0) < 8) {
                await _seedInitialData(force: true);
              }
            }

            await _seedIfContentMissing();
            await _backfillVocabularyMeaningsIfMissing();
          }
        },
      );

  /// Creates non-standard indexes to optimize frequent queries on large tables.
  Future<void> createManualIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vocab_category ON vocabulary_words (category)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vocab_level ON vocabulary_words (level)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vocab_difficulty ON vocabulary_words (difficulty)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vocab_favorite ON vocabulary_words (is_favorite)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vocab_progress_status_next_review ON vocabulary_progress (status, next_review_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vocab_progress_mastered ON vocabulary_progress (mastered_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_grammar_level ON grammar_topics (level)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_grammar_category ON grammar_topics (category)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_exercises_type_level ON exercises (type, level)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_exercise_attempts_topic_answered ON exercise_attempts (topic, answered_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_exercise_attempts_scope_topic_answered ON exercise_attempts (scope, topic, answered_at)',
    );
  }

  /// Verifies if core app content is present and triggers a re-seed if tables are empty.
  ///
  /// Also performs a weekly XP reset check when the database is first initialized.
  Future<void> _seedIfContentMissing() async {
    final vocabCountExp = vocabularyWords.id.count();
    final exerciseCountExp = exercises.id.count();
    final grammarCountExp = grammarTopics.id.count();
    final dialogueCountExp = dialogues.id.count();

    final vocabCountRow = await (selectOnly(vocabularyWords)
          ..addColumns([vocabCountExp]))
        .getSingle();
    final exerciseCountRow = await (selectOnly(exercises)
          ..addColumns([exerciseCountExp]))
        .getSingle();
    final grammarCountRow = await (selectOnly(grammarTopics)
          ..addColumns([grammarCountExp]))
        .getSingle();
    final dialogueCountRow = await (selectOnly(dialogues)
          ..addColumns([dialogueCountExp]))
        .getSingle();

    final vocabCount = vocabCountRow.read(vocabCountExp) ?? 0;
    final exerciseCount = exerciseCountRow.read(exerciseCountExp) ?? 0;
    final grammarCount = grammarCountRow.read(grammarCountExp) ?? 0;
    final dialogueCount = dialogueCountRow.read(dialogueCountExp) ?? 0;

    final groupCountRow =
        await customSelect('SELECT COUNT(*) AS c FROM vocabulary_groups')
            .getSingle();
    final groupCount = (groupCountRow.data['c'] as int?) ?? 0;
    final vocabularyContentOutdated = await _isVocabularyContentOutdated();

    if (vocabCount == 0 ||
        exerciseCount == 0 ||
        grammarCount == 0 ||
        dialogueCount == 0 ||
        groupCount == 0 ||
        vocabularyContentOutdated) {
      await _seedInitialData();
      await vocabularyDao.migrateLegacyCategories();
      return;
    }

    // Always run migration to ensure any legacy categories in existing words match the new UI
    await vocabularyDao.migrateLegacyCategories();

    // Weekly reset check for the leaderboard/progress summary.
    await userDao.syncWeeklyProgressIfNewWeek();

    // Perform a background sync if asset files appear to have more entries than the local state.
    final allVocabData =
        await ContentLoader.loadVocabulary(ContentAssets.vocabulary);
    final grammarData = await ContentLoader.loadMany(ContentAssets.grammar);
    final allExerciseData =
        await ContentLoader.loadExercises(ContentAssets.exercises);

    if (allVocabData.length != vocabCount ||
        grammarData.length > grammarCount ||
        allExerciseData.length != exerciseCount ||
        dialogueCount != _dialogueIds.length) {
      await _seedInitialData();
    }
  }

  /// Ensures every vocabulary word has its translated meaning (Dari/Persian) populated.
  Future<void> _backfillVocabularyMeaningsIfMissing() async {
    final missingRow = await customSelect(
      '''
SELECT COUNT(*) AS c
FROM vocabulary_words
WHERE TRIM(COALESCE(dari, '')) = ''
''',
    ).getSingle();

    final missingCount = (missingRow.data['c'] as int?) ?? 0;
    if (missingCount == 0) {
      return;
    }

    final vocabulary = await ContentLoader.loadMany(ContentAssets.vocabulary);

    await transaction(() async {
      for (final row in vocabulary) {
        final id = (row['id'] ?? '').toString();
        final dari = (row['dari'] ?? '').toString();
        if (id.isEmpty || dari.isEmpty) {
          continue;
        }
        await customStatement(
          '''
UPDATE vocabulary_words
SET dari = ?
WHERE id = ? AND TRIM(COALESCE(dari, '')) = ''
''',
          [dari, id],
        );
      }
    });
  }

  /// The primary content ingestion logic.
  ///
  /// Loads raw data from all asset folders and inserts or replaces rows in the database.
  /// Uses a transaction to ensure atomic updates across related tables.
  Future<void> _seedInitialData({bool force = false}) async {
    final vocabulary =
        await ContentLoader.loadVocabulary(ContentAssets.vocabulary);
    final exerciseData =
        await ContentLoader.loadExercises(ContentAssets.exercises);
    final grammarData = await ContentLoader.loadMany(ContentAssets.grammar);
    final achievementsData = await ContentLoader.loadList(
      'assets/content/achievements/achievements.json',
    );
    final groupsData =
        await ContentLoader.loadList(ContentAssets.vocabularyGroups);
    final categoriesData =
        await ContentLoader.loadList(ContentAssets.vocabularyCategories);

    final dialoguesData = <Map<String, dynamic>>[];
    for (final id in _dialogueIds) {
      try {
        final data =
            await ContentLoader.loadMap('assets/content/dialogues/$id.json');
        data['id'] = id;
        dialoguesData.add(data);
      } catch (_) {}
    }

    await transaction(() async {
      final existingStats = await (select(userStats)
            ..where((t) => t.id.equals(1)))
          .getSingleOrNull();
      if (existingStats == null) {
        await into(userStats).insert(
          UserStatsCompanion.insert(
            id: const Value(1),
            xp: const Value(0),
            streak: const Value(0),
            wordsLearned: const Value(0),
            exercisesCompleted: const Value(0),
            grammarTopicsCompleted: const Value(0),
            weeklyProgress: const Value(0),
            level: const Value('A1'),
            weakAreasJson: Value(jsonEncode(const <String>[])),
          ),
        );
      }

      final existingPrefs = await (select(userPreferences)
            ..where((t) => t.id.equals(1)))
          .getSingleOrNull();
      if (existingPrefs == null) {
        await into(userPreferences)
            .insert(const UserPreferencesCompanion(id: Value(1)));
      }

      await vocabularyDao.upsertVocabularyGroups(groupsData);
      await vocabularyDao.upsertVocabularyCategories(categoriesData,
          isCached: true);
      await _deleteStaleVocabularyContent(vocabulary, categoriesData, groupsData);
      await vocabularyDao.upsertVocabularyContent(vocabulary);

      // Clear old exercises to remove any deleted JSON entries (e.g., outdated vocab exercises)
      await exerciseDao.clearAllExercises();

      await exerciseDao.insertAllExercises(
        exerciseData
            .map((row) => ExercisesCompanion.insert(
                  id: (row['id'] ?? '').toString(),
                  type: (row['type'] ?? '').toString(),
                  question: (row['question'] ?? '').toString(),
                  optionsJson: jsonEncode(
                    (row['options'] as List<dynamic>? ?? const <dynamic>[])
                        .map((e) => e.toString())
                        .toList(),
                  ),
                  correctAnswer: (row['correctAnswer'] as num?)?.toInt() ?? 0,
                  topic: (row['topic'] ?? '').toString(),
                  level: (row['level'] ?? '').toString(),
                ))
            .toList(),
      );

      await batch((b) {
        b.insertAll(
          achievements,
          achievementsData.map(
            (row) => AchievementsCompanion.insert(
              id: (row['id'] ?? '').toString(),
              title: (row['title'] ?? '').toString(),
              description: (row['description'] ?? '').toString(),
              icon: (row['icon'] ?? '').toString(),
              unlocked: Value((row['unlocked'] as bool?) ?? false),
            ),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      });

      // Grammar topics are upserted manually to preserve current progress stats (percentage).
      for (final row in grammarData) {
        final examplesJson = jsonEncode(
          (row['examples'] as List<dynamic>? ?? const <dynamic>[])
              .map((e) => e.toString())
              .toList(),
        );
        await grammarDao.upsertGrammarTopic(
          id: (row['id'] ?? '').toString(),
          title: (row['title'] ?? '').toString(),
          level: (row['level'] ?? '').toString(),
          category: (row['category'] ?? '').toString(),
          icon: (row['icon'] ?? '').toString(),
          rule: (row['rule'] ?? '').toString(),
          explanation: (row['explanation'] ?? '').toString(),
          examplesJson: examplesJson,
        );
      }

      for (final row in dialoguesData) {
        await into(dialogues).insertOnConflictUpdate(
          DialoguesCompanion.insert(
            id: row['id'].toString(),
            title: row['title']?.toString() ?? '',
            englishTitle: Value(row['english_title']?.toString() ?? ''),
            description: Value(row['description']?.toString() ?? ''),
            level: row['level']?.toString() ?? 'A1',
            category: row['category']?.toString() ?? 'General',
            icon: Value(row['icon']?.toString() ?? ''),
            entriesJson: jsonEncode(row['messages'] ?? []),
          ),
        );
      }
    });

    await _markVocabularyContentCurrent();
  }

  Future<bool> _isVocabularyContentOutdated() async {
    final row = await (select(syncMetadata)
          ..where((t) => t.id.equals(_vocabularySyncMetadataId)))
        .getSingleOrNull();
    return row?.lastSyncAt != _vocabularyContentStampDate();
  }

  Future<void> _markVocabularyContentCurrent() {
    return into(syncMetadata).insertOnConflictUpdate(
      SyncMetadataCompanion.insert(
        id: _vocabularySyncMetadataId,
        lastSyncAt: _vocabularyContentStampDate(),
      ),
    );
  }

  DateTime _vocabularyContentStampDate() {
    var checksum = 17;
    for (final codeUnit in ContentAssets.vocabularyContentStamp.codeUnits) {
      checksum = ((checksum * 31) + codeUnit) & 0x7fffffff;
    }
    return DateTime.fromMillisecondsSinceEpoch(checksum, isUtc: true);
  }

  Future<void> _deleteStaleVocabularyContent(
    List<Map<String, dynamic>> vocabulary,
    List<Map<String, dynamic>> categoriesData,
    List<Map<String, dynamic>> groupsData,
  ) async {
    final currentWordIds = vocabulary
        .map((row) => (row['id'] ?? '').toString())
        .where((id) => id.isNotEmpty)
        .toSet();
    final currentCategoryIds = categoriesData
        .map((row) => (row['id'] ?? '').toString())
        .where((id) => id.isNotEmpty)
        .toSet();
    final currentGroupIds = groupsData
        .map((row) => (row['id'] ?? '').toString())
        .where((id) => id.isNotEmpty)
        .toSet();

    final existingWordRows =
        await (selectOnly(vocabularyWords)..addColumns([vocabularyWords.id]))
            .get();
    final staleWordIds = existingWordRows
        .map((row) => row.read(vocabularyWords.id) ?? '')
        .where((id) => id.isNotEmpty && !currentWordIds.contains(id))
        .toList();
    await _deleteWordIds(staleWordIds);

    final existingPendingRows = await (selectOnly(vocabularyPendingCategories)
          ..addColumns([vocabularyPendingCategories.id]))
        .get();
    final stalePendingIds = existingPendingRows
        .map((row) => row.read(vocabularyPendingCategories.id) ?? '')
        .where((id) => id.isNotEmpty && !currentCategoryIds.contains(id))
        .toList();
    await _deletePendingCategoryIds(stalePendingIds);

    final existingCategoryRows = await (selectOnly(vocabularyCategories)
          ..addColumns([vocabularyCategories.id]))
        .get();
    final staleCategoryIds = existingCategoryRows
        .map((row) => row.read(vocabularyCategories.id) ?? '')
        .where((id) => id.isNotEmpty && !currentCategoryIds.contains(id))
        .toList();
    await _deleteCategoryIds(staleCategoryIds);

    final existingGroupRows =
        await (selectOnly(vocabularyGroups)..addColumns([vocabularyGroups.id]))
            .get();
    final staleGroupIds = existingGroupRows
        .map((row) => row.read(vocabularyGroups.id) ?? '')
        .where((id) => id.isNotEmpty && !currentGroupIds.contains(id))
        .toList();
    await _deleteGroupIds(staleGroupIds);
  }

  Future<void> _deleteWordIds(List<String> ids) async {
    for (final chunk in _chunk(ids, 200)) {
      await (delete(vocabularyProgress)
            ..where((t) => t.wordId.isIn(chunk)))
          .go();
      await (delete(vocabularyWords)..where((t) => t.id.isIn(chunk))).go();
    }
  }

  Future<void> _deletePendingCategoryIds(List<String> ids) async {
    for (final chunk in _chunk(ids, 200)) {
      await (delete(vocabularyPendingCategories)
            ..where((t) => t.id.isIn(chunk)))
          .go();
    }
  }

  Future<void> _deleteCategoryIds(List<String> ids) async {
    for (final chunk in _chunk(ids, 200)) {
      await (delete(vocabularyCategories)..where((t) => t.id.isIn(chunk))).go();
    }
  }

  Future<void> _deleteGroupIds(List<String> ids) async {
    for (final chunk in _chunk(ids, 200)) {
      await (delete(vocabularyGroups)..where((t) => t.id.isIn(chunk))).go();
    }
  }

  Iterable<List<String>> _chunk(List<String> values, int size) sync* {
    if (values.isEmpty) {
      return;
    }

    for (var i = 0; i < values.length; i += size) {
      final end = (i + size < values.length) ? i + size : values.length;
      yield values.sublist(i, end);
    }
  }

  /// Destructive reset that clears user stats, progress, and attempts while keeping content.
  Future<void> resetAllUserProgress() async {
    await transaction(() async {
      await (update(userStats)..where((t) => t.id.equals(1))).write(
        const UserStatsCompanion(
          xp: Value(0),
          streak: Value(0),
          wordsLearned: Value(0),
          exercisesCompleted: Value(0),
          grammarTopicsCompleted: Value(0),
          weeklyProgress: Value(0),
          level: Value('A1'),
          weakAreasJson: Value('[]'),
        ),
      );

      await (update(grammarTopics)).write(
        const GrammarTopicsCompanion(progress: Value(0)),
      );

      await delete(exerciseAttempts).go();
      await delete(vocabularyProgress).go();
      await (update(achievements)).write(
        const AchievementsCompanion(unlocked: Value(false)),
      );
    });
  }

  /// Explicitly triggers a content re-seed from local asset files.
  Future<void> reseedContent() async {
    await _seedInitialData();
  }

  /// Patch for SQLite versions that don't support modern DateTime formats.
  /// Converts any accidental ISO string dates in existing columns to millisecond integers.
  Future<void> _normalizeLegacyDateTimeStorage() async {
    final dateColumns = {
      'user_stats': ['updated_at'],
      'user_preferences': ['updated_at'],
      'vocabulary_words': ['updated_at'],
      'vocabulary_progress': [
        'last_reviewed_at',
        'next_review_at',
        'mastered_at',
        'updated_at'
      ],
      'grammar_topics': ['updated_at'],
      'grammar_details': ['updated_at'],
      'exercises': ['updated_at'],
      'exercise_attempts': ['answered_at'],
      'achievements': ['unlocked_at', 'updated_at'],
    };

    await transaction(() async {
      for (final table in dateColumns.keys) {
        for (final column in dateColumns[table]!) {
          try {
            await customStatement('''
              UPDATE $table 
              SET $column = CAST(strftime('%s', $column) AS INTEGER) * 1000 
              WHERE $column IS NOT NULL AND TYPEOF($column) = 'text' AND $column LIKE '20%';
            ''');
          } catch (e) {
            // Log and ignore to prevent startup crashes. This usually means a column hasn't
            // been added to the database yet, which is fine since the normalization
            // will just skip it until it exists.
            debugPrint('Failed to normalize $table.$column: $e');
          }
        }
      }
    });
  }

  /// Gracefully shuts down the database connection and frees resources.
  Future<void> disposeDatabase() async {
    await close();
  }
}
