import 'dart:io';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'seed_data.dart';
import 'seed_data_expansion.dart';
import 'seed_data_validation.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    VocabularyWords,
    GrammarTopics,
    Exercises,
    Achievements,
    UserStats,
    UserPreferences,
    ContentManifest,
    MutationQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          driftDatabase(
            name: 'deutschlernen.sqlite',
            native: DriftNativeOptions(
              databaseDirectory: getApplicationDocumentsDirectory,
            ),
          ),
        );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
            'CREATE INDEX idx_vocab_category ON vocabulary_words (category)',
          );
          await customStatement(
            'CREATE INDEX idx_vocab_difficulty ON vocabulary_words (difficulty)',
          );
          await customStatement(
            'CREATE INDEX idx_vocab_favorite ON vocabulary_words (is_favorite)',
          );
          await customStatement(
            'CREATE INDEX idx_grammar_level ON grammar_topics (level)',
          );
          await customStatement(
            'CREATE INDEX idx_grammar_category ON grammar_topics (category)',
          );
          await customStatement(
            'CREATE INDEX idx_exercises_type_level ON exercises (type, level)',
          );
          await _seedInitialData();
        },
        beforeOpen: (details) async {
          if (!details.wasCreated) {
            await _seedInitialData();
          }
        },
      );

  Future<void> _seedInitialData() async {
    assertSeedDataIsValid();

    final allVocabularySeed = [...vocabularySeed, ...vocabularySeedExpansion];
    final allExerciseSeed = [...exerciseSeed, ...exerciseSeedExpansion];

    final existingStats = await (select(userStats)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
    if (existingStats == null) {
      await into(userStats).insert(
        UserStatsCompanion.insert(
          id: const Value(1),
          xp: const Value(1250),
          streak: const Value(5),
          wordsLearned: const Value(55),
          exercisesCompleted: const Value(23),
          grammarTopicsCompleted: const Value(3),
          weeklyProgress: const Value(68),
          level: const Value('A2'),
          weakAreasJson: Value(
            jsonEncode(['Konjunktiv', 'Nebensatze']),
          ),
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

    final existingManifest = await (select(contentManifest)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
    if (existingManifest == null) {
      await into(contentManifest)
          .insert(const ContentManifestCompanion(id: Value(1)));
    }

    await batch((b) {
      b.insertAllOnConflictUpdate(
        vocabularyWords,
        allVocabularySeed
            .map(
              (row) => VocabularyWordsCompanion.insert(
                id: row['id']! as String,
                german: row['german']! as String,
                phonetic: row['phonetic']! as String,
                english: row['english']! as String,
                dari: row['dari']! as String,
                category: row['category']! as String,
                tag: row['tag']! as String,
                example: row['example']! as String,
                context: row['context']! as String,
                contextDari: row['contextDari']! as String,
                difficulty: row['difficulty']! as String,
                isFavorite: Value(row['isFavorite']! as bool),
                isDifficult: Value(row['isDifficult']! as bool),
              ),
            )
            .toList(),
      );

      b.insertAllOnConflictUpdate(
        exercises,
        allExerciseSeed
            .map(
              (row) => ExercisesCompanion.insert(
                id: row['id']! as String,
                type: row['type']! as String,
                question: row['question']! as String,
                optionsJson: jsonEncode(
                  row['options']! as List<String>,
                ),
                correctAnswer: row['correctAnswer']! as int,
                topic: row['topic']! as String,
                level: row['level']! as String,
              ),
            )
            .toList(),
      );

      b.insertAllOnConflictUpdate(achievements, [
        AchievementsCompanion.insert(
          id: 'a1',
          title: 'Erste Schritte',
          description: 'Complete your first lesson',
          icon: '🎯',
          unlocked: const Value(true),
        ),
        AchievementsCompanion.insert(
          id: 'a2',
          title: 'Wortmeister',
          description: 'Learn 10 vocabulary words',
          icon: '📚',
          unlocked: const Value(true),
        ),
        AchievementsCompanion.insert(
          id: 'a3',
          title: 'Grammatik-Guru',
          description: 'Complete 5 grammar topics',
          icon: '🧠',
          unlocked: const Value(false),
        ),
        AchievementsCompanion.insert(
          id: 'a4',
          title: 'Flammen-Held',
          description: '7-day learning streak',
          icon: '🔥',
          unlocked: const Value(true),
        ),
        AchievementsCompanion.insert(
          id: 'a5',
          title: 'Perfektionist',
          description: 'Score 100% on an exercise',
          icon: '💎',
          unlocked: const Value(false),
        ),
        AchievementsCompanion.insert(
          id: 'a6',
          title: 'Business-Profi',
          description: 'Learn all business vocabulary',
          icon: '💼',
          unlocked: const Value(false),
        ),
      ]);
    });
  }

  Future<void> reseedContent() async {
    await _seedInitialData();
  }

  Future<void> disposeDatabase() async {
    await close();
  }

  Future<File> debugDatabaseFile() async {
    final base = await getApplicationDocumentsDirectory();
    return File(p.join(base.path, 'deutschlernen.sqlite'));
  }
}
