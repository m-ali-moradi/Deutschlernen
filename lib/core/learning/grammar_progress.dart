/// Ensures that the progress value is always between 0 and 100.
int clampGrammarProgress(int progress) => progress.clamp(0, 100).toInt();

/// Checks if a grammar topic is fully learned (100% progress).
bool isGrammarTopicCompleted(int progress) =>
    clampGrammarProgress(progress) >= 100;

/// Increases the progress of a grammar topic by a set amount.
int advanceGrammarProgress(int progress, {int step = 10}) {
  return clampGrammarProgress(progress + step);
}

/// Returns a text label for the current progress of a grammar topic.
///
/// It shows if the topic is 'Not started', 'In progress', or 'Completed'.
String grammarProgressStateLabel(int progress, {required bool isEnglish}) {
  if (isGrammarTopicCompleted(progress)) {
    return isEnglish ? 'Completed' : 'Abgeschlossen';
  }
  if (progress == 0) {
    return isEnglish ? 'Not started' : 'Nicht gestartet';
  }
  return isEnglish ? 'In progress' : 'In Arbeit';
}
