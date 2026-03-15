import 'seed_data.dart';
import 'seed_data_expansion.dart';

const Set<String> _allowedDifficulties = {'easy', 'medium', 'hard'};
const Set<String> _allowedExerciseTypes = {
  'multiple-choice',
  'matching',
  'sentence-order',
  'fill-in-blank',
  'fill-blank',
};

List<String> validateSeedData({
  List<Map<String, Object>>? vocabulary,
  List<Map<String, Object>>? exercises,
}) {
  final allVocabulary =
      vocabulary ?? [...vocabularySeed, ...vocabularySeedExpansion];
  final allExercises = exercises ?? [...exerciseSeed, ...exerciseSeedExpansion];

  final errors = <String>[];

  errors.addAll(_validateVocabulary(allVocabulary));
  errors.addAll(_validateExercises(allExercises));

  return errors;
}

void assertSeedDataIsValid() {
  final errors = validateSeedData();
  if (errors.isEmpty) {
    return;
  }

  final message = errors.map((e) => '- $e').join('\n');
  throw StateError('Seed data is invalid:\n$message');
}

List<String> _validateVocabulary(List<Map<String, Object>> rows) {
  final errors = <String>[];
  final ids = <String>{};

  for (final row in rows) {
    final id = row['id'];
    if (id is! String || id.isEmpty) {
      errors.add('Vocabulary row has missing/invalid id: $row');
      continue;
    }

    if (!ids.add(id)) {
      errors.add('Duplicate vocabulary id: $id');
    }

    for (final key in const [
      'german',
      'phonetic',
      'english',
      'dari',
      'category',
      'tag',
      'example',
      'context',
      'contextDari',
      'difficulty',
    ]) {
      final value = row[key];
      if (value is! String || value.trim().isEmpty) {
        errors.add('Vocabulary $id has invalid field "$key"');
      }
    }

    final difficulty = row['difficulty'];
    if (difficulty is String && !_allowedDifficulties.contains(difficulty)) {
      errors.add('Vocabulary $id has unsupported difficulty "$difficulty"');
    }

    for (final key in const ['isFavorite', 'isDifficult']) {
      if (row[key] is! bool) {
        errors.add('Vocabulary $id has invalid boolean field "$key"');
      }
    }
  }

  return errors;
}

List<String> _validateExercises(List<Map<String, Object>> rows) {
  final errors = <String>[];
  final ids = <String>{};

  for (final row in rows) {
    final id = row['id'];
    if (id is! String || id.isEmpty) {
      errors.add('Exercise row has missing/invalid id: $row');
      continue;
    }

    if (!ids.add(id)) {
      errors.add('Duplicate exercise id: $id');
    }

    final type = row['type'];
    if (type is! String || !_allowedExerciseTypes.contains(type)) {
      errors.add('Exercise $id has unsupported type "$type"');
    }

    for (final key in const ['question', 'topic', 'level']) {
      final value = row[key];
      if (value is! String || value.trim().isEmpty) {
        errors.add('Exercise $id has invalid field "$key"');
      }
    }

    final options = row['options'];
    if (options is! List ||
        options.length < 2 ||
        options.any((e) => e is! String || e.trim().isEmpty)) {
      errors.add('Exercise $id has invalid options');
      continue;
    }

    final answer = row['correctAnswer'];
    if (answer is! int || answer < 0 || answer >= options.length) {
      errors.add('Exercise $id has invalid correctAnswer index: $answer');
    }
  }

  return errors;
}
