import '../database/app_database.dart';
import 'dashboard_summary.dart';
import 'vocabulary_review.dart';

/// Represents a single item in the "Continue Learning" section on the home page.
///
/// It tells the user what they should learn next to stay motivated.
class ContinueLearningItem {
  const ContinueLearningItem({
    required this.sectionKey,
    required this.sectionLabel,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  /// The category of this item (e.g., 'grammar', 'vocabulary').
  final String sectionKey;

  /// The readable name of the section shown to the user.
  final String sectionLabel;

  /// The main text of the card (e.g., the name of a grammar topic).
  final String title;

  /// Extra information like level or completion percentage.
  final String subtitle;

  /// The navigation path to open when the user taps this item.
  final String route;
}

/// Creates a list of learning suggestions for the user.
///
/// It looks at grammar, vocabulary, and recent mistakes to find the best tasks.
List<ContinueLearningItem> buildContinueLearningItems({
  required List<GrammarTopic>? grammarTopics,
  required List<VocabularyWord>? vocabularyWords,
  required VocabularyReviewState? vocabularyReviewState,
  required List<Exercise>? exercises,
  required DashboardSummary? dashboardSummary,
}) {
  return [
    _buildGrammarItem(grammarTopics),
    _buildVocabularyItem(vocabularyWords, vocabularyReviewState),
    _buildExerciseItem(exercises, dashboardSummary),
  ];
}

/// Finds the best grammar topic for the user to practice next.
ContinueLearningItem _buildGrammarItem(List<GrammarTopic>? grammarTopics) {
  if (grammarTopics == null || grammarTopics.isEmpty) {
    return const ContinueLearningItem(
      sectionKey: 'grammar',
      sectionLabel: 'Grammar',
      title: 'Open grammar',
      subtitle: 'Continue with your next lesson',
      route: '/grammar',
    );
  }

  final unfinished = grammarTopics
      .where((topic) => topic.progress < 100)
      .toList()
    ..sort((left, right) {
      final startedCompare = _startedRank(left).compareTo(_startedRank(right));
      if (startedCompare != 0) {
        return startedCompare;
      }

      final updatedCompare = right.updatedAt.compareTo(left.updatedAt);
      if (updatedCompare != 0) {
        return updatedCompare;
      }

      final levelCompare =
          _levelRank(left.level).compareTo(_levelRank(right.level));
      if (levelCompare != 0) {
        return levelCompare;
      }

      return left.title.compareTo(right.title);
    });

  final topic = unfinished.isNotEmpty
      ? unfinished.first
      : (List<GrammarTopic>.from(grammarTopics)
            ..sort((left, right) => right.updatedAt.compareTo(left.updatedAt)))
          .first;
  final status =
      topic.progress > 0 ? '${topic.progress}% complete' : 'Ready to start';

  return ContinueLearningItem(
    sectionKey: 'grammar',
    sectionLabel: 'Grammar',
    title: topic.title,
    subtitle: '${topic.level} · ${topic.category} · $status',
    route: '/grammar/${topic.id}',
  );
}

/// Finds the best vocabulary word for the user to review next.
ContinueLearningItem _buildVocabularyItem(
  List<VocabularyWord>? vocabularyWords,
  VocabularyReviewState? vocabularyReviewState,
) {
  if (vocabularyWords == null ||
      vocabularyWords.isEmpty ||
      vocabularyReviewState == null) {
    return const ContinueLearningItem(
      sectionKey: 'vocabulary',
      sectionLabel: 'Vocabulary',
      title: 'Open vocabulary',
      subtitle: 'Continue with your next words',
      route: '/vocabulary?tab=words',
    );
  }

  final queue = buildVocabularyReviewQueue(
    vocabularyWords: vocabularyReviewState.wordRows,
    reviewByWordId: vocabularyReviewState.byWordId,
    now: DateTime.now(),
  );
  final fallbackWord = vocabularyWords.first;
  final nextWordId = queue.isNotEmpty ? queue.first : fallbackWord.id;
  final word = vocabularyWords.cast<VocabularyWord?>().firstWhere(
        (candidate) => candidate?.id == nextWordId,
        orElse: () => fallbackWord,
      )!;
  final reviewInfo = vocabularyReviewState.byWordId[word.id];

  final status = reviewInfo == null
      ? 'New word'
      : reviewInfo.isDue
          ? 'Due now'
          : reviewInfo.isMastered
              ? 'Keep fresh'
              : reviewInfo.reviewCount > 0
                  ? 'In review'
                  : 'New word';

  final route = Uri(
    path: '/vocabulary',
    queryParameters: {
      'tab': 'words',
      'category': word.category,
      'wordId': word.id,
    },
  ).toString();

  return ContinueLearningItem(
    sectionKey: 'vocabulary',
    sectionLabel: 'Vocabulary',
    title: word.german,
    subtitle: '${word.category} · $status',
    route: route,
  );
}

/// Suggests an exercise session, focusing on "weak areas" (topics with mistakes).
ContinueLearningItem _buildExerciseItem(
  List<Exercise>? exercises,
  DashboardSummary? dashboardSummary,
) {
  if (exercises == null || exercises.isEmpty) {
    return const ContinueLearningItem(
      sectionKey: 'exercises',
      sectionLabel: 'Exercises',
      title: 'Open exercises',
      subtitle: 'Practice with a short session',
      route: '/exercises',
    );
  }

  final preferredTopic = dashboardSummary?.weakAreas.isNotEmpty == true
      ? dashboardSummary!.weakAreas.first
      : null;

  // 1. Try exact match first
  var topicExercises = exercises.where((e) {
    if (preferredTopic == null) return false;
    return e.topic.toLowerCase() == preferredTopic.toLowerCase();
  }).toList();

  // 2. Fallback to substring match if no exact match found
  if (topicExercises.isEmpty && preferredTopic != null) {
    final pT = preferredTopic.toLowerCase();
    topicExercises = exercises.where((e) {
      final eT = e.topic.toLowerCase();
      return eT.contains(pT) || pT.contains(eT);
    }).toList();
  }

  final exercise = topicExercises.isNotEmpty
      ? topicExercises.first
      : (List<Exercise>.from(exercises)..sort(_compareExercises)).first;

  final topic = topicExercises.isNotEmpty ? preferredTopic! : exercise.topic;
  final topicCount =
      exercises.where((candidate) => candidate.topic == topic).length;

  final route = Uri(
    path: '/exercises',
    queryParameters: {
      'topic': topic,
      'level': exercise.level,
      'autostart': '1',
    },
  ).toString();
  final subtitle = topicExercises.isNotEmpty
      ? '${exercise.level} · Recommended from recent mistakes'
      : '${exercise.level} · $topicCount questions ready';

  return ContinueLearningItem(
    sectionKey: 'exercises',
    sectionLabel: 'Exercises',
    title: topic,
    subtitle: subtitle,
    route: route,
  );
}

int _startedRank(GrammarTopic topic) => topic.progress > 0 ? 0 : 1;

int _levelRank(String level) {
  switch (level.toUpperCase()) {
    case 'A1':
      return 0;
    case 'A2':
      return 1;
    case 'B1':
      return 2;
    case 'B2':
      return 3;
    case 'C1':
      return 4;
    default:
      return 99;
  }
}

int _compareExercises(Exercise left, Exercise right) {
  final levelCompare =
      _levelRank(left.level).compareTo(_levelRank(right.level));
  if (levelCompare != 0) {
    return levelCompare;
  }

  final topicCompare = left.topic.compareTo(right.topic);
  if (topicCompare != 0) {
    return topicCompare;
  }

  return left.question.compareTo(right.question);
}
