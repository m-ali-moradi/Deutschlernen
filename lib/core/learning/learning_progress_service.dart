import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Owns grammar/exercise progress mutations outside the database layer.
class LearningProgressService {
  LearningProgressService(this._db);

  final AppDatabase _db;

  Future<void> updateGrammarProgress(String topicId, int progress) {
    return _db.transaction(() async {
      await (_db.update(_db.grammarTopics)..where((t) => t.id.equals(topicId)))
          .write(
        GrammarTopicsCompanion(
          progress: Value(progress),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await _refreshGrammarCompletionStats();
    });
  }

  Future<void> resetGrammarTopicExercises(String topicTitle) {
    return _db.transaction(() async {
      final topicRow = await (_db.select(_db.grammarTopics)
            ..where((t) => t.title.equals(topicTitle)))
          .getSingleOrNull();
      if (topicRow == null) return;

      await (_db.delete(_db.exerciseAttempts)
            ..where((t) =>
                t.topic.equals(topicTitle) & t.scope.equals('grammar_topic')))
          .go();

      await (_db.update(_db.grammarTopics)
            ..where((t) => t.id.equals(topicRow.id)))
          .write(
        GrammarTopicsCompanion(
          progress: const Value(0),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await _refreshGrammarCompletionStats();
    });
  }

  Future<void> recordExerciseOutcome({
    required String exerciseId,
    required bool isCorrect,
    required int xpGained,
    required String scope,
    bool syncGrammarFromAttempt = true,
  }) async {
    final exerciseRow = await (_db.select(_db.exercises)
          ..where((t) => t.id.equals(exerciseId)))
        .getSingleOrNull();
    if (exerciseRow == null) return;

    final stats = await (_db.select(_db.userStats)
          ..where((t) => t.id.equals(1)))
        .getSingle();

    await (_db.update(_db.userStats)..where((t) => t.id.equals(1))).write(
      UserStatsCompanion(
        xp: Value(stats.xp + xpGained),
        exercisesCompleted: Value(stats.exercisesCompleted + 1),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _db.into(_db.exerciseAttempts).insert(
          ExerciseAttemptsCompanion.insert(
            exerciseId: exerciseId,
            scope: Value(scope),
            topic: exerciseRow.topic,
            level: exerciseRow.level,
            isCorrect: isCorrect,
            answeredAt: Value(DateTime.now()),
          ),
        );

    if (isCorrect && syncGrammarFromAttempt) {
      await _syncGrammarCompletionForExercise(exerciseId);
    }
  }

  Future<int> _completedGrammarTopicCount() async {
    final rows = await (_db.select(_db.grammarTopics)
          ..where((t) => t.progress.equals(100)))
        .get();
    return rows.length;
  }

  Future<void> _refreshGrammarCompletionStats() async {
    await (_db.update(_db.userStats)..where((t) => t.id.equals(1))).write(
      UserStatsCompanion(
        grammarTopicsCompleted: Value(await _completedGrammarTopicCount()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> _syncGrammarCompletionForExercise(String exerciseId) async {
    final attemptRef = await (_db.select(_db.exercises)
          ..where((t) => t.id.equals(exerciseId)))
        .getSingleOrNull();
    if (attemptRef == null) return;

    final topicTitle = attemptRef.topic;
    if (topicTitle.isEmpty) return;

    final topic = await (_db.select(_db.grammarTopics)
          ..where((t) => t.title.equals(topicTitle)))
        .getSingleOrNull();

    if (topic != null) {
      final allLinkedExercises = await (_db.select(_db.exercises)
            ..where((t) => t.topic.equals(topic.title)))
          .get();
      final linkedIds = allLinkedExercises.map((e) => e.id).toList();

      if (linkedIds.isEmpty) return;

      final correctAttempts = await (_db.select(_db.exerciseAttempts)
            ..where((t) =>
                t.exerciseId.isIn(linkedIds) &
                t.isCorrect.equals(true) &
                t.scope.equals('exercises')))
          .get();

      final distinctCorrectIds =
          correctAttempts.map((a) => a.exerciseId).toSet();
      final progress = ((distinctCorrectIds.length / linkedIds.length) * 100)
          .round()
          .clamp(0, 100);

      await (_db.update(_db.grammarTopics)..where((t) => t.id.equals(topic.id)))
          .write(
        GrammarTopicsCompanion(
          progress: Value(progress),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await _refreshGrammarCompletionStats();
    }
  }
}

