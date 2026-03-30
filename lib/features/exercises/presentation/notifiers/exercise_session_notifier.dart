import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/features/exercises/data/models/exercise_type.dart';
import 'package:deutschmate_mobile/features/exercises/domain/exercise_providers.dart';
import 'package:deutschmate_mobile/features/exercises/domain/session_queue_policy.dart';

/// widget to hold the state of the exercise session
const Object _unset = Object();

class ExerciseSessionStateModel {
  const ExerciseSessionStateModel({
    this.mode = ExerciseSessionState.select,
    this.sessionType,
    this.exercises = const [],
    this.answeredExerciseIds = const {},
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
  final String? sessionType;
  final List<Exercise> exercises;
  final Set<String> answeredExerciseIds;
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

  ExerciseSessionStateModel copyWith({
    ExerciseSessionState? mode,
    Object? sessionType = _unset,
    List<Exercise>? exercises,
    Set<String>? answeredExerciseIds,
    int? currentIndex,
    Object? selectedAnswer = _unset,
    Object? isCorrect = _unset,
    bool? isPreviouslyAnswered,
    int? score,
    List<bool>? answers,
    List<String>? userOrder,
    List<String>? availableWords,
  }) {
    return ExerciseSessionStateModel(
      mode: mode ?? this.mode,
      sessionType: identical(sessionType, _unset)
          ? this.sessionType
          : sessionType as String?,
      exercises: exercises ?? this.exercises,
      answeredExerciseIds: answeredExerciseIds ?? this.answeredExerciseIds,
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

/// widget to hold the provider for the exercise session
final exerciseSessionProvider = AutoDisposeNotifierProvider<
    ExerciseSessionNotifier, ExerciseSessionStateModel>(
  ExerciseSessionNotifier.new,
);

/// widget to hold the notifier for the exercise session
class ExerciseSessionNotifier
    extends AutoDisposeNotifier<ExerciseSessionStateModel> {
  final Set<String> _scoredExerciseIds = <String>{};

  @override
  ExerciseSessionStateModel build() {
    return const ExerciseSessionStateModel();
  }

  Future<bool> startSession(String type) async {
    final filteredExercises = ref.read(filteredExercisesProvider);
    final db = ref.read(appDatabaseProvider);

    final attemptsQuery = db.select(db.exerciseAttempts)
      ..where((t) => t.scope.equals('exercises'))
      ..where((t) => t.isCorrect.equals(true));
    final attempts = await attemptsQuery.get();
    final answeredIds = attempts
        .map((attempt) => attempt.exerciseId)
        .where((id) => id.isNotEmpty)
        .toSet();

    final exercises = List<Exercise>.from(filteredExercises);

    final typeFiltered = type == 'all'
        ? exercises
        : exercises.where((exercise) {
            return _normalizeType(exercise.type) == _normalizeType(type);
          }).toList();

    if (typeFiltered.isEmpty) {
      return false;
    }

    final queueBuckets = buildExerciseQueueBuckets(
      exercises: typeFiltered,
      completedIds: answeredIds,
      incorrectIds: const <String>{},
      focusIds: const <String>{},
    );

    _scoredExerciseIds.clear();

    if (!queueBuckets.hasUnanswered) {
      final fallback = queueBuckets.allOrdered;
      state = ExerciseSessionStateModel(
        mode: ExerciseSessionState.playing,
        sessionType: type,
        exercises: List<Exercise>.unmodifiable(fallback),
        answeredExerciseIds: answeredIds,
        currentIndex: 0,
      );
      _initCurrentExerciseContent();
      _applyAnsweredStateForCurrentExercise();
      return true;
    }

    state = ExerciseSessionStateModel(
      mode: ExerciseSessionState.playing,
      sessionType: type,
      exercises: List<Exercise>.unmodifiable(queueBuckets.unansweredOrdered),
      answeredExerciseIds: answeredIds,
      currentIndex: 0,
    );

    _initCurrentExerciseContent();
    _applyAnsweredStateForCurrentExercise();
    return true;
  }

  /// widget to exit to selection
  void exitToSelection() {
    state = const ExerciseSessionStateModel();
  }

  Future<bool> restartSession() async {
    final type = state.sessionType;
    if (type == null || type.isEmpty) {
      return false;
    }
    return startSession(type);
  }

  /// widget to answer multiple choice
  void answerMultipleChoice(int selectedIndex) {
    final exercise = state.currentExercise;
    if (exercise == null || state.selectedAnswer != null) return;

    final correct = selectedIndex == exercise.correctAnswer;
    unawaited(
      ref.read(appSettingsActionsProvider).recordExerciseOutcome(
            exerciseId: exercise.id,
            isCorrect: correct,
            xpGained: correct ? 10 : 0,
            scope: 'exercises',
          ),
    );

    _scoredExerciseIds.add(exercise.id);

    state = state.copyWith(
      selectedAnswer: selectedIndex,
      isCorrect: correct,
      score: correct ? state.score + 1 : state.score,
      answers: [...state.answers, correct],
      mode: ExerciseSessionState.feedback,
    );
  }

  /// widget to add sentence word
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

  /// widget to remove sentence word
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

  /// widget to move to the next question
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
    _applyAnsweredStateForCurrentExercise();
  }

  /// widget to submit sentence order answer
  void _submitSentenceOrderAnswer(List<String> userOrder, Exercise exercise) {
    final correct = _normalizeSentence(userOrder.join(' ')) ==
        _normalizeSentence(exercise.question);

    unawaited(
      ref.read(appSettingsActionsProvider).recordExerciseOutcome(
            exerciseId: exercise.id,
            isCorrect: correct,
            xpGained: correct ? 10 : 0,
            scope: 'exercises',
          ),
    );

    _scoredExerciseIds.add(exercise.id);

    state = state.copyWith(
      selectedAnswer: null,
      isCorrect: correct,
      score: correct ? state.score + 1 : state.score,
      answers: [...state.answers, correct],
      mode: ExerciseSessionState.feedback,
    );
  }

  /// widget to initialize current exercise content
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

  /// widget to apply answered state for current exercise
  void _applyAnsweredStateForCurrentExercise() {
    final exercise = state.currentExercise;
    if (exercise == null || !state.answeredExerciseIds.contains(exercise.id)) {
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

  /// widget to check if two word orders are the same
  bool _isSameWordOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// widget to normalize sentence
  String _normalizeSentence(String value) {
    return value.toLowerCase().trim().replaceAll(RegExp(r'[.!?,;:]'), '');
  }

  /// widget to normalize type
  String _normalizeType(String type) {
    if (type == 'fill-in-blank') {
      return 'fill-blank';
    }
    return type;
  }
}
