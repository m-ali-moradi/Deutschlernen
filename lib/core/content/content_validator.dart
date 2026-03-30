import 'dart:async';

import 'package:flutter/foundation.dart';

import 'content_loader.dart';

/// This class checks if the JSON content files have the correct format.
///
/// It runs during development to catch errors in the data early.
class ContentValidator {
  /// This function starts the validation process in the background.
  static void validate() {
    unawaited(_validate());
  }

  static Future<void> _validate() async {
    if (!kDebugMode) {
      return;
    }

    final vocabularyFiles = {
      'a1_greetings': 'assets/content/vocabulary/A1/01_greetings.json',
      'a1_numbers': 'assets/content/vocabulary/A1/02_numbers.json',
      'a1_time': 'assets/content/vocabulary/A1/03_time.json',
      'a1_days': 'assets/content/vocabulary/A1/04_days.json',
      'a1_family': 'assets/content/vocabulary/A1/05_family.json',
      'a1_home': 'assets/content/vocabulary/A1/06_home.json',
      'a1_food': 'assets/content/vocabulary/A1/07_food.json',
      'a1_shopping': 'assets/content/vocabulary/A1/08_shopping.json',
      'a1_name_origin': 'assets/content/vocabulary/A1/09_name_origin.json',
      'a1_address_phone': 'assets/content/vocabulary/A1/10_address_phone.json',
      'a1_age_nationality':
          'assets/content/vocabulary/A1/11_age_nationality.json',
      'a1_documents': 'assets/content/vocabulary/A1/12_documents.json',
      'a1_train_bus': 'assets/content/vocabulary/A1/13_train_bus.json',
      'a1_airport': 'assets/content/vocabulary/A1/14_airport.json',
      'a1_ticket_booking':
          'assets/content/vocabulary/A1/15_ticket_booking.json',
      'a1_hotel': 'assets/content/vocabulary/A1/16_hotel.json',
      'a1_directions': 'assets/content/vocabulary/A1/17_directions.json',
      'a1_rooms': 'assets/content/vocabulary/A1/18_rooms.json',
      'a1_furniture': 'assets/content/vocabulary/A1/19_furniture.json',
      'a1_rent_cleaning': 'assets/content/vocabulary/A1/20_rent_cleaning.json',
      'a1_repairs': 'assets/content/vocabulary/A1/21_repairs.json',
      'a1_body_parts': 'assets/content/vocabulary/A1/22_body_parts.json',
      'a1_symptoms': 'assets/content/vocabulary/A1/23_symptoms.json',
      'a1_doctor_pharmacy':
          'assets/content/vocabulary/A1/24_doctor_pharmacy.json',
      'a1_emergency': 'assets/content/vocabulary/A1/25_emergency.json',
      'a2_school_basics': 'assets/content/vocabulary/A2/01_school_basics.json',
      'a2_company': 'assets/content/vocabulary/A2/02_company.json',
      'a2_office_tasks': 'assets/content/vocabulary/A2/03_office_tasks.json',
      'b1_subjects': 'assets/content/vocabulary/B1/01_subjects.json',
      'b1_exams_homework':
          'assets/content/vocabulary/B1/02_exams_homework.json',
      'b1_meetings': 'assets/content/vocabulary/B1/03_meetings.json',
      'b1_contracts': 'assets/content/vocabulary/B1/04_contracts.json',
      'b1_salary_projects':
          'assets/content/vocabulary/B1/05_salary_projects.json',
      'b1_application': 'assets/content/vocabulary/B1/06_application.json',
      'b1_finance': 'assets/content/vocabulary/B1/07_finance.json',
      'b1_marketing': 'assets/content/vocabulary/B1/08_marketing.json',
      'b1_hr': 'assets/content/vocabulary/B1/09_hr.json',
      'b2_university_study':
          'assets/content/vocabulary/B2/01_university_study.json',
      'b2_exams_academic':
          'assets/content/vocabulary/B2/02_exams_academic.json',
      'misc': 'assets/content/vocabulary/misc.json',
    };
    final exerciseFiles = ['a1', 'a2', 'b1', 'b2', 'c1'];

    final vocabularyByFile = <String, List<Map<String, dynamic>>>{};
    for (final entry in vocabularyFiles.entries) {
      vocabularyByFile[entry.key] = await ContentLoader.loadList(entry.value);
    }

    final exercisesByFile = <String, List<Map<String, dynamic>>>{};
    for (final level in exerciseFiles) {
      exercisesByFile[level] =
          await ContentLoader.loadList('assets/content/exercises/$level.json');
    }

    _validateVocabulary(vocabularyByFile);
    _validateExercises(exercisesByFile);
    _validateDuplicateIds(vocabularyByFile, contentType: 'vocabulary');
    _validateDuplicateIds(exercisesByFile, contentType: 'exercise');
  }

  /// This function verifies that all vocabulary entries have the required fields.
  static void _validateVocabulary(
      Map<String, List<Map<String, dynamic>>> byFile) {
    const requiredFields = {
      'id',
      'german',
      'english',
      'category',
      'tag',
      'example',
      'difficulty',
      'isFavorite',
    };

    const validDifficulties = {'easy', 'medium', 'hard', 'difficult', ''};

    byFile.forEach((file, entries) {
      for (final entry in entries) {
        for (final field in requiredFields) {
          if (!entry.containsKey(field)) {
            throw StateError(
                'Vocabulary entry missing $field in $file.json: ${entry['id']}');
          }
        }

        final difficulty = (entry['difficulty'] ?? '').toString().toLowerCase();
        if (!validDifficulties.contains(difficulty)) {
          throw StateError(
              'Invalid vocabulary difficulty "$difficulty" in $file.json: ${entry['id']}');
        }
      }
    });
  }

  /// This function checks if every exercise has a valid type and options.
  static void _validateExercises(
      Map<String, List<Map<String, dynamic>>> byFile) {
    const validTypes = {
      'multiple-choice',
      'fill-in-blank',
      'fill-blank',
      'sentence-order',
      'matching',
      'true-false',
      'business-dialog',
    };

    byFile.forEach((file, entries) {
      for (final entry in entries) {
        final type = (entry['type'] ?? '').toString();
        if (!validTypes.contains(type)) {
          throw StateError(
              'Invalid exercise type "$type" in $file.json: ${entry['id']}');
        }

        final options = (entry['options'] is List)
            ? List<dynamic>.from(entry['options'] as List)
            : const <dynamic>[];
        if (options.isEmpty) {
          throw StateError(
              'Exercise options empty in $file.json: ${entry['id']}');
        }

        final correct = entry['correctAnswer'];
        if (correct is! int || correct < 0 || correct >= options.length) {
          throw StateError(
              'Exercise correctAnswer out of bounds in $file.json: ${entry['id']}');
        }
      }
    });
  }

  /// This function ensures that no two content entries have the same ID.
  static void _validateDuplicateIds(
    Map<String, List<Map<String, dynamic>>> byFile, {
    required String contentType,
  }) {
    final seen = <String, String>{};

    byFile.forEach((file, entries) {
      for (final entry in entries) {
        final id = (entry['id'] ?? '').toString();
        if (id.isEmpty) {
          throw StateError('Empty id in $contentType/$file.json');
        }
        final existing = seen[id];
        if (existing != null) {
          throw StateError(
              'Duplicate id "$id" in $contentType files: $existing.json and $file.json');
        }
        seen[id] = file;
      }
    });
  }
}
