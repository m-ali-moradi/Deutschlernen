import 'package:flutter_test/flutter_test.dart';

import 'package:deutschlernen_mobile/core/database/seed_data.dart';
import 'package:deutschlernen_mobile/core/database/seed_data_expansion.dart';
import 'package:deutschlernen_mobile/core/database/seed_data_validation.dart';

void main() {
  test('seed data validates successfully', () {
    final errors = validateSeedData();
    expect(errors, isEmpty);
  });

  test('expanded data bank has larger baseline volume', () {
    final totalVocabulary =
        vocabularySeed.length + vocabularySeedExpansion.length;
    final totalExercises = exerciseSeed.length + exerciseSeedExpansion.length;

    expect(totalVocabulary, greaterThanOrEqualTo(70));
    expect(totalExercises, greaterThanOrEqualTo(90));
  });

  test('expanded exercise bank covers all supported exercise types', () {
    final allExercises = [...exerciseSeed, ...exerciseSeedExpansion];
    final types = allExercises
        .map((exercise) => exercise['type'])
        .whereType<String>()
        .toSet();

    expect(types, contains('multiple-choice'));
    expect(types, contains('matching'));
    expect(types, contains('fill-in-blank'));
    expect(types, contains('sentence-order'));
  });
}
