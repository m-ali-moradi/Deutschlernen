import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [
  Exercises,
  ExerciseAttempts,
])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  /// Clears all existing exercises (use before re-seeding).
  Future<void> clearAllExercises() => delete(exercises).go();

  /// Inserts all exercises in a batch.
  Future<void> insertAllExercises(List<ExercisesCompanion> comps) async {
    await batch((b) {
      b.insertAll(exercises, comps, mode: InsertMode.insertOrReplace);
    });
  }
}
