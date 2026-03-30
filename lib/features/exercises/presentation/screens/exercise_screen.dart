import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/localization/app_ui_text.dart';
import '../../data/models/exercise_type.dart';
import '../../domain/exercise_providers.dart';
import '../widgets/exercise_selection_widgets.dart';
import '../widgets/exercise_session_widgets.dart';
import '../../../../core/content/sync/sync_service.dart';
import 'dart:math';
import 'dart:convert';

class ExerciseScreen extends ConsumerStatefulWidget {
  const ExerciseScreen({
    super.key,
    this.initialLevel = 'Alle',
    this.initialTopic,
    this.initialCategory,
    this.autoStart = false,
  });

  final String initialLevel;
  final String? initialTopic;
  final String? initialCategory;
  final bool autoStart;

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  ExerciseSessionState _state = ExerciseSessionState.select;
  bool _didAutoStart = false;
  List<Exercise> _exercises = [];
  Set<String> _answeredExerciseIds = <String>{};
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool? _isCorrect;
  bool _isPreviouslyAnswered = false;
  int _score = 0;
  final List<bool> _answers = [];

  // Sentence order specifics
  List<String> _userOrder = [];
  List<String> _availableWords = [];

  AppUiText get strings => AppUiText(ref.watch(displayLanguageProvider));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (exerciseLevels.contains(widget.initialLevel)) {
        ref.read(exerciseLevelProvider.notifier).state = widget.initialLevel;
      }

      // Apply incoming topic/category filters after first frame.
      ref.read(exerciseTopicProvider.notifier).state = widget.initialTopic;
      ref.read(exerciseCategoryProvider.notifier).state =
          widget.initialCategory;
    });
  }

  Future<void> _startSession(String type) async {
    final filtered = ref.read(filteredExercisesProvider);
    final db = ref.read(appDatabaseProvider);

    final attempts = await db.select(db.exerciseAttempts).get();
    final answeredIds = attempts
        .map((attempt) => attempt.exerciseId)
        .where((id) => id.isNotEmpty)
        .toSet();

    // Use localData first, but also include exercises from cloudMetadata as fallback
    final exercises = <Exercise>[];
    for (final entry in filtered) {
      if (entry.localData != null) {
        exercises.add(entry.localData!);
      } else if (entry.cloudMetadata != null) {
        // Reconstruct Exercise from cloud metadata if not available locally
        final ex = Exercise(
          id: entry.id,
          type: (entry.cloudMetadata?['type'] ?? '').toString(),
          question: (entry.cloudMetadata?['question'] ?? '').toString(),
          optionsJson: jsonEncode(
            (entry.cloudMetadata?['options'] as List<dynamic>? ??
                    const <dynamic>[])
                .map((e) => e.toString())
                .toList(),
          ),
          correctAnswer:
              (entry.cloudMetadata?['correctAnswer'] as num?)?.toInt() ?? 0,
          topic: (entry.cloudMetadata?['topic'] ?? '').toString(),
          level: (entry.cloudMetadata?['level'] ?? '').toString(),
          updatedAt: DateTime.now(),
        );
        exercises.add(ex);
      }
    }

    // Apply exercise-type filter based on selected card.
    final typeFiltered = type == 'all'
        ? exercises
        : exercises.where((ex) {
            if (type == 'fill-blank') {
              // Backward-compatible alias support.
              return ex.type == 'fill-blank' || ex.type == 'fill-in-blank';
            }
            return ex.type == type;
          }).toList();

    if (typeFiltered.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No exercises found.')),
      );
      return;
    }

    final unanswered = <Exercise>[];
    final answered = <Exercise>[];
    for (final ex in typeFiltered) {
      if (answeredIds.contains(ex.id)) {
        answered.add(ex);
      } else {
        unanswered.add(ex);
      }
    }

    unanswered.shuffle();
    answered.shuffle();
    final ordered = [...unanswered, ...answered];
    final session = ordered.take(10).toList();

    setState(() {
      _answeredExerciseIds = answeredIds;
      _exercises = session;
      _currentIndex = 0;
      _score = 0;
      _answers.clear();
      _selectedAnswer = null;
      _isCorrect = null;
      _isPreviouslyAnswered = false;
      _state = ExerciseSessionState.playing;
    });
    _initCurrentExerciseContent();
    _applyAnsweredStateForCurrentExercise();
  }

  void _initCurrentExerciseContent() {
    if (_exercises.isEmpty || _currentIndex >= _exercises.length) return;
    final ex = _exercises[_currentIndex];

    if (ex.type == 'sentence-order') {
      final originalWords = List<String>.from(jsonDecode(ex.optionsJson));
      final words = List<String>.from(originalWords);

      // Shuffle and retry a few times to avoid showing the exact original order.
      if (words.length > 1) {
        final random = Random();
        for (var i = 0; i < 5; i++) {
          words.shuffle(random);
          if (!_isSameWordOrder(words, originalWords)) {
            break;
          }
        }
      }

      setState(() {
        _availableWords = words;
        _userOrder = [];
      });
    }
  }

  bool _isSameWordOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _handleAnswer(int idx) {
    if (_selectedAnswer != null) return;
    final ex = _exercises[_currentIndex];
    final correct = idx == ex.correctAnswer;

    ref.read(appSettingsActionsProvider).recordExerciseOutcome(
          exerciseId: ex.id,
          isCorrect: correct,
          xpGained: correct ? 10 : 0,
        );

    setState(() {
      _selectedAnswer = idx;
      _isCorrect = correct;
      if (correct) _score++;
      _answers.add(correct);
      _state = ExerciseSessionState.feedback;
    });
  }

  void _nextQuestion() {
    if (_currentIndex + 1 >= _exercises.length) {
      setState(() => _state = ExerciseSessionState.results);
    } else {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _isCorrect = null;
        _isPreviouslyAnswered = false;
        _state = ExerciseSessionState.playing;
      });
      _initCurrentExerciseContent();
      _applyAnsweredStateForCurrentExercise();
    }
  }

  void _applyAnsweredStateForCurrentExercise() {
    if (_exercises.isEmpty || _currentIndex >= _exercises.length) return;
    final ex = _exercises[_currentIndex];
    if (!_answeredExerciseIds.contains(ex.id)) return;

    setState(() {
      if (ex.type == 'sentence-order') {
        final normalized =
            ex.question.trim().replaceAll(RegExp(r'[.!?,;:]'), '');
        _userOrder = normalized
            .split(RegExp(r'\s+'))
            .where((w) => w.isNotEmpty)
            .toList();
        _availableWords = [];
      }
      _selectedAnswer = ex.correctAnswer;
      _isCorrect = true;
      _isPreviouslyAnswered = true;
      _score++;
      _answers.add(true);
      _state = ExerciseSessionState.feedback;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final exercisesAsync = ref.watch(hybridExercisesProvider);
    final textPrimary = AppTokens.textPrimary(isDark);
    final textMuted = AppTokens.textMuted(isDark);
    final cardColor = AppTokens.surface(isDark);

    return exercisesAsync.when(
      data: (allEntries) {
        if (widget.autoStart &&
            !_didAutoStart &&
            _state == ExerciseSessionState.select &&
            allEntries.isNotEmpty) {
          _didAutoStart = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _startSession('all');
          });
        }

        switch (_state) {
          case ExerciseSessionState.select:
            return ExerciseSelectionView(
              onStartExercise: _startSession,
              autoStart: widget.autoStart,
              initialTopic: widget.initialTopic,
              initialCategory: widget.initialCategory,
            );
          case ExerciseSessionState.playing:
          case ExerciseSessionState.feedback:
            final ex = _exercises[_currentIndex];
            return Scaffold(
              backgroundColor:
                  isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildPlayingHeader(isDark, textMuted),
                      const SizedBox(height: 24),
                      QuestionCard(
                        question: ex.question,
                        isDark: isDark,
                        textPrimary: textPrimary,
                        cardColor: cardColor,
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: _buildTypeSpecificContent(
                            ex, isDark, textPrimary, textMuted, cardColor),
                      ),
                      if (_state == ExerciseSessionState.feedback)
                        _buildFeedbackArea(isDark, ex),
                    ],
                  ),
                ),
              ),
            );
          case ExerciseSessionState.results:
            return _buildResultsView(isDark, textPrimary, textMuted);
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text(e.toString()))),
    );
  }

  Widget _buildPlayingHeader(bool isDark, Color textMuted) {
    final progress = (_currentIndex + 1) / _exercises.length;
    return Row(children: [
      IconButton(
        icon: const Icon(Icons.close_rounded),
        onPressed: () => setState(() => _state = ExerciseSessionState.select),
      ),
      Expanded(
        child: LinearProgressIndicator(value: progress),
      ),
      const SizedBox(width: 12),
      Text('${_currentIndex + 1}/${_exercises.length}',
          style: TextStyle(color: textMuted)),
    ]);
  }

  Widget _buildTypeSpecificContent(Exercise ex, bool isDark, Color textPrimary,
      Color textMuted, Color cardColor) {
    if (ex.type == 'multiple-choice' || ex.type == 'fill-blank') {
      final options = List<String>.from(jsonDecode(ex.optionsJson));
      return MultipleChoiceOptions(
        options: options,
        selectedAnswer: _selectedAnswer,
        correctAnswer: ex.correctAnswer,
        onOptionSelected: _handleAnswer,
        isDark: isDark,
        textPrimary: textPrimary,
        cardColor: cardColor,
      );
    } else if (ex.type == 'sentence-order') {
      return SentenceOrderWidget(
        userOrder: _userOrder,
        availableWords: _availableWords,
        onWordAdded: (w) => setState(() {
          if (_state == ExerciseSessionState.feedback) return;
          _availableWords.remove(w);
          _userOrder.add(w);
          if (_availableWords.isEmpty) {
            // Remove punctuation and compare (question may have period, but word list won't)
            final userSentence = _userOrder.join(' ').toLowerCase().trim();
            final correctSentence = ex.question
                .toLowerCase()
                .trim()
                .replaceAll(RegExp(r'[.!?,;:]'), '');
            final correct = userSentence == correctSentence;
            _handleAnswer(correct ? 0 : -1); // Hack for session logic
          }
        }),
        onWordRemoved: (w) => setState(() {
          if (_state == ExerciseSessionState.feedback) return;
          _userOrder.remove(w);
          _availableWords.add(w);
        }),
        isDark: isDark,
        cardColor: cardColor,
        textPrimary: textPrimary,
      );
    }
    return const Center(child: Text('Unsupported exercise type'));
  }

  Widget _buildFeedbackArea(bool isDark, Exercise ex) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Icon(_isCorrect == true ? Icons.check_circle : Icons.error,
                    color: _isCorrect == true ? Colors.green : Colors.red),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(_isCorrect == true
                        ? (_isPreviouslyAnswered
                            ? 'Already answered.'
                            : 'Correct!')
                        : 'Incorrect. Correct: ${ex.question}')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _nextQuestion,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: const Color(0xFFFB923C),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildResultsView(bool isDark, Color textPrimary, Color textMuted) {
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text('Session Complete!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textPrimary)),
            const SizedBox(height: 8),
            Text('Score: $_score / ${_exercises.length}',
                style: TextStyle(fontSize: 18, color: textMuted)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () =>
                  setState(() => _state = ExerciseSessionState.select),
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
