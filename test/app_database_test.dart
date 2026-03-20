import 'dart:io';

import 'package:deutschlernen_mobile/core/database/app_database.dart';
import 'package:deutschlernen_mobile/core/learning/review_logic.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  test('manual index creation is idempotent', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.createManualIndexes();
    await db.createManualIndexes();

    final rows = await db.customSelect('''
SELECT name
FROM sqlite_master
WHERE type = 'index' AND name LIKE 'idx_%'
ORDER BY name
''').get();

    final actual = rows.map((row) => row.data['name'] as String).toList();
    final expected = [
      'idx_exercises_type_level',
      'idx_grammar_category',
      'idx_grammar_level',
      'idx_vocab_category',
      'idx_vocab_difficulty',
      'idx_vocab_favorite',
    ];

    for (final e in expected) {
      expect(actual, contains(e), reason: 'Expected index $e to exist');
    }

    expect(actual.toSet().length, actual.length);
  });

  test('database opens on a fresh file and reopens cleanly', () async {
    final tempDir = await Directory.systemTemp.createTemp('deutschlernen_db_');
    addTearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    final dbPath = p.join(tempDir.path, 'test.sqlite');

    final firstOpen = AppDatabase.forTesting(NativeDatabase(File(dbPath)));
    await firstOpen.customSelect('SELECT 1').getSingle();
    await firstOpen.close();

    final secondOpen = AppDatabase.forTesting(NativeDatabase(File(dbPath)));
    addTearDown(secondOpen.close);

    final result =
        await secondOpen.customSelect('SELECT 1 AS value').getSingle();
    expect(result.data['value'], 1);
  });

  test('recordExerciseOutcome persists attempt history', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.customStatement('INSERT OR IGNORE INTO user_stats DEFAULT VALUES');

    await db.into(db.exercises).insert(
          ExercisesCompanion.insert(
            id: 'exercise-1',
            type: 'multiple-choice',
            question: 'Wie heißt das?',
            optionsJson: '["Antwort A", "Antwort B"]',
            correctAnswer: 0,
            topic: 'Konjunktiv',
            level: 'A1',
          ),
        );

    await db.recordExerciseOutcome(
      exerciseId: 'exercise-1',
      isCorrect: true,
      xpGained: 10,
    );

    final attempts = await db.select(db.exerciseAttempts).get();
    expect(attempts, hasLength(1));
    expect(attempts.single.exerciseId, 'exercise-1');
    expect(attempts.single.topic, 'Konjunktiv');
    expect(attempts.single.level, 'A1');
    expect(attempts.single.isCorrect, isTrue);

    final stats = await (db.select(db.userStats)..where((t) => t.id.equals(1)))
        .getSingle();
    expect(stats.xp, greaterThanOrEqualTo(10));
  });

  test('recordVocabularyReview persists leitner progress', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.recordVocabularyReview(
      wordId: 'word-1',
      result: ReviewResult.easy,
    );

    final progress = await db.select(db.vocabularyProgress).get();
    expect(progress, hasLength(1));
    expect(progress.single.wordId, 'word-1');
    expect(progress.single.leitnerBox, 2);
    expect(progress.single.status, 'learning');
    expect(progress.single.nextReviewAt, isNotNull);
    expect(progress.single.masteredAt, isNull);
  });
}
