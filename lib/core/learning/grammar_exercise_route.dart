/// Generates a navigation route to open exercises for a specific grammar topic.
///
/// It uses the title, category, and level to find the correct exercises.
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
