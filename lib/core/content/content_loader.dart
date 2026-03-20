import 'dart:convert';

import 'package:flutter/services.dart';

/// This class loads the JSON data from the app's asset files.
class ContentLoader {
  /// This function loads a list of data from a single JSON file.
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

  static Future<Map<String, dynamic>> loadMap(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return Map<String, dynamic>.from(jsonDecode(raw));
  }

  static Future<List<Map<String, dynamic>>> loadAllLevels(
    String folder,
    List<String> levels,
  ) async {
    final results = <Map<String, dynamic>>[];
    for (final level in levels) {
      final data = await loadList('assets/content/$folder/$level.json');
      results.addAll(data);
    }
    return results;
  }
}
