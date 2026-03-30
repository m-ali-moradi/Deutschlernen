import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/content/sync/sync_service.dart';

/// Currently selected level filter for exercises.
final exerciseLevelProvider = StateProvider<String>((ref) => 'Alle');

/// Currently selected exercise type filter.
final exerciseTypeProvider = StateProvider<String>((ref) => 'all');

/// Currently selected topic filter (e.g., from grammar details).
final exerciseTopicProvider = StateProvider<String?>((ref) => null);

/// Currently selected category filter (if any).
final exerciseCategoryProvider = StateProvider<String?>((ref) => null);

/// Filtered list of exercises based on selected filters.
final filteredExercisesProvider = Provider<List<SyncEntry<Exercise>>>((ref) {
  final allExercises = ref.watch(hybridExercisesProvider).valueOrNull ?? [];
  final level = ref.watch(exerciseLevelProvider);
  final type = ref.watch(exerciseTypeProvider);
  final topic = ref.watch(exerciseTopicProvider);
  final category = ref.watch(exerciseCategoryProvider);

  return allExercises.where((e) {
    final eLevel = e.localData?.level ?? e.cloudMetadata?['level'] ?? 'A1';
    final eType = e.localData?.type ?? e.cloudMetadata?['type'] ?? '';
    final eTopic = e.localData?.topic ?? e.cloudMetadata?['topic'] ?? '';
    final eCategory = e.cloudMetadata?['category'] ?? '';

    final matchesLevel = level == 'Alle' || eLevel == level;
    final matchesType = type == 'all' || eType == type;
    final matchesTopic = topic == null || _matchesTopic(eTopic, topic);

    // If we have a specific topic, we are lenient about the category since local exercises
    // currently lack category metadata.
    final matchesCategory = category == null ||
        eCategory == category ||
        (topic != null && eCategory.isEmpty);

    return matchesLevel && matchesType && matchesTopic && matchesCategory;
  }).toList();
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
