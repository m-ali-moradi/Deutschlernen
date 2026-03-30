import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/exam_models.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';

/// Provider for the [ExamsRepository]
final examsRepositoryProvider = Provider((ref) => ExamsRepository());

/// Repository to handle loading of exam information from assets
class ExamsRepository {
  /// Loads and parses the Goethe exam information from JSON
  Future<List<ExamInfo>> getGoetheExams({required String lang}) async {
    return _loadExamFile('assets/content/exams/$lang/exams_goethe.json');
  }

  /// Loads and parses the Telc exam information from JSON
  Future<List<ExamInfo>> getTelcExams({required String lang}) async {
    return _loadExamFile('assets/content/exams/$lang/exams_telc.json');
  }

  /// Loads and parses the ÖSD exam information from JSON
  Future<List<ExamInfo>> getOsdExams({required String lang}) async {
    return _loadExamFile('assets/content/exams/$lang/exams_osd.json');
  }

  Future<List<ExamInfo>> _loadExamFile(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> jsonData = json.decode(jsonString);
      final List<ExamInfo> exams = jsonData
          .map((e) => ExamInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      debugPrint('Successfully loaded ${exams.length} exams from $path');
      return exams;
    } catch (e) {
      debugPrint('Error loading exams from $path: $e');
      // Fallback to English if current language fails
      if (!path.contains('/en/')) {
        final fallbackPath = path.replaceFirst(RegExp(r'/([a-z]{2})/'), '/en/');
        debugPrint('Attempting fallback to $fallbackPath');
        return _loadExamFile(fallbackPath);
      }
      return [];
    }
  }

  /// Combined method to get all available exams from different providers
  Future<List<ExamInfo>> getAllExams(String lang) async {
    final results = await Future.wait([
      getGoetheExams(lang: lang),
      getTelcExams(lang: lang),
      getOsdExams(lang: lang),
    ]);
    final all = results.expand((x) => x).toList();
    debugPrint('Total exams loaded for $lang: ${all.length}');
    return all;
  }
}

/// Provider that fetches all exams asynchronously
final allExamsProvider = FutureProvider<List<ExamInfo>>((ref) async {
  final lang = ref.watch(displayLanguageProvider);
  final repo = ref.watch(examsRepositoryProvider);
  return repo.getAllExams(lang);
});



