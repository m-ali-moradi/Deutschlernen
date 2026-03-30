import 'dart:async';

import 'package:flutter/foundation.dart';

import 'content_assets.dart';
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

    final categoryRows = await ContentLoader.loadList(
      ContentAssets.vocabularyCategories,
    );
    final groupRows = await ContentLoader.loadList(ContentAssets.vocabularyGroups);

    final validGroups = groupRows
        .map((row) => (row['id'] ?? '').toString())
        .where((id) => id.isNotEmpty)
        .toSet();
    final categoryToGroup = <String, String>{
      for (final row in categoryRows)
        (row['id'] ?? '').toString(): (row['groupId'] ?? '').toString(),
    };

    final vocabularyByFile = <String, List<Map<String, dynamic>>>{};
    for (final assetPath in ContentAssets.vocabulary) {
      vocabularyByFile[assetPath] = await ContentLoader.loadList(assetPath);
    }

    final exercisesByFile = <String, List<Map<String, dynamic>>>{};
    for (final exerciseFile in ContentAssets.exercises) {
      exercisesByFile[exerciseFile] =
          await ContentLoader.loadExercises([exerciseFile]);
    }

    _validateVocabulary(vocabularyByFile, categoryToGroup, validGroups);
    _validateVocabularyGermanDuplicates(vocabularyByFile);
    _warnVocabularyEnglishDuplicates(vocabularyByFile);
    _warnVocabularyOverlap(vocabularyByFile);
    _validateExercises(exercisesByFile);
    _validateDuplicateIds(vocabularyByFile, contentType: 'vocabulary');
    _validateDuplicateIds(exercisesByFile, contentType: 'exercise');
  }

  /// This function verifies that all vocabulary entries have the required fields.
  static void _validateVocabulary(
    Map<String, List<Map<String, dynamic>>> byFile,
    Map<String, String> categoryToGroup,
    Set<String> validGroups,
  ) {
    const requiredFields = {
      'id',
      'german',
      'english',
      'category',
      'group',
      'tag',
      'example',
      'difficulty',
      'isFavorite',
    };

    const validDifficulties = {'easy', 'medium', 'hard', 'difficult', ''};

    byFile.forEach((assetPath, entries) {
      final expectedLevel = ContentLoader.inferVocabularyLevel(assetPath);
      final fileLabel = _labelForAsset(assetPath);
      final fileCategories = <String>{};
      final fileGroups = <String>{};
      final fileTags = <String>{};

      for (final entry in entries) {
        for (final field in requiredFields) {
          if (!entry.containsKey(field)) {
            throw StateError(
              'Vocabulary entry missing $field in $fileLabel: ${entry['id']}',
            );
          }
        }

        final difficulty = (entry['difficulty'] ?? '').toString().toLowerCase();
        if (!validDifficulties.contains(difficulty)) {
          throw StateError(
            'Invalid vocabulary difficulty "$difficulty" in $fileLabel: ${entry['id']}',
          );
        }

        final german = (entry['german'] ?? '').toString().trim();
        final category = (entry['category'] ?? '').toString().trim();
        final group = (entry['group'] ?? '').toString().trim();
        final tag = (entry['tag'] ?? '').toString().trim();
        final explicitLevel = (entry['level'] ?? '').toString().trim();

        fileCategories.add(category);
        fileGroups.add(group);
        fileTags.add(tag);

        if (!categoryToGroup.containsKey(category)) {
          throw StateError(
            'Unknown vocabulary category "$category" in $fileLabel: ${entry['id']}',
          );
        }

        if (!validGroups.contains(group)) {
          throw StateError(
            'Unknown vocabulary group "$group" in $fileLabel: ${entry['id']}',
          );
        }

        final expectedGroup = categoryToGroup[category];
        if (expectedGroup != group) {
          throw StateError(
            'Category/group mismatch in $fileLabel: ${entry['id']} has category "$category" but group "$group"; expected "$expectedGroup".',
          );
        }

        if (explicitLevel.isNotEmpty && explicitLevel != expectedLevel) {
          throw StateError(
            'Vocabulary level mismatch in $fileLabel: ${entry['id']} declares "$explicitLevel" but file is under $expectedLevel.',
          );
        }

        if (german.contains(' / ')) {
          throw StateError(
            'Canonical vocabulary entry should not use slash alternatives in $fileLabel: ${entry['id']} => $german',
          );
        }
      }

      if (entries.isNotEmpty && fileCategories.length != 1) {
        throw StateError(
          'Vocabulary file $fileLabel mixes multiple categories: ${fileCategories.join(', ')}',
        );
      }

      if (entries.isNotEmpty && fileGroups.length != 1) {
        throw StateError(
          'Vocabulary file $fileLabel mixes multiple groups: ${fileGroups.join(', ')}',
        );
      }

      if (entries.isNotEmpty && fileTags.length != 1) {
        debugPrint(
          'Vocabulary warning: $fileLabel uses multiple tags: ${fileTags.join(', ')}',
        );
      }
    });
  }

  static void _validateVocabularyGermanDuplicates(
    Map<String, List<Map<String, dynamic>>> byFile,
  ) {
    final seen = <String, String>{};

    for (final entry in byFile.entries) {
      final assetPath = entry.key;
      final fileLabel = _labelForAsset(assetPath);
      for (final row in entry.value) {
        final category = (row['category'] ?? '').toString().trim();
        final german = (row['german'] ?? '').toString().trim();
        if (category.isEmpty || german.isEmpty) {
          continue;
        }

        final key = '$category::$german';
        final existing = seen[key];
        if (existing != null) {
          throw StateError(
            'Duplicate German term "$german" found in category "$category" across $existing and $fileLabel.',
          );
        }
        seen[key] = fileLabel;
      }
    }
  }

  static void _warnVocabularyEnglishDuplicates(
    Map<String, List<Map<String, dynamic>>> byFile,
  ) {
    final rows = <Map<String, String>>[];
    byFile.forEach((assetPath, entries) {
      final fileLabel = _labelForAsset(assetPath);
      for (final row in entries) {
        rows.add({
          'file': fileLabel,
          'category': (row['category'] ?? '').toString(),
          'english': (row['english'] ?? '').toString().trim(),
          'german': (row['german'] ?? '').toString().trim(),
        });
      }
    });

    final grouped = <String, List<Map<String, String>>>{};
    for (final row in rows) {
      final category = row['category'] ?? '';
      final english = row['english'] ?? '';
      if (category.isEmpty || english.isEmpty) {
        continue;
      }
      grouped.putIfAbsent('$category::$english', () => []).add(row);
    }

    for (final entry in grouped.entries) {
      if (entry.value.length < 2) {
        continue;
      }
      final sample = entry.value
          .map((row) => row['german'])
          .whereType<String>()
          .join(' || ');
      debugPrint(
        'Vocabulary warning: same English gloss inside one category => ${entry.key} :: $sample',
      );
    }
  }

  static void _warnVocabularyOverlap(
    Map<String, List<Map<String, dynamic>>> byFile,
  ) {
    final perCategory = <String, Set<String>>{};
    final categoryGroup = <String, String>{};

    byFile.forEach((assetPath, entries) {
      if (entries.isEmpty) {
        return;
      }
      final category = (entries.first['category'] ?? '').toString().trim();
      final group = (entries.first['group'] ?? '').toString().trim();
      if (category.isEmpty || group.isEmpty) {
        return;
      }
      categoryGroup[category] = group;
      perCategory[category] = entries
          .map((row) => (row['german'] ?? '').toString().trim())
          .where((value) => value.isNotEmpty)
          .toSet();
    });

    final categories = perCategory.keys.toList()..sort();
    for (var i = 0; i < categories.length; i++) {
      for (var j = i + 1; j < categories.length; j++) {
        final categoryA = categories[i];
        final categoryB = categories[j];
        if (categoryGroup[categoryA] != categoryGroup[categoryB]) {
          continue;
        }

        final shared = perCategory[categoryA]!
            .intersection(perCategory[categoryB]!)
            .toList()
          ..sort();
        if (shared.length >= 6) {
          final preview = shared.take(8).join(', ');
          debugPrint(
            'Vocabulary overlap warning: $categoryA <> $categoryB share ${shared.length} terms :: $preview',
          );
        }
      }
    }
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
    };

    byFile.forEach((assetPath, entries) {
      final fileLabel = _labelForAsset(assetPath);
      for (final entry in entries) {
        final type = (entry['type'] ?? '').toString();
        if (!validTypes.contains(type)) {
          throw StateError(
            'Invalid exercise type "$type" in $fileLabel: ${entry['id']}',
          );
        }

        final options = (entry['options'] is List)
            ? List<dynamic>.from(entry['options'] as List)
            : const <dynamic>[];
        if (options.isEmpty) {
          throw StateError(
            'Exercise options empty in $fileLabel: ${entry['id']}',
          );
        }

        final correct = entry['correctAnswer'];
        if (correct is! int || correct < 0 || correct >= options.length) {
          throw StateError(
            'Exercise correctAnswer out of bounds in $fileLabel: ${entry['id']}',
          );
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

    byFile.forEach((assetPath, entries) {
      final fileLabel = _labelForAsset(assetPath);
      for (final entry in entries) {
        final id = (entry['id'] ?? '').toString();
        if (id.isEmpty) {
          throw StateError('Empty id in $contentType/$fileLabel');
        }
        final existing = seen[id];
        if (existing != null) {
          throw StateError(
            'Duplicate id "$id" in $contentType files: $existing and $fileLabel',
          );
        }
        seen[id] = fileLabel;
      }
    });
  }

  static String _labelForAsset(String assetPath) => assetPath.split('/').last;
}
