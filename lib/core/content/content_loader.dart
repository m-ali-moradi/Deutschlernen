import 'dart:convert';

import 'package:flutter/services.dart';

/// A utility class responsible for loading and parsing JSON data from the application's assets.
///
/// This serves as the primary data ingestion layer for offline content like
/// vocabulary, grammar lessons, and exercises.
class ContentLoader {
  static const _knownVocabularyLevels = {'A1', 'A2', 'B1', 'B2', 'C1'};

  /// Loads a list of objects from a single JSON asset file.
  ///
  /// Supports both a top-level JSON array and a single JSON object (which is
  /// automatically wrapped in a list).
  ///
  /// Throws a [FormatException] if the asset does not contain a valid JSON
  /// object or array.
  static Future<List<Map<String, dynamic>>> loadList(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);

    if (decoded is List) {
      return decoded
          .map((entry) => Map<String, dynamic>.from(entry as Map))
          .toList();
    }

    if (decoded is Map) {
      return [Map<String, dynamic>.from(decoded)];
    }

    throw FormatException(
      'Expected a JSON object or array in $assetPath, got ${decoded.runtimeType}.',
    );
  }

  /// Aggregates content from a collection of asset paths.
  ///
  /// Iterates through [assetPaths] and combines all entries into a single flat list.
  static Future<List<Map<String, dynamic>>> loadMany(
    Iterable<String> assetPaths,
  ) async {
    final results = <Map<String, dynamic>>[];
    for (final assetPath in assetPaths) {
      final data = await loadList(assetPath);
      results.addAll(data);
    }
    return results;
  }

  /// Loads vocabulary entries and injects the CEFR level based on the asset path.
  static Future<List<Map<String, dynamic>>> loadVocabulary(
    Iterable<String> assetPaths,
  ) async {
    final results = <Map<String, dynamic>>[];
    for (final assetPath in assetPaths) {
      final level = inferVocabularyLevel(assetPath);
      final data = await loadList(assetPath);
      for (final entry in data) {
        final enriched = Map<String, dynamic>.from(entry);
        enriched['level'] = (entry['level'] ?? level).toString();
        enriched['_assetPath'] = assetPath;
        results.add(enriched);
      }
    }
    return results;
  }

  /// Infers the CEFR level for a vocabulary asset based on its folder path.
  static String inferVocabularyLevel(String assetPath) {
    final parts = assetPath.split('/');
    for (final part in parts) {
      if (_knownVocabularyLevels.contains(part)) {
        return part;
      }
    }
    return 'A1';
  }

  /// Loads a single JSON object as a Map.
  ///
  /// Primarily used for configuration files or individual content pieces.
  static Future<Map<String, dynamic>> loadMap(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return Map<String, dynamic>.from(jsonDecode(raw));
  }

  /// Batch loads content for multiple levels in a specific subfolder.
  ///
  /// Automatically constructs the path pattern `assets/content/[folder]/[level].json`.
  /// Silently ignores missing or invalid files to prevent entire app failures during seeding.
  static Future<List<Map<String, dynamic>>> loadAllLevels(
    String folder,
    List<String> levels,
  ) async {
    final results = <Map<String, dynamic>>[];
    for (final level in levels) {
      try {
        final data = await loadList('assets/content/$folder/$level.json');
        results.addAll(data);
      } catch (e) {
        // Skip missing or invalid files
      }
    }
    return results;
  }

  /// Loads exercises from the modular topic-based JSON files.
  ///
  /// Each file has the structure:
  /// ```json
  /// { "topic": "...", "level": "...", "exercises": [ { id, type, question, ... }, ... ] }
  /// ```
  ///
  /// This method flattens the nested exercises and injects the wrapper's
  /// `topic` and `level` into each individual exercise map.
  static Future<List<Map<String, dynamic>>> loadExercises(
    Iterable<String> assetPaths,
  ) async {
    final results = <Map<String, dynamic>>[];
    for (final assetPath in assetPaths) {
      try {
        final raw = await rootBundle.loadString(assetPath);
        final decoded = jsonDecode(raw);

        if (decoded is Map) {
          final topic = (decoded['topic'] ?? '').toString();
          final level = (decoded['level'] ?? '').toString();
          final exercises = decoded['exercises'] as List<dynamic>? ?? [];
          for (final exercise in exercises) {
            if (exercise is Map) {
              final flat = Map<String, dynamic>.from(exercise);
              flat['topic'] = topic;
              flat['level'] = level;
              results.add(flat);
            }
          }
        } else if (decoded is List) {
          // Fallback: flat array of exercise objects (legacy format)
          for (final entry in decoded) {
            if (entry is Map) {
              results.add(Map<String, dynamic>.from(entry));
            }
          }
        }
      } catch (e) {
        // Skip files that fail to load
      }
    }
    return results;
  }
}

