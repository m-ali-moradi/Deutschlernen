import 'dart:math';

import 'package:deutschmate_mobile/core/database/app_database.dart';

class ExerciseQueueBuckets {
  const ExerciseQueueBuckets({
    required this.focus,
    required this.pending,
    required this.unseen,
    required this.completed,
  });

  final List<Exercise> focus;
  final List<Exercise> pending;
  final List<Exercise> unseen;
  final List<Exercise> completed;

  bool get hasUnanswered =>
      focus.isNotEmpty || pending.isNotEmpty || unseen.isNotEmpty;

  List<Exercise> get unansweredOrdered => [
        ...focus,
        ...pending,
        ...unseen,
      ];

  List<Exercise> get allOrdered => [
        ...focus,
        ...pending,
        ...unseen,
        ...completed,
      ];
}

ExerciseQueueBuckets buildExerciseQueueBuckets({
  required List<Exercise> exercises,
  required Set<String> completedIds,
  required Set<String> incorrectIds,
  required Set<String> focusIds,
  Random? random,
}) {
  final focus = <Exercise>[];
  final pending = <Exercise>[];
  final unseen = <Exercise>[];
  final completed = <Exercise>[];

  for (final exercise in exercises) {
    if (focusIds.contains(exercise.id)) {
      focus.add(exercise);
      continue;
    }

    if (completedIds.contains(exercise.id)) {
      completed.add(exercise);
      continue;
    }

    if (incorrectIds.contains(exercise.id)) {
      pending.add(exercise);
      continue;
    }

    unseen.add(exercise);
  }

  final rng = random ?? Random();
  focus.shuffle(rng);
  pending.shuffle(rng);
  unseen.shuffle(rng);
  completed.shuffle(rng);

  return ExerciseQueueBuckets(
    focus: focus,
    pending: pending,
    unseen: unseen,
    completed: completed,
  );
}



