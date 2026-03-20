import 'dart:io';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../content/content_assets.dart';
import '../content/content_loader.dart';
import '../learning/review_logic.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// The main database class for the application.
///
/// This class manages all database connections and data updates.
/// It uses the Drift library to work with SQLite.
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.executor, {required bool seedContent})
      : _seedContent = seedContent;

  AppDatabase()
      : _seedContent = true,
        super(
          driftDatabase(
            name: 'deutschlernen.sqlite',
            native: DriftNativeOptions(
              databaseDirectory: getApplicationDocumentsDirectory,
            ),
          ),
        );

  AppDatabase.forTesting(QueryExecutor executor, {bool seedContent = false})
      : this._(executor, seedContent: seedContent);

  final bool _seedContent;

  /// The current version of the database.
  ///
  /// Incremented when tables or columns change.
  @override
  int get schemaVersion => 4;

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
          if (from < 2) {
            await m.createTable(vocabularyProgress);
            await m.createTable(exerciseAttempts);
          }
          if (from < 3) {
            // Recreate vocabulary_words due to phonetic column removal
            await m.deleteTable(vocabularyWords.actualTableName);
            await m.createTable(vocabularyWords);
          }
          if (from < 4) {
            await m.addColumn(
                userPreferences, userPreferences.hasSeenOnboarding);
          }
          await createManualIndexes();
        },
        beforeOpen: (details) async {
          await _normalizeLegacyDateTimeStorage();

          if (_seedContent) {
            if (details.wasCreated) {
              await _seedInitialData(force: true);
            } else if ((details.versionBefore ?? 0) > 0 &&
                (details.versionBefore ?? 0) < schemaVersion) {
              // Future migration seeding could go here
            }

            await _seedIfContentMissing();
            await _backfillVocabularyMeaningsIfMissing();
          }
        },
      );

  Future<void> createManualIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vocab_category ON vocabulary_words (category)',
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
  }

  Future<void> _seedIfContentMissing() async {
    final vocabCountExp = vocabularyWords.id.count();
    final exerciseCountExp = exercises.id.count();
    final grammarCountExp = grammarTopics.id.count();

    final vocabCountRow = await (selectOnly(vocabularyWords)
          ..addColumns([vocabCountExp]))
        .getSingle();
    final exerciseCountRow = await (selectOnly(exercises)
          ..addColumns([exerciseCountExp]))
        .getSingle();
    final grammarCountRow = await (selectOnly(grammarTopics)
          ..addColumns([grammarCountExp]))
        .getSingle();

    final vocabCount = vocabCountRow.read(vocabCountExp) ?? 0;
    final exerciseCount = exerciseCountRow.read(exerciseCountExp) ?? 0;
    final grammarCount = grammarCountRow.read(grammarCountExp) ?? 0;

    if (vocabCount == 0 || exerciseCount == 0 || grammarCount == 0) {
      await _seedInitialData();
      return;
    }

    // Weekly reset check
    final stats = await (select(userStats)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (stats != null) {
      final now = DateTime.now();
      final lastWeek = _getIsoWeek(stats.updatedAt);
      final currentWeek = _getIsoWeek(now);

      if (currentWeek != lastWeek) {
        await (update(userStats)..where((t) => t.id.equals(1))).write(
          const UserStatsCompanion(
            weeklyProgress: Value(0),
          ),
        );
      }
    }

    // Also reseed when new grammar topics or exercises have been added to JSON files.
    // _seedInitialData uses insertOrReplace, and we clear old exercises so they are fully synced.
    final allVocabData = await ContentLoader.loadMany(ContentAssets.vocabulary);
    final grammarData = await ContentLoader.loadAllLevels(
      'grammar',
      ['topics_a1', 'topics_a2', 'topics_b1', 'topics_b2', 'topics_c1'],
    );
    final allExerciseData = await ContentLoader.loadAllLevels(
      'exercises',
      ['a1', 'a2', 'b1', 'b2', 'c1'],
    );

    if (allVocabData.length != vocabCount ||
        grammarData.length > grammarCount ||
        allExerciseData.length != exerciseCount) {
      await _seedInitialData();
    }
  }

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

  Future<void> _seedInitialData({bool force = false}) async {
    final vocabulary = await ContentLoader.loadMany(ContentAssets.vocabulary);
    final exerciseData = await ContentLoader.loadAllLevels(
      'exercises',
      ['a1', 'a2', 'b1', 'b2', 'c1'],
    );
    final grammarData = await ContentLoader.loadAllLevels(
      'grammar',
      ['topics_a1', 'topics_a2', 'topics_b1', 'topics_b2', 'topics_c1'],
    );
    final achievementsData = await ContentLoader.loadList(
      'assets/content/achievements/achievements.json',
    );

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

      await _upsertVocabularyContent(vocabulary);

      // Clear old exercises to remove any deleted JSON entries (e.g., old vocab exercises)
      await delete(exercises).go();

      await batch((b) {
        b.insertAll(
          exercises,
          exerciseData.map((row) => ExercisesCompanion.insert(
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
              )),
          mode: InsertMode.insertOrReplace,
        );

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

      // Grammar topics are upserted individually so we can preserve
      // existing progress while updating metadata for existing topics.
      for (final row in grammarData) {
        final id = (row['id'] ?? '').toString();
        final examplesJson = jsonEncode(
          (row['examples'] as List<dynamic>? ?? const <dynamic>[])
              .map((e) => e.toString())
              .toList(),
        );
        await customStatement(
          '''
INSERT INTO grammar_topics (id, title, level, category, icon, rule, explanation, examples_json, progress)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)
ON CONFLICT(id) DO UPDATE SET
  title = excluded.title,
  level = excluded.level,
  category = excluded.category,
  icon = excluded.icon,
  rule = excluded.rule,
  explanation = excluded.explanation,
  examples_json = excluded.examples_json,
  updated_at = (CAST(strftime('%s', 'now') AS INTEGER) * 1000)
''',
          [
            id,
            (row['title'] ?? '').toString(),
            (row['level'] ?? '').toString(),
            (row['category'] ?? '').toString(),
            (row['icon'] ?? '').toString(),
            (row['rule'] ?? '').toString(),
            (row['explanation'] ?? '').toString(),
            examplesJson,
          ],
        );
      }
    });
  }

  /// Deletes all user progress and resets the app to a fresh state.
  ///
  /// This keeps the grammar topics and vocabulary words but resets
  /// scores, XP, and mastered status.
  Future<void> resetAllUserProgress() async {
    await transaction(() async {
      // 1. Reset UserStats
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

      // 2. Reset all grammar progress
      await (update(grammarTopics)).write(
        const GrammarTopicsCompanion(progress: Value(0)),
      );

      // 3. Clear exercise attempts
      await delete(exerciseAttempts).go();

      // 4. Clear vocabulary progress
      await delete(vocabularyProgress).go();

      // 5. Clear achievement progress (optional, but requested 'start fresh')
      await (update(achievements)).write(
        const AchievementsCompanion(unlocked: Value(false)),
      );
    });
  }

  Future<void> _upsertVocabularyContent(List<Map<String, dynamic>> rows) async {
    for (final row in rows) {
      await customStatement(
        '''
INSERT INTO vocabulary_words (
  id,
  german,
  english,
  dari,
  category,
  tag,
  example,
  context,
  context_dari,
  difficulty,
  is_favorite,
  is_difficult
)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
ON CONFLICT(id) DO UPDATE SET
  german = excluded.german,
  english = excluded.english,
  dari = excluded.dari,
  category = excluded.category,
  tag = excluded.tag,
  example = excluded.example,
  context = excluded.context,
  context_dari = excluded.context_dari,
  difficulty = excluded.difficulty,
  updated_at = (CAST(strftime('%s', 'now') AS INTEGER) * 1000)
''',
        [
          (row['id'] ?? '').toString(),
          (row['german'] ?? '').toString(),
          (row['english'] ?? '').toString(),
          (row['dari'] ?? '').toString(),
          (row['category'] ?? '').toString(),
          (row['tag'] ?? '').toString(),
          (row['example'] ?? '').toString(),
          (row['context'] ?? '').toString(),
          (row['contextDari'] ?? '').toString(),
          (row['difficulty'] ?? '').toString(),
          ((row['isFavorite'] as bool?) ?? false) ? 1 : 0,
          ((row['isDifficult'] as bool?) ?? false) ? 1 : 0,
        ],
      );
    }
  }

  Future<void> _normalizeLegacyDateTimeStorage() async {
    // Legacy rows may contain text timestamps; DateTime columns expect epoch millis.
    await customStatement('''
UPDATE vocabulary_words
SET updated_at = (CAST(strftime('%s', updated_at) AS INTEGER) * 1000)
WHERE typeof(updated_at) = 'text'
''');
  }

  /// Updates the learning progress for a specific grammar topic.
  Future<void> updateGrammarProgress(String topicId, int progress) {
    return transaction(() async {
      await (update(grammarTopics)..where((t) => t.id.equals(topicId))).write(
        GrammarTopicsCompanion(
          progress: Value(progress),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await _refreshGrammarCompletionStats();
    });
  }

  /// Marks a word as a "favorite" or removes the favorite mark.
  Future<void> toggleFavorite(String wordId) async {
    await transaction(() async {
      final word = await (select(vocabularyWords)
            ..where((t) => t.id.equals(wordId)))
          .getSingleOrNull();
      if (word != null) {
        await (update(vocabularyWords)..where((t) => t.id.equals(wordId)))
            .write(
          VocabularyWordsCompanion(
            isFavorite: Value(!word.isFavorite),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    });
  }

  /// Sets how difficult a word is for the user (e.g., 'easy', 'hard').
  Future<void> setWordDifficulty(String wordId, String difficulty) {
    final normalizedDifficulty = difficulty.toLowerCase();
    return (update(vocabularyWords)..where((t) => t.id.equals(wordId))).write(
      VocabularyWordsCompanion(
        difficulty: Value(normalizedDifficulty),
        isDifficult: Value(normalizedDifficulty == 'hard' ||
            normalizedDifficulty == 'difficult'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }


  /// Saves the result of a vocabulary practice session.
  ///
  /// It calculates when the word should be reviewed next.
  Future<void> recordVocabularyReview({
    required String wordId,
    required ReviewResult result,
  }) async {
    await transaction(() async {
      final current = await (select(vocabularyProgress)
            ..where((t) => t.wordId.equals(wordId)))
          .getSingleOrNull();

      final now = DateTime.now();
      final update = calculateReviewUpdate(
        result: result,
        now: now,
        current: current == null
            ? null
            : ReviewSnapshot(
                leitnerBox: current.leitnerBox,
                reviewCount: current.reviewCount,
                lapseCount: current.lapseCount,
              ),
      );

      await into(vocabularyProgress).insertOnConflictUpdate(
        VocabularyProgressCompanion.insert(
          wordId: wordId,
          leitnerBox: Value(update.leitnerBox),
          status: Value(update.status.value),
          lastResult: Value(update.lastResult.value),
          reviewCount: Value(update.reviewCount),
          lapseCount: Value(update.lapseCount),
          lastReviewedAt: Value(update.lastReviewedAt),
          nextReviewAt: Value(update.nextReviewAt),
          masteredAt: Value(update.masteredAt),
          updatedAt: Value(now),
        ),
      );
    });
  }

  /// Changes the app theme to dark mode or light mode.
  Future<void> setDarkMode(bool value) {
    return (update(userPreferences)..where((t) => t.id.equals(1))).write(
      UserPreferencesCompanion(
        darkMode: Value(value),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> reseedContent() async {
    await _seedInitialData();
  }


  Future<int> _completedGrammarTopicCount() async {
    final rows = await (select(grammarTopics)
          ..where((t) => t.progress.equals(100)))
        .get();
    return rows.length;
  }

  Future<void> _refreshGrammarCompletionStats() async {
    await (update(userStats)..where((t) => t.id.equals(1))).write(
      UserStatsCompanion(
        grammarTopicsCompleted: Value(await _completedGrammarTopicCount()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> resetGrammarTopicExercises(String topicTitle) async {
    await transaction(() async {
      final topicRow = await (select(grammarTopics)
            ..where((t) => t.title.equals(topicTitle)))
          .getSingleOrNull();
      if (topicRow == null) return;

      // Phase 2: Exact match only
      await (delete(exerciseAttempts)
            ..where((t) => t.topic.equals(topicTitle)))
          .go();

      await (update(grammarTopics)..where((t) => t.id.equals(topicRow.id)))
          .write(
        GrammarTopicsCompanion(
          progress: const Value(0),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await _refreshGrammarCompletionStats();
    });
  }

  /// Saves the result of a practice exercise.
  ///
  /// It updates the user's XP and checks if grammar progress has improved.
  Future<void> recordExerciseOutcome({
    required String exerciseId,
    required bool isCorrect,
    required int xpGained,
  }) async {
    final exerciseRow = await (select(exercises)..where((t) => t.id.equals(exerciseId))).getSingleOrNull();
    if (exerciseRow == null) return;

    final stats = await (select(userStats)..where((t) => t.id.equals(1))).getSingle();

    await (update(userStats)..where((t) => t.id.equals(1))).write(
      UserStatsCompanion(
        xp: Value(stats.xp + xpGained),
        exercisesCompleted: Value(stats.exercisesCompleted + 1),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await into(exerciseAttempts).insert(
      ExerciseAttemptsCompanion.insert(
        exerciseId: exerciseId,
        topic: exerciseRow.topic,
        level: exerciseRow.level,
        isCorrect: isCorrect,
        answeredAt: Value(DateTime.now()),
      ),
    );

    if (isCorrect) {
      await _syncGrammarCompletionForExercise(exerciseId);
    }
  }

  Future<void> _syncGrammarCompletionForExercise(String exerciseId) async {
    final attemptRef = await (select(exercises)..where((t) => t.id.equals(exerciseId))).getSingleOrNull();
    if (attemptRef == null) return;

    final topicTitle = attemptRef.topic;
    if (topicTitle.isEmpty) return;

    // Phase 2: Exact match only for reliability
    final topic = await (select(grammarTopics)..where((t) => t.title.equals(topicTitle))).getSingleOrNull();

    if (topic != null) {
      final allLinkedExercises = await (select(exercises)..where((t) => t.topic.equals(topic.title))).get();
      final linkedIds = allLinkedExercises.map((e) => e.id).toList();

      if (linkedIds.isEmpty) return;

      final correctAttempts = await (select(exerciseAttempts)
            ..where((t) => t.exerciseId.isIn(linkedIds) & t.isCorrect.equals(true)))
          .get();

      final distinctCorrectIds = correctAttempts.map((a) => a.exerciseId).toSet();
      final progress = ((distinctCorrectIds.length / linkedIds.length) * 100).round().clamp(0, 100);

      await (update(grammarTopics)..where((t) => t.id.equals(topic.id))).write(
        GrammarTopicsCompanion(
          progress: Value(progress),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await _refreshGrammarCompletionStats();
    }
  }

  int _getIsoWeek(DateTime date) {
    // Week number according to ISO 8601
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      return _getIsoWeek(DateTime(date.year - 1, 12, 31));
    }
    if (woy > 52 && DateTime(date.year, 12, 31).weekday < 4) {
      return 1;
    }
    return date.year * 100 + woy;
  }

  Future<void> disposeDatabase() async {
    await close();
  }

  Future<File> debugDatabaseFile() async {
    final base = await getApplicationDocumentsDirectory();
    return File(p.join(base.path, 'deutschlernen.sqlite'));
  }
  /// Remembers that the user has seen the "Quick Start" guide.
  Future<void> markOnboardingAsSeen() async {
    await (update(userPreferences)..where((t) => t.id.equals(1)))
        .write(UserPreferencesCompanion(hasSeenOnboarding: const Value(true)));
  }
}
