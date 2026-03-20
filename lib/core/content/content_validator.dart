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
      'a1_application_career':
          'assets/content/vocabulary/A1/01_application_career.json',
      'a1_company_structure':
          'assets/content/vocabulary/A1/02_company_structure.json',
      'a1_contracts': 'assets/content/vocabulary/A1/03_contracts.json',
      'a1_contracts_law': 'assets/content/vocabulary/A1/04_contracts_law.json',
      'a1_education': 'assets/content/vocabulary/A1/05_education.json',
      'a1_education_school':
          'assets/content/vocabulary/A1/06_education_school.json',
      'a1_email_correspondence':
          'assets/content/vocabulary/A1/07_email_correspondence.json',
      'a1_everyday_german':
          'assets/content/vocabulary/A1/08_everyday_german.json',
      'a1_finance': 'assets/content/vocabulary/A1/09_finance.json',
      'a1_it_technology': 'assets/content/vocabulary/A1/10_it_technology.json',
      'a1_job_search_application':
          'assets/content/vocabulary/A1/11_job_search_application.json',
      'a1_marketing': 'assets/content/vocabulary/A1/12_marketing.json',
      'a1_marketing_sales':
          'assets/content/vocabulary/A1/13_marketing_sales.json',
      'a1_meetings': 'assets/content/vocabulary/A1/14_meetings.json',
      'a1_meetings_presentations':
          'assets/content/vocabulary/A1/15_meetings_presentations.json',
      'a1_office_administration':
          'assets/content/vocabulary/A1/16_office_administration.json',
      'a1_office_communication':
          'assets/content/vocabulary/A1/17_office_communication.json',
      'a1_office_environment':
          'assets/content/vocabulary/A1/18_office_environment.json',
      'a1_phone_communication':
          'assets/content/vocabulary/A1/19_phone_communication.json',
      'a1_professions': 'assets/content/vocabulary/A1/20_professions.json',
      'a1_recruiting': 'assets/content/vocabulary/A1/21_recruiting.json',
      'a1_training_internship':
          'assets/content/vocabulary/A1/22_training_internship.json',
      'a1_visa_authorities':
          'assets/content/vocabulary/A1/23_visa_authorities.json',
      'a1_work_tasks': 'assets/content/vocabulary/A1/24_work_tasks.json',
      'a2_application_career':
          'assets/content/vocabulary/A2/01_application_career.json',
      'a2_finance': 'assets/content/vocabulary/A2/02_finance.json',
      'a2_it_technology': 'assets/content/vocabulary/A2/03_it_technology.json',
      'a2_marketing': 'assets/content/vocabulary/A2/04_marketing.json',
      'a2_contracts': 'assets/content/vocabulary/A2/05_contracts.json',
      'a2_meetings': 'assets/content/vocabulary/A2/06_meetings.json',
      'a2_education': 'assets/content/vocabulary/A2/07_education.json',
      'a2_office_communication':
          'assets/content/vocabulary/A2/08_office_communication.json',
      'a2_company_structure':
          'assets/content/vocabulary/A2/09_company_structure.json',
      'a2_professions': 'assets/content/vocabulary/A2/10_professions.json',
      'a2_recruiting': 'assets/content/vocabulary/A2/11_recruiting.json',
      'a2_office_environment':
          'assets/content/vocabulary/A2/12_office_environment.json',
      'a2_work_tasks': 'assets/content/vocabulary/A2/13_work_tasks.json',
      'a2_office_administration':
          'assets/content/vocabulary/A2/14_office_administration.json',
      'a2_email_correspondence':
          'assets/content/vocabulary/A2/15_email_correspondence.json',
      'a2_meetings_presentations':
          'assets/content/vocabulary/A2/16_meetings_presentations.json',
      'a2_everyday_german':
          'assets/content/vocabulary/A2/17_everyday_german.json',
      'a2_phone_communication':
          'assets/content/vocabulary/A2/18_phone_communication.json',
      'a2_contracts_law': 'assets/content/vocabulary/A2/19_contracts_law.json',
      'a2_marketing_sales':
          'assets/content/vocabulary/A2/20_marketing_sales.json',
      'a2_education_school':
          'assets/content/vocabulary/A2/21_education_school.json',
      'a2_visa_authorities':
          'assets/content/vocabulary/A2/22_visa_authorities.json',
      'a2_training_internship':
          'assets/content/vocabulary/A2/23_training_internship.json',
      'a2_job_search_application':
          'assets/content/vocabulary/A2/24_job_search_application.json',
      'b1_application_career':
          'assets/content/vocabulary/B1/01_application_career.json',
      'b1_finance': 'assets/content/vocabulary/B1/02_finance.json',
      'b1_it_technology': 'assets/content/vocabulary/B1/03_it_technology.json',
      'b1_contracts': 'assets/content/vocabulary/B1/04_contracts.json',
      'b1_marketing': 'assets/content/vocabulary/B1/05_marketing.json',
      'b1_company_structure':
          'assets/content/vocabulary/B1/06_company_structure.json',
      'b1_professions': 'assets/content/vocabulary/B1/07_professions.json',
      'b1_recruiting': 'assets/content/vocabulary/B1/08_recruiting.json',
      'b1_office_administration':
          'assets/content/vocabulary/B1/09_office_administration.json',
      'b1_email_correspondence':
          'assets/content/vocabulary/B1/10_email_correspondence.json',
      'b1_meetings_presentations':
          'assets/content/vocabulary/B1/11_meetings_presentations.json',
      'b1_everyday_german':
          'assets/content/vocabulary/B1/12_everyday_german.json',
      'b1_phone_communication':
          'assets/content/vocabulary/B1/13_phone_communication.json',
      'b1_contracts_law': 'assets/content/vocabulary/B1/14_contracts_law.json',
      'b1_marketing_sales':
          'assets/content/vocabulary/B1/15_marketing_sales.json',
      'b1_education_school':
          'assets/content/vocabulary/B1/16_education_school.json',
      'b1_visa_authorities':
          'assets/content/vocabulary/B1/17_visa_authorities.json',
      'b1_training_internship':
          'assets/content/vocabulary/B1/18_training_internship.json',
      'b1_job_search_application':
          'assets/content/vocabulary/B1/19_job_search_application.json',
      'b2': 'assets/content/vocabulary/B2/b2.json',
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
      'sentence-order',
      'matching',
      'true-false',
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
