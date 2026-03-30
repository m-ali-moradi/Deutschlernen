import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/features/exercises/data/models/exercise_type.dart';
import 'package:deutschmate_mobile/features/exercises/domain/exercise_providers.dart';
import 'package:deutschmate_mobile/features/exercises/domain/session_queue_policy.dart';

const Object _unset = Object();

class GrammarTopicExerciseSessionRequest {
  const GrammarTopicExerciseSessionRequest({
    required this.topicId,
    required this.topicTitle,
    required this.topicCategory,
    required this.topicLevel,
  });

  final String topicId;
  final String topicTitle;
  final String topicCategory;
  final String topicLevel;

  @override
  bool operator ==(Object other) {
    return other is GrammarTopicExerciseSessionRequest &&
        other.topicId == topicId &&
        other.topicTitle == topicTitle &&
        other.topicCategory == topicCategory &&
        other.topicLevel == topicLevel;
  }

  @override
  int get hashCode => Object.hash(
        topicId,
        topicTitle,
        topicCategory,
        topicLevel,
      );
}

class GrammarTopicExerciseSessionStateModel {
  const GrammarTopicExerciseSessionStateModel({
    this.mode = ExerciseSessionState.select,
    this.exercises = const [],
    this.completedExerciseIds = const {},
    this.incorrectExerciseIds = const {},
    this.currentIndex = 0,
    this.selectedAnswer,
    this.isCorrect,
    this.isPreviouslyAnswered = false,
    this.score = 0,
    this.answers = const [],
    this.userOrder = const [],
    this.availableWords = const [],
  });

  final ExerciseSessionState mode;
  final List<Exercise> exercises;
  final Set<String> completedExerciseIds;
  final Set<String> incorrectExerciseIds;
  final int currentIndex;
  final int? selectedAnswer;
  final bool? isCorrect;
  final bool isPreviouslyAnswered;
  final int score;
  final List<bool> answers;
  final List<String> userOrder;
  final List<String> availableWords;

  Exercise? get currentExercise {
    if (mode == ExerciseSessionState.select ||
        mode == ExerciseSessionState.results ||
        exercises.isEmpty ||
        currentIndex >= exercises.length) {
      return null;
    }
    return exercises[currentIndex];
  }

  int get progressPercent {
    if (exercises.isEmpty) return 0;
    return ((completedExerciseIds.length / exercises.length) * 100)
        .round()
        .clamp(0, 100);
  }

  GrammarTopicExerciseSessionStateModel copyWith({
    ExerciseSessionState? mode,
    List<Exercise>? exercises,
    Set<String>? completedExerciseIds,
    Set<String>? incorrectExerciseIds,
    int? currentIndex,
    Object? selectedAnswer = _unset,
    Object? isCorrect = _unset,
    bool? isPreviouslyAnswered,
    int? score,
    List<bool>? answers,
    List<String>? userOrder,
    List<String>? availableWords,
  }) {
    return GrammarTopicExerciseSessionStateModel(
      mode: mode ?? this.mode,
      exercises: exercises ?? this.exercises,
      completedExerciseIds: completedExerciseIds ?? this.completedExerciseIds,
      incorrectExerciseIds: incorrectExerciseIds ?? this.incorrectExerciseIds,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswer: identical(selectedAnswer, _unset)
          ? this.selectedAnswer
          : selectedAnswer as int?,
      isCorrect:
          identical(isCorrect, _unset) ? this.isCorrect : isCorrect as bool?,
      isPreviouslyAnswered: isPreviouslyAnswered ?? this.isPreviouslyAnswered,
      score: score ?? this.score,
      answers: answers ?? this.answers,
      userOrder: userOrder ?? this.userOrder,
      availableWords: availableWords ?? this.availableWords,
    );
  }
}

final grammarTopicExerciseSessionProvider = StateNotifierProvider.autoDispose
    .family<
        GrammarTopicExerciseSessionNotifier,
        GrammarTopicExerciseSessionStateModel,
        GrammarTopicExerciseSessionRequest>(
  (ref, request) => GrammarTopicExerciseSessionNotifier(ref, request),
);

class GrammarTopicExerciseSessionNotifier
    extends StateNotifier<GrammarTopicExerciseSessionStateModel> {
  GrammarTopicExerciseSessionNotifier(this._ref, this._request)
      : super(const GrammarTopicExerciseSessionStateModel());

  final Ref _ref;
  final GrammarTopicExerciseSessionRequest _request;
  final Set<String> _scoredExerciseIds = <String>{};

  Future<bool> startSession({Set<String> focusExerciseIds = const {}}) async {
    final exercises = await _loadTopicExercises();
    if (exercises.isEmpty) {
      return false;
    }

    final attemptState = await _loadAttemptStateForExercises(exercises);
    final correctAttemptIds = attemptState.$1;
    final incorrectAttemptIds = attemptState.$2;

    final queueBuckets = buildExerciseQueueBuckets(
      exercises: exercises,
      completedIds: correctAttemptIds,
      incorrectIds: incorrectAttemptIds,
      focusIds: focusExerciseIds,
    );

    _scoredExerciseIds.clear();

    final sessionExercises = queueBuckets.hasUnanswered
        ? queueBuckets.unansweredOrdered
        : queueBuckets.allOrdered;

    state = GrammarTopicExerciseSessionStateModel(
      mode: ExerciseSessionState.playing,
      exercises: List<Exercise>.unmodifiable(sessionExercises),
      completedExerciseIds: Set<String>.unmodifiable(correctAttemptIds),
      incorrectExerciseIds: Set<String>.unmodifiable(incorrectAttemptIds),
      currentIndex: 0,
      score: 0,
    );

    _initCurrentExerciseContent();
    _applyPreviouslyAnsweredStateForCurrentExercise();
    return true;
  }

  Future<bool> retryIncorrectExercises() async {
    if (state.incorrectExerciseIds.isEmpty) {
      return startSession();
    }

    return startSession(focusExerciseIds: state.incorrectExerciseIds);
  }

  void exitToSelection() {
    state = const GrammarTopicExerciseSessionStateModel();
  }

  void answerMultipleChoice(int selectedIndex) {
    final exercise = state.currentExercise;
    if (exercise == null || state.selectedAnswer != null) return;

    final correct = selectedIndex == exercise.correctAnswer;

    final completedIds = Set<String>.from(state.completedExerciseIds);
    final incorrectIds = Set<String>.from(state.incorrectExerciseIds);
    if (correct) {
      completedIds.add(exercise.id);
      incorrectIds.remove(exercise.id);
    } else {
      incorrectIds.add(exercise.id);
    }

    unawaited(
      _ref.read(appSettingsActionsProvider).recordExerciseOutcome(
            exerciseId: exercise.id,
            isCorrect: correct,
            xpGained: correct ? 10 : 0,
            scope: 'grammar_topic',
            syncGrammarFromAttempt: false,
          ),
    );

    _scoredExerciseIds.add(exercise.id);

    unawaited(_persistGrammarTopicProgress(completedIds.length));

    state = state.copyWith(
      completedExerciseIds: Set<String>.unmodifiable(completedIds),
      incorrectExerciseIds: Set<String>.unmodifiable(incorrectIds),
      selectedAnswer: selectedIndex,
      isCorrect: correct,
      score: correct ? state.score + 1 : state.score,
      answers: [...state.answers, correct],
      mode: ExerciseSessionState.feedback,
    );
  }

  void addSentenceWord(String word) {
    final exercise = state.currentExercise;
    if (exercise == null || state.mode == ExerciseSessionState.feedback) {
      return;
    }

    final availableWords = List<String>.from(state.availableWords);
    if (!availableWords.remove(word)) {
      return;
    }

    final userOrder = [...state.userOrder, word];
    state = state.copyWith(
      availableWords: List<String>.unmodifiable(availableWords),
      userOrder: List<String>.unmodifiable(userOrder),
    );

    if (availableWords.isEmpty) {
      _submitSentenceOrderAnswer(userOrder, exercise);
    }
  }

  void removeSentenceWord(String word) {
    final exercise = state.currentExercise;
    if (exercise == null || state.mode == ExerciseSessionState.feedback) {
      return;
    }

    final userOrder = List<String>.from(state.userOrder);
    if (!userOrder.remove(word)) {
      return;
    }

    final availableWords = [...state.availableWords, word];
    state = state.copyWith(
      availableWords: List<String>.unmodifiable(availableWords),
      userOrder: List<String>.unmodifiable(userOrder),
    );
  }

  void nextQuestion() {
    if (state.currentIndex + 1 >= state.exercises.length) {
      state = state.copyWith(mode: ExerciseSessionState.results);
      return;
    }

    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      selectedAnswer: null,
      isCorrect: null,
      isPreviouslyAnswered: false,
      mode: ExerciseSessionState.playing,
    );
    _initCurrentExerciseContent();
    _applyPreviouslyAnsweredStateForCurrentExercise();
  }

  Future<List<Exercise>> _loadTopicExercises() async {
    final exercises = _ref.read(localExercisesProvider);
    return exercises
        .where((exercise) => _matchesTopic(exercise.topic, _request.topicTitle))
        .toList(growable: false);
  }

  Future<(Set<String>, Set<String>)> _loadAttemptStateForExercises(
    List<Exercise> exercises,
  ) async {
    final exerciseIds = exercises.map((exercise) => exercise.id).toSet();
    if (exerciseIds.isEmpty) {
      return (<String>{}, <String>{});
    }

    final db = _ref.read(appDatabaseProvider);
    final attemptsQuery = db.select(db.exerciseAttempts)
      ..where((t) => t.scope.equals('grammar_topic'))
      ..where((t) => t.exerciseId.isIn(exerciseIds));
    final attempts = await attemptsQuery.get();

    final correctAttemptIds = attempts
        .where((attempt) => attempt.isCorrect)
        .map((attempt) => attempt.exerciseId)
        .toSet();
    final incorrectAttemptIds = attempts
        .where((attempt) => !attempt.isCorrect)
        .map((attempt) => attempt.exerciseId)
        .toSet();

    incorrectAttemptIds.removeAll(correctAttemptIds);

    return (correctAttemptIds, incorrectAttemptIds);
  }

  void _submitSentenceOrderAnswer(List<String> userOrder, Exercise exercise) {
    final correct = _normalizeSentence(userOrder.join(' ')) ==
        _normalizeSentence(exercise.question);

    final completedIds = Set<String>.from(state.completedExerciseIds);
    final incorrectIds = Set<String>.from(state.incorrectExerciseIds);
    if (correct) {
      completedIds.add(exercise.id);
      incorrectIds.remove(exercise.id);
    } else {
      incorrectIds.add(exercise.id);
    }

    unawaited(
      _ref.read(appSettingsActionsProvider).recordExerciseOutcome(
            exerciseId: exercise.id,
            isCorrect: correct,
            xpGained: correct ? 10 : 0,
            scope: 'grammar_topic',
            syncGrammarFromAttempt: false,
          ),
    );

    _scoredExerciseIds.add(exercise.id);

    unawaited(_persistGrammarTopicProgress(completedIds.length));

    state = state.copyWith(
      completedExerciseIds: Set<String>.unmodifiable(completedIds),
      incorrectExerciseIds: Set<String>.unmodifiable(incorrectIds),
      selectedAnswer: null,
      isCorrect: correct,
      score: correct ? state.score + 1 : state.score,
      answers: [...state.answers, correct],
      mode: ExerciseSessionState.feedback,
    );
  }

  void _initCurrentExerciseContent() {
    final exercise = state.currentExercise;
    if (exercise == null) return;

    if (exercise.type == 'sentence-order') {
      final originalWords = List<String>.from(jsonDecode(exercise.optionsJson));
      final words = List<String>.from(originalWords);

      if (words.length > 1) {
        final random = Random();
        for (var i = 0; i < 5; i++) {
          words.shuffle(random);
          if (!_isSameWordOrder(words, originalWords)) {
            break;
          }
        }
      }

      state = state.copyWith(
        availableWords: List<String>.unmodifiable(words),
        userOrder: const [],
      );
    } else {
      state = state.copyWith(
        availableWords: const [],
        userOrder: const [],
      );
    }
  }

  void _applyPreviouslyAnsweredStateForCurrentExercise() {
    final exercise = state.currentExercise;
    if (exercise == null || !state.completedExerciseIds.contains(exercise.id)) {
      return;
    }

    if (exercise.type == 'sentence-order') {
      final normalized = _normalizeSentence(exercise.question);
      final words = normalized
          .split(RegExp(r'\s+'))
          .where((word) => word.isNotEmpty)
          .toList();

      state = state.copyWith(
        userOrder: List<String>.unmodifiable(words),
        availableWords: const [],
      );
    }

    final wasScoredInSession = _scoredExerciseIds.contains(exercise.id);

    if (!wasScoredInSession) {
      _scoredExerciseIds.add(exercise.id);
    }

    state = state.copyWith(
      selectedAnswer: exercise.correctAnswer,
      isCorrect: true,
      isPreviouslyAnswered: true,
      score: wasScoredInSession ? state.score : state.score + 1,
      answers: wasScoredInSession ? state.answers : [...state.answers, true],
      mode: ExerciseSessionState.feedback,
    );
  }

  Future<void> _persistGrammarTopicProgress(int completedCount) async {
    if (state.exercises.isEmpty) return;

    final nextProgress =
        ((completedCount / state.exercises.length) * 100).round().clamp(0, 100);

    final db = _ref.read(appDatabaseProvider);
    final topicRow = await (db.select(db.grammarTopics)
          ..where((t) => t.id.equals(_request.topicId)))
        .getSingleOrNull();

    final currentProgress = topicRow?.progress ?? 0;
    final mergedProgress = max(currentProgress, nextProgress);

    await _ref
        .read(appSettingsActionsProvider)
        .updateGrammarProgress(_request.topicId, mergedProgress);
  }

  bool _matchesTopic(String exerciseTopic, String selectedTopic) {
    final e = _normalizeTopic(exerciseTopic);
    final t = _normalizeTopic(selectedTopic);
    if (e.isEmpty || t.isEmpty) return false;

    return e == t;
  }

  bool _isSameWordOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  String _normalizeSentence(String value) {
    return value.toLowerCase().trim().replaceAll(RegExp(r'[.!?,;:]'), '');
  }

  String _normalizeTopic(String value) {
    return value
        .toLowerCase()
        .trim()
        .replaceAll('ä', 'ae')
        .replaceAll('ö', 'oe')
        .replaceAll('ü', 'ue')
        .replaceAll('ß', 'ss')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
