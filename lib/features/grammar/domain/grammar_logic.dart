/// Ensures that the progress value is always between 0 and 100.
int clampGrammarProgress(int progress) => progress.clamp(0, 100).toInt();

/// Returns whether a grammar topic is considered "completed" based on progress %.
bool isGrammarTopicCompleted(int progress) {
  return clampGrammarProgress(progress) >= 100;
}

/// Increases the progress of a grammar topic by a set amount.
int advanceGrammarProgress(int progress, {int step = 10}) {
  return clampGrammarProgress(progress + step);
}

/// Returns a numeric rank for educational levels (A1-C1).
int grammarLevelRank(String level) {
  switch (level.toUpperCase()) {
    case 'A1': return 1;
    case 'A2': return 2;
    case 'B1': return 3;
    case 'B2': return 4;
    case 'C1': return 5;
    case 'C2': return 6;
    default: return 99;
  }
}

/// Returns a numeric rank for grammar categories based on pedagogical priority.
int grammarCategoryRank(String category) {
  final categories = [
    'Artikel',
    'Satzbau',
    'Fälle',
    'Pronomen',
    'Zeiten',
    'Verben',
    'Präpositionen',
    'Adjektive',
    'Nebensätze',
    'Konjunktiv',
    'Partikeln',
  ];
  final index = categories.indexOf(category);
  return index != -1 ? index : 99;
}

/// Returns the numeric part of a grammar topic ID (e.g., 'g1' -> 1).
/// This allows natural sorting from easier to harder topics.
int grammarTopicIdRank(String id) {
  final match = RegExp(r'\d+').firstMatch(id);
  if (match != null) {
    return int.tryParse(match.group(0)!) ?? 999;
  }
  return 999;
}

/// Returns a localized label for grammar progress.
String grammarProgressStateLabel(int progress, {required bool isEnglish}) {
  final completed = isGrammarTopicCompleted(progress);
  if (completed) {
    return isEnglish ? 'Completed' : 'Abgeschlossen';
  }
  if (progress == 0) {
    return isEnglish ? 'Not started' : 'Nicht begonnen';
  }
  return isEnglish ? 'In progress ($progress%)' : 'In Bearbeitung ($progress%)';
}

/// Generates a navigation route to open exercises for a specific grammar topic.
String resolveGrammarExerciseRoute({
  required String title,
  required String category,
  required String level,
}) {
  return Uri(
    path: '/exercises',
    queryParameters: {
      'topic': title,
      'category': category,
      'autostart': '1',
      'level': level,
    },
  ).toString();
}
