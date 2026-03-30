/// Categorizes the types of study and reference materials provided for each exam.
enum ExamResourceType { 
  /// Standardized test paper in PDF format.
  pdf, 
  /// Listening comprehension audio files.
  mp3, 
  /// Link to a website or online testing portal.
  web 
}

/// Represents a downloadable or linkable official resource for exam preparation.
class ExamResource {
  /// The user-facing label for the resource.
  final String title;
  
  /// The [ExamResourceType] of this specific resource.
  final ExamResourceType type;
  
  /// The fully-qualified URL or relative asset path for the resource.
  final String url;

  /// A brief description of the resource.
  final String description;

  const ExamResource({
    required this.title,
    required this.type,
    required this.url,
    this.description = '',
  });

  /// Maps a JSON payload into an [ExamResource] instance.
  /// 
  /// The 'type' string is matched against [ExamResourceType] names, defaulting to [ExamResourceType.web].
  factory ExamResource.fromJson(Map<String, dynamic> json) {
    return ExamResource(
      title: json['title'] as String,
      type: ExamResourceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ExamResourceType.web,
      ),
      url: json['url'] as String,
      description: json['description'] as String? ?? '',
    );
  }
}

/// A specific sub-task within an exam module (e.g., "Reading - Teil 1").
class ExamPart {
  /// Header or name of the sub-task.
  final String title;
  
  /// Descriptive explanation of the task's requirements and format.
  final String description;

  const ExamPart({
    required this.title,
    required this.description,
  });

  /// standard JSON deserializer for exam sub-tasks.
  factory ExamPart.fromJson(Map<String, dynamic> json) {
    return ExamPart(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}

/// Defines a major component of an official German exam (Reading, Writing, etc.).
class ExamModule {
  /// The module name (e.g., 'Leseverstehen').
  final String name;

  /// String-based duration as provided by official sources (e.g., '65 min').
  final String duration;

  /// High-level description of what the module tests.
  final String description;

  /// Sequential list of tasks that comprise this module.
  final List<ExamPart> parts;

  /// Indicates if this entry represents a rest period instead of a test module.
  final bool isBreak;

  const ExamModule({
    required this.name,
    required this.duration,
    required this.description,
    this.parts = const [],
    this.isBreak = false,
  });

  /// Maps JSON data describing an exam module, handling legacy 'modules' fields if necessary.
  factory ExamModule.fromJson(Map<String, dynamic> json) {
    return ExamModule(
      name: json['name'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isBreak: json['isBreak'] as bool? ?? false,
      parts: json['parts'] != null
          ? (json['parts'] as List<dynamic>)
              .map((e) => ExamPart.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  /// Extracts the numeric minute value from the [duration] string.
  /// 
  /// Uses a regular expression `(\d+)` to find the first sequence of integers.
  /// Returns 0 if no numeric values are found.
  int get durationMinutes {
    final match = RegExp(r'(\d+)').firstMatch(duration);
    if (match != null) {
      return int.tryParse(match.group(1)!) ?? 0;
    }
    return 0;
  }
}

/// Describes how points in the exam translate to specific grades or outcomes.
class GradingEntry {
  /// Point threshold or range (e.g., "75-100").
  final String points;

  /// Resulting grade label (e.g., "sehr gut", "pass").
  final String grade;

  const GradingEntry({
    required this.points,
    required this.grade,
  });

  /// Standard JSON deserializer for grading table entries.
  factory GradingEntry.fromJson(Map<String, dynamic> json) {
    return GradingEntry(
      points: json['points'] as String,
      grade: json['grade'] as String,
    );
  }
}

/// The root model for all metadata and structure regarding a specific German proficiency exam.
///
/// This includes information from official providers like Goethe-Institut, ÖSD, or Telc.
class ExamInfo {
  /// Globally unique identifier for this exam type.
  final String id;

  /// Full name of the exam (e.g., "Goethe-Zertifikat A1: Start Deutsch 1").
  final String title;

  /// The organization providing the exam.
  final String provider;

  /// Targeted CEFR level (A1, A2, B1, B2, C1, C2).
  final String level;

  /// Broad summary of the exam's purpose and target audience.
  final String description;

  /// list of modules that structure the test day.
  final List<ExamModule> structure;

  /// Expert pedagogical tips collected for this specific exam level.
  final List<String> tips;

  /// Collection of official study materials and audio files.
  final List<ExamResource> resources;

  /// The official website URL for this exam.
  final String sourceUrl;

  /// Optional grading table provided for result interpretation.
  final List<GradingEntry>? grading;

  const ExamInfo({
    required this.id,
    required this.title,
    required this.provider,
    required this.level,
    required this.description,
    required this.structure,
    required this.tips,
    required this.resources,
    required this.sourceUrl,
    this.grading,
  });

  /// Unified factory that maps diverse JSON formats from remote or local storage into [ExamInfo].
  /// 
  /// Handles fallback keys like 'name' for 'title' and 'modules' for 'structure' to remain
  /// resilient against evolving API schemas.
  factory ExamInfo.fromJson(Map<String, dynamic> json) {
    return ExamInfo(
      id: json['id'] as String? ?? '',
      title: (json['title'] ?? json['name'] ?? '') as String,
      provider: json['provider'] as String? ?? '',
      level: json['level'] as String? ?? '',
      description: json['description'] as String? ?? '',
      structure: ((json['structure'] ?? json['modules'] ?? []) as List<dynamic>)
          .map((e) => ExamModule.fromJson(e as Map<String, dynamic>))
          .toList(),
      tips: ((json['tips'] ?? []) as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      resources: (json['resources'] != null)
          ? (json['resources'] as List<dynamic>)
              .map((e) => ExamResource.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      sourceUrl: (json['sourceUrl'] ?? "") as String,
      grading: json['grading'] != null
          ? (json['grading'] as List<dynamic>)
              .map((e) => GradingEntry.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}



