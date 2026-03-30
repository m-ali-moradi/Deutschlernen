import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';

/// Currently selected level filter for exercises.
final exerciseLevelProvider = StateProvider<String>((ref) => 'Alle');

/// Currently selected exercise type filter.
final exerciseTypeProvider = StateProvider<String>((ref) => 'all');

/// Currently selected topic filter (e.g., from grammar details).
final exerciseTopicProvider = StateProvider<String?>((ref) => null);

/// Currently selected category filter (if any).
final exerciseCategoryProvider = StateProvider<String?>((ref) => null);

/// Local exercises loaded from the database.
final localExercisesProvider = Provider<List<Exercise>>((ref) {
  return ref.watch(exercisesStreamProvider).valueOrNull ?? const <Exercise>[];
});

class ExerciseTypeProgress {
  const ExerciseTypeProgress({
    required this.completed,
    required this.total,
  });

  final int completed;
  final int total;

  double get fraction {
    if (total <= 0) return 0;
    return (completed / total).clamp(0, 1);
  }
}

/// Filtered list of exercises based on selected filters.
final filteredExercisesProvider = Provider<List<Exercise>>((ref) {
  final allExercises = ref.watch(localExercisesProvider);
  final level = ref.watch(exerciseLevelProvider);
  final type = ref.watch(exerciseTypeProvider);
  final topic = ref.watch(exerciseTopicProvider);

  return allExercises.where((e) {
    final eLevel = e.level;
    final eType = e.type;
    final eTopic = e.topic;

    final matchesLevel = level == 'Alle' || eLevel == level;
    final matchesType = type == 'all' || eType == type;
    final matchesTopic = topic == null || _matchesTopic(eTopic, topic);

    return matchesLevel && matchesType && matchesTopic;
  }).toList();
});

final exerciseTypeProgressProvider =
    Provider<Map<String, ExerciseTypeProgress>>((ref) {
  final filteredExercises = ref.watch(filteredExercisesProvider);
  final attempts = ref.watch(exerciseAttemptsStreamProvider).valueOrNull ?? [];

  final allById = <String, String>{};
  for (final entry in filteredExercises) {
    allById[entry.id] = _normalizeExerciseType(entry.type);
  }

  final correctIds = attempts
      .where((attempt) =>
          attempt.scope == 'exercises' &&
          attempt.isCorrect &&
          allById.containsKey(attempt.exerciseId))
      .map((attempt) => attempt.exerciseId)
      .toSet();

  var allTotal = 0;
  var allCompleted = 0;

  final typeTotals = <String, int>{};
  final typeCompleted = <String, int>{};

  for (final entry in filteredExercises) {
    final type = allById[entry.id] ?? '';
    if (type.isEmpty) continue;

    allTotal += 1;
    typeTotals[type] = (typeTotals[type] ?? 0) + 1;

    if (correctIds.contains(entry.id)) {
      allCompleted += 1;
      typeCompleted[type] = (typeCompleted[type] ?? 0) + 1;
    }
  }

  return {
    'all': ExerciseTypeProgress(completed: allCompleted, total: allTotal),
    for (final type in typeTotals.keys)
      type: ExerciseTypeProgress(
        completed: typeCompleted[type] ?? 0,
        total: typeTotals[type] ?? 0,
      ),
  };
});

bool _matchesTopic(String exerciseTopic, String selectedTopic) {
  final e = _normalizeTopic(exerciseTopic);
  final t = _normalizeTopic(selectedTopic);
  if (e.isEmpty || t.isEmpty) return false;

  return e == t || e.contains(t) || t.contains(e);
}

String _normalizeTopic(String value) {
  return value
      .toLowerCase()
      .trim()
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('ß', 'ss')
      .replaceAll(RegExp(r'\s+'), ' ');
}

String _normalizeExerciseType(String type) {
  if (type == 'fill-in-blank') {
    return 'fill-blank';
  }
  return type;
}
