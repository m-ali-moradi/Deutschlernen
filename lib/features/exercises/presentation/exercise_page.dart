import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'dart:math';
import '../../../core/database/database_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/learning/weak_area_routes.dart';
import '../../../shared/widgets/app_state_view.dart';
import '../../../shared/localization/app_ui_text.dart';

// ─── Exercise type model ─────────────────────────────────────────────────────
/// This class represents a single exercise type (e.g., Multiple Choice).
class _ExType {
  const _ExType(
      {required this.type,
      required this.label,
      required this.icon,
      required this.gradient});
  final String type, label, icon;
  final List<Color> gradient;
}

const _exTypes = [
  _ExType(
      type: 'all',
      label: 'Alle Übungen',
      icon: '📝',
      gradient: [Color(0xFF3B82F6), Color(0xFF9333EA)]),
  _ExType(
      type: 'multiple-choice',
      label: 'Multiple Choice',
      icon: '🔘',
      gradient: [Color(0xFF818CF8), Color(0xFF4F46E5)]),
  _ExType(
      type: 'fill-blank',
      label: 'Lückentext',
      icon: '✍️',
      gradient: [Color(0xFF2DD4BF), Color(0xFF0D9488)]),
  _ExType(
      type: 'sentence-order',
      label: 'Satzordnung',
      icon: '🔀',
      gradient: [Color(0xFFFBBF24), Color(0xFFD97706)]),
  _ExType(
      type: 'business-dialog',
      label: 'Business Dialog',
      icon: '💼',
      gradient: [Color(0xFFFB7185), Color(0xFFE11D48)]),
];

const _levels = ['Alle', 'A1', 'A2', 'B1', 'B2'];

String _exerciseTypeLabel(AppUiText strings, String type) {
  switch (type) {
    case 'all':
      return strings.either(german: 'Alle Übungen', english: 'All exercises');
    case 'multiple-choice':
      return strings.either(
          german: 'Multiple Choice', english: 'Multiple choice');
    case 'fill-blank':
      return strings.either(
          german: 'Lückentext', english: 'Fill in the blanks');
    case 'sentence-order':
      return strings.either(german: 'Satzordnung', english: 'Sentence order');
    case 'business-dialog':
      return strings.either(
          german: 'Business Dialog', english: 'Business dialog');
    default:
      return type;
  }
}

enum _ExState { select, playing, feedback, results }

// ─── ExercisePage ─────────────────────────────────────────────────────────────
/// This page allows users to practice German through various exercises.
///
/// It supports types like multiple-choice, fill-in-the-blanks, and sentence order.
class ExercisePage extends ConsumerStatefulWidget {
  const ExercisePage({
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
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

/// This state manages the exercise session, including scoring and navigation.
class _ExercisePageState extends ConsumerState<ExercisePage> {
  _ExState _state = _ExState.select;
  String _selectedLevel = 'Alle';
  String _selectedType = 'all';
  List<Exercise> _exercises = [];
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool? _isCorrect;
  int _score = 0;
  List<bool> _answers = [];
  bool _didAutoStart = false;
  Set<String> _completedExerciseIds = {};

  // For Sentence Order exercises
  List<String> _userOrder = [];
  List<String> _availableWords = [];
  String _shuffledQuestion = '';

  AppUiText get strings => AppUiText(ref.watch(displayLanguageProvider));

  @override
  void initState() {
    super.initState();
    if (_levels.contains(widget.initialLevel)) {
      _selectedLevel = widget.initialLevel;
    }
  }

  /// This function starts a new exercise session for a specific type and level.
  void _startExercise(String type, List<Exercise> allExercises) {
    _selectedType = type;
    var filtered = allExercises.toList();
    if (type != 'all') {
      filtered = filtered.where((e) => e.type == type).toList();
    }
    if (_selectedLevel != 'Alle') {
      filtered = filtered.where((e) => e.level == _selectedLevel).toList();
    }

    if (filtered.isEmpty) {
      // If no exercises match, show a message or just use a fallback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No exercises found for this selection.')),
      );
      return;
    }

    filtered.shuffle();
    _startExerciseSession(filtered.take(10).toList());
  }

  Future<void> _startExerciseSession(List<Exercise> sessionExercises) async {
    final db = ref.read(appDatabaseProvider);
    final attempts = await (db.select(db.exerciseAttempts)
          ..where((t) => t.exerciseId.isIn(sessionExercises.map((e) => e.id))))
        .get();

    _completedExerciseIds =
        attempts.where((a) => a.isCorrect).map((a) => a.exerciseId).toSet();

    final uncompleted = sessionExercises
        .where((e) => !_completedExerciseIds.contains(e.id))
        .toList();
    final completed = sessionExercises
        .where((e) => _completedExerciseIds.contains(e.id))
        .toList();

    final sortedSession = [...uncompleted, ...completed];

    if (!mounted) return;

    setState(() {
      _exercises = sortedSession;
      _currentIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _score = 0;
      _answers = [];
      _state = _ExState.playing;
    });

    _initCurrentExerciseContent();
    _applySavedStateForCurrentIndex();
  }

  void _initCurrentExerciseContent() {
    if (_exercises.isEmpty || _currentIndex >= _exercises.length) return;
    final ex = _exercises[_currentIndex];

    if (ex.type == 'sentence-order') {
      final List<String> words = List<String>.from(jsonDecode(ex.optionsJson));
      setState(() {
        _availableWords = words..shuffle(Random());
        _userOrder = [];
        // Extract words from question for display pool (shuffled)
        final qWords = ex.question.split(' ')..shuffle(Random());
        _shuffledQuestion = qWords.join(' ');
      });
    }
  }

  void _applySavedStateForCurrentIndex() {
    if (_exercises.isEmpty || _currentIndex >= _exercises.length) return;
    final ex = _exercises[_currentIndex];

    if (_completedExerciseIds.contains(ex.id)) {
      setState(() {
        _selectedAnswer = ex.correctAnswer;
        _isCorrect = true;
        _score++;
        _answers.add(true);
        _state = _ExState.feedback;
      });
    }
  }

  void _startWeakTopicExercise(List<Exercise> allExercises, String topic,
      {String? category}) {
    final tL = topic.toLowerCase();

    // 1. Try Exact Match by topic
    var filtered =
        allExercises.where((e) => e.topic.toLowerCase() == tL).toList();

    // 2. Try Partial Match (substring) if no exact matches found
    if (filtered.isEmpty) {
      filtered = allExercises.where((e) {
        final eL = e.topic.toLowerCase();
        return eL.contains(tL) || tL.contains(eL);
      }).toList();
    }

    // 3. Fallback to Category match if still no topic-specific exercises
    if (filtered.isEmpty && category != null && category.isNotEmpty) {
      final cL = category.toLowerCase();
      filtered = allExercises.where((e) {
        final eL = e.topic.toLowerCase();
        return eL == cL || eL.contains(cL) || cL.contains(eL);
      }).toList();
    }
    if (_selectedType != 'all') {
      filtered = filtered.where((e) => e.type == _selectedType).toList();
    }
    if (_selectedLevel != 'Alle') {
      filtered = filtered.where((e) => e.level == _selectedLevel).toList();
    }

    if (filtered.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No exercises found for the topic "$topic".')),
      );
      return;
    }

    filtered.shuffle();
    _startExerciseSession(filtered.take(10).toList());
  }

  void _openWeakTopicDestination(String topic) {
    context.go(resolveWeakAreaRoute(topic).route);
  }

  /// This function handles the user's answer and calculates the result.
  void _handleAnswer(int idx) {
    if (_selectedAnswer != null) return;
    final ex = _exercises[_currentIndex];
    final correct = idx == ex.correctAnswer;

    // Record outcome in database
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
      _state = _ExState.feedback;
    });
  }

  void _nextQuestion() {
    if (_currentIndex + 1 >= _exercises.length) {
      setState(() => _state = _ExState.results);
    } else {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _isCorrect = null;
        _state = _ExState.playing;
      });
      _initCurrentExerciseContent();
      _applySavedStateForCurrentIndex();
    }
  }

  void _retryWrongQuestions() {
    final wrongExercises = <Exercise>[];
    for (int i = 0; i < _exercises.length; i++) {
      if (i < _answers.length && !_answers[i]) {
        wrongExercises.add(_exercises[i]);
      }
    }
    if (wrongExercises.isEmpty) return;

    // Shuffle the wrong ones so they aren't completely predictable
    wrongExercises.shuffle();
    _startExerciseSession(wrongExercises);
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesStreamProvider);
    final weakAreas = ref.watch(exerciseWeakAreasProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = AppTokens.textPrimary(isDark);
    final textMuted = AppTokens.textMuted(isDark);
    final cardColor = AppTokens.surface(isDark);
    final surfaceColor = AppTokens.surfaceMuted(isDark);

    return exercisesAsync.when(
      data: (allExercises) {
        switch (_state) {
          case _ExState.select:
            return _buildSelect(isDark, textPrimary, textMuted, cardColor,
                allExercises, weakAreas);
          case _ExState.playing:
          case _ExState.feedback:
            return _buildPlaying(
                isDark, textPrimary, textMuted, cardColor, surfaceColor);
          case _ExState.results:
            return _buildResults(isDark, textPrimary, textMuted, cardColor,
                allExercises, weakAreas);
        }
      },
      loading: () => const Scaffold(
          body: AppStateView.loading(
        title: 'Loading exercises',
        message: 'The exercise data is being synchronized.',
      )),
      error: (e, s) => Scaffold(
          body: AppStateView.error(
        message: 'The exercises could not be loaded.\n$e',
        onAction: () => ref.invalidate(exercisesStreamProvider),
      )),
    );
  }

  // ── SELECT SCREEN ─────────────────────────────────────────────────────────
  Widget _buildSelect(bool isDark, Color textPrimary, Color textMuted,
      Color cardColor, List<Exercise> all, List<String> weakAreas) {
    if (widget.autoStart && !_didAutoStart) {
      _didAutoStart = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        final initialTopic = widget.initialTopic;
        if (initialTopic != null && initialTopic.isNotEmpty) {
          _startWeakTopicExercise(all, initialTopic,
              category: widget.initialCategory);
          return;
        }
        _startExercise(_selectedType, all);
      });
    }

    final levelFiltered = _selectedLevel == 'Alle'
        ? all
        : all.where((exercise) => exercise.level == _selectedLevel).toList();

    return SafeArea(
      top: false,
      bottom: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Row(children: [
            _BackButton(isDark: isDark, onTap: () => context.go('/')),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  strings.either(german: 'Übungen ✏️', english: 'Exercises ✏️'),
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: textPrimary)),
              Text(
                  strings.either(
                      german: 'Tests & Quiz', english: 'Tests & quizzes'),
                  style: TextStyle(fontSize: 12, color: textMuted)),
            ]),
          ]),

          const SizedBox(height: 18),

          // Level filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: _levels.map((lvl) {
              final sel = lvl == _selectedLevel;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedLevel = lvl),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: sel
                          ? const LinearGradient(
                              colors: [Color(0xFFFB923C), Color(0xFFEA580C)])
                          : null,
                      color: sel ? null : cardColor,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(sel ? 0.15 : 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Text(lvl,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: sel ? Colors.white : textMuted,
                        )),
                  ),
                ),
              );
            }).toList()),
          ),

          const SizedBox(height: 20),

          Text(strings.either(german: 'Übungstypen', english: 'Exercise types'),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textPrimary)),
          const SizedBox(height: 12),

          // Exercise type cards
          ..._exTypes.map((et) {
            final count = et.type == 'all'
                ? levelFiltered.length
                : levelFiltered.where((e) => e.type == et.type).length;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => _startExercise(et.type, all),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: et.gradient),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: et.gradient.first.withOpacity(0.3),
                          blurRadius: 14,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: Row(children: [
                    Text(et.icon, style: const TextStyle(fontSize: 30)),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(_exerciseTypeLabel(strings, et.type),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(height: 2),
                          Text(
                              strings.either(
                                german: '$count Fragen verfügbar',
                                english: '$count questions available',
                              ),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7))),
                        ])),
                    Icon(Icons.chevron_right_rounded,
                        color: Colors.white.withOpacity(0.6), size: 22),
                  ]),
                ),
              ),
            );
          }),

          if (weakAreas.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.either(
                        german: 'Deine Schwachstellen',
                        english: 'Your weak areas'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    strings.either(
                      german: 'Tippe auf ein Thema, um direkt dort zu üben.',
                      english: 'Tap a topic to practice it directly.',
                    ),
                    style: TextStyle(fontSize: 12, color: textMuted),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: weakAreas.map((topic) {
                      return InkWell(
                        onTap: () => _openWeakTopicDestination(topic),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            topic,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  // ── PLAYING / FEEDBACK SCREEN ─────────────────────────────────────────────
  Widget _buildPlaying(bool isDark, Color textPrimary, Color textMuted,
      Color cardColor, Color surfaceColor) {
    if (_exercises.isEmpty) return const SizedBox();
    final ex = _exercises[_currentIndex];
    // Progress
    final progress = (_currentIndex + 1) / _exercises.length;

    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(children: [
          // Top bar
          Row(children: [
            _BackButton(
                isDark: isDark,
                onTap: () => setState(() => _state = _ExState.select)),
            const SizedBox(width: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFFB923C)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text('${_currentIndex + 1}/${_exercises.length}',
                style: TextStyle(fontSize: 12, color: textMuted)),
          ]),

          const SizedBox(height: 16),

          // Type/level badges
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(100)),
              child: Text(_typeLabel(ex.type),
                  style: TextStyle(fontSize: 11, color: textMuted)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(ex.level,
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xFF3B82F6))),
            ),
            if (ex.topic.isNotEmpty) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF312E81)
                        : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(ex.topic,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF4F46E5))),
                ),
              ),
            ],
          ]),

          const SizedBox(height: 16),

          // Question card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6))
              ],
            ),
            child: _buildQuestionContent(ex, textPrimary),
          ),

          const SizedBox(height: 16),

          // Dynamic Content based on type
          Expanded(
            child: _buildTypeSpecificContent(
                ex, isDark, textPrimary, textMuted, cardColor, surfaceColor),
          ),

          // Feedback + Next button
          if (_state == _ExState.feedback) ...[
            const SizedBox(height: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _isCorrect == true
                    ? (isDark
                        ? const Color(0xFF052E16)
                        : const Color(0xFFF0FDF4))
                    : (isDark
                        ? const Color(0xFF450A0A)
                        : const Color(0xFFFFF1F2)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(children: [
                Text(_isCorrect == true ? '🎉' : '💡',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                  _isCorrect == true
                      ? 'Richtig! Gut gemacht!'
                      : (ex.type == 'sentence-order'
                          ? 'Die richtige Reihenfolge ist: ${ex.question}'
                          : 'Die richtige Antwort ist: ${List<String>.from(jsonDecode(ex.optionsJson))[ex.correctAnswer]}'),
                  style: TextStyle(
                      fontSize: 13,
                      color: _isCorrect == true
                          ? (isDark
                              ? const Color(0xFF86EFAC)
                              : const Color(0xFF15803D))
                          : (isDark
                              ? const Color(0xFFFCA5A5)
                              : const Color(0xFFDC2626))),
                )),
              ]),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _nextQuestion,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF9333EA)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ],
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    _currentIndex + 1 >= _exercises.length
                        ? 'Show results'
                        : 'Next question',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right_rounded,
                      color: Colors.white, size: 18),
                ]),
              ),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _buildQuestionContent(Exercise ex, Color textPrimary) {
    if (ex.type == 'fill-blank' && ex.question.contains('___')) {
      final parts = ex.question.split('___');
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
              fontSize: 18,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: textPrimary,
              fontFamily: 'Inter'),
          children: [
            TextSpan(text: parts[0]),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: const Text('  ?  ',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            ),
            if (parts.length > 1) TextSpan(text: parts[1]),
          ],
        ),
      );
    }

    if (ex.type == 'sentence-order' && _selectedAnswer == null) {
      return Column(
        children: [
          Text(
            strings.either(
                german: 'Bilde den richtigen Satz:',
                english: 'Build the correct sentence:'),
            style: TextStyle(fontSize: 12, color: textPrimary.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 12),
          Text(
            _shuffledQuestion,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: textPrimary),
          ),
        ],
      );
    }

    return Text(ex.question,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 17,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: textPrimary));
  }

  Widget _buildTypeSpecificContent(Exercise ex, bool isDark, Color textPrimary,
      Color textMuted, Color cardColor, Color surfaceColor) {
    if (ex.type == 'sentence-order') {
      return _buildSentenceOrder(
          ex, isDark, textPrimary, textMuted, cardColor, surfaceColor);
    }
    if (ex.type == 'business-dialog') {
      return _buildBusinessDialog(
          ex, isDark, textPrimary, textMuted, cardColor, surfaceColor);
    }
    if (ex.type == 'fill-blank') {
      return _buildFillBlank(
          ex, isDark, textPrimary, textMuted, cardColor, surfaceColor);
    }
    return _buildMultipleChoice(
        ex, isDark, textPrimary, textMuted, cardColor, surfaceColor);
  }

  /// This function builds the UI for multiple choice questions.
  Widget _buildMultipleChoice(Exercise ex, bool isDark, Color textPrimary,
      Color textMuted, Color cardColor, Color surfaceColor) {
    final List<String> options = List<String>.from(jsonDecode(ex.optionsJson));
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: options.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, idx) {
        final res = _getChoiceColors(idx, ex.correctAnswer, isDark, textPrimary,
            textMuted, cardColor, surfaceColor);
        return GestureDetector(
          onTap: () => _handleAnswer(idx),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: res.bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: res.border, width: 2),
            ),
            child: Row(children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: res.circleBg,
                    borderRadius: BorderRadius.circular(100)),
                child: Center(
                    child: Text(res.label,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: res.labelColor))),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(options[idx],
                      style: TextStyle(fontSize: 14, color: res.textColor))),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildFillBlank(Exercise ex, bool isDark, Color textPrimary,
      Color textMuted, Color cardColor, Color surfaceColor) {
    return _buildMultipleChoice(
        ex, isDark, textPrimary, textMuted, cardColor, surfaceColor);
  }

  /// This function builds the UI for sentence order questions.
  Widget _buildSentenceOrder(Exercise ex, bool isDark, Color textPrimary,
      Color textMuted, Color cardColor, Color surfaceColor) {
    return Column(children: [
      // Construction area
      Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 120),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isCorrect == true
                ? const Color(0xFF22C55E)
                : _isCorrect == false
                    ? const Color(0xFFEF4444)
                    : Colors.transparent,
            width: 2,
          ),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _userOrder.map((word) {
            return GestureDetector(
              onTap: _selectedAnswer != null
                  ? null
                  : () {
                      setState(() {
                        _userOrder.remove(word);
                        _availableWords.add(word);
                      });
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 4)
                  ],
                ),
                child: Text(word, style: TextStyle(color: textPrimary)),
              ),
            );
          }).toList(),
        ),
      ),
      const SizedBox(height: 20),
      // Word pool
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _availableWords.map((word) {
          return GestureDetector(
            onTap: _selectedAnswer != null
                ? null
                : () {
                    setState(() {
                      _availableWords.remove(word);
                      _userOrder.add(word);
                    });
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: isDark ? Colors.white10 : Colors.black12),
              ),
              child: Text(word,
                  style: TextStyle(
                      color: textPrimary, fontWeight: FontWeight.w500)),
            ),
          );
        }).toList(),
      ),
      const Spacer(),
      if (_selectedAnswer == null)
        AppActionButton.primary(
          label: 'Check',
          onPressed: _userOrder.isEmpty
              ? null
              : () {
                  final result = _userOrder.join(' ');
                  // Simple logic: exact match or case-insensitive without trailing punct
                  final correct = result
                          .trim()
                          .toLowerCase()
                          .replaceAll(RegExp(r'[.!,?;]'), '') ==
                      ex.question
                          .trim()
                          .toLowerCase()
                          .replaceAll(RegExp(r'[.!,?;]'), '');

                  ref.read(appSettingsActionsProvider).recordExerciseOutcome(
                        exerciseId: ex.id,
                        isCorrect: correct,
                        xpGained: correct ? 10 : 0,
                      );

                  setState(() {
                    _selectedAnswer = 1; // dummy index
                    _isCorrect = correct;
                    if (correct) _score++;
                    _answers.add(correct);
                    _state = _ExState.feedback;
                  });
                },
          fullWidth: true,
        ),
    ]);
  }

  /// This function builds the UI for business dialog questions.
  Widget _buildBusinessDialog(Exercise ex, bool isDark, Color textPrimary,
      Color textMuted, Color cardColor, Color surfaceColor) {
    final lines = ex.question.split('\n');
    return Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: lines.length,
          itemBuilder: (context, index) {
            final line = lines[index];
            final isSpeaker = line.contains(':');
            final parts = line.split(':');
            final name = isSpeaker ? parts[0] : '';
            final msg = isSpeaker ? parts.sublist(1).join(':') : line;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: index % 2 == 0
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? (isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9))
                            : (isDark
                                ? const Color(0xFF312E81)
                                : const Color(0xFFE0E7FF)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (name.isNotEmpty)
                            Text(name,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: textMuted)),
                          Text(msg.trim(),
                              style:
                                  TextStyle(fontSize: 14, color: textPrimary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      const Divider(height: 32),
      Expanded(
        child: _buildMultipleChoice(
            ex, isDark, textPrimary, textMuted, cardColor, surfaceColor),
      ),
    ]);
  }

  _ChoiceResult _getChoiceColors(int idx, int correctIdx, bool isDark,
      Color textPrimary, Color textMuted, Color cardColor, Color surfaceColor) {
    Color bg;
    Color textColor;
    Color circleBg;
    Color border = Colors.transparent;
    Color labelColor = textMuted;
    String label = String.fromCharCode(65 + idx);

    if (_selectedAnswer == null) {
      bg = cardColor;
      textColor = textPrimary;
      circleBg = surfaceColor;
    } else if (idx == correctIdx) {
      bg = isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4);
      textColor = isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D);
      circleBg = const Color(0xFF22C55E);
      border = const Color(0xFF22C55E);
      label = '✓';
      labelColor = Colors.white;
    } else if (idx == _selectedAnswer && _isCorrect == false) {
      bg = isDark ? const Color(0xFF450A0A) : const Color(0xFFFFF1F2);
      textColor = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);
      circleBg = const Color(0xFFEF4444);
      border = const Color(0xFFEF4444);
      label = '✗';
      labelColor = Colors.white;
    } else {
      bg = cardColor;
      textColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
      circleBg = surfaceColor;
    }

    return _ChoiceResult(bg, textColor, circleBg, border, label, labelColor);
  }

  // ── RESULTS SCREEN ────────────────────────────────────────────────────────
  /// This function builds the results screen at the end of a session.
  Widget _buildResults(
    bool isDark,
    Color textPrimary,
    Color textMuted,
    Color cardColor,
    List<Exercise> allExercises,
    List<String> weakAreas,
  ) {
    final pct =
        _exercises.isEmpty ? 0 : ((_score / _exercises.length) * 100).round();
    final wrong = _exercises.length - _score;
    final xpEarned = _score * 10;
    final weakestTopic = weakAreas.isNotEmpty ? weakAreas.first : null;

    final ringColor = pct >= 80
        ? const Color(0xFF22C55E)
        : pct >= 50
            ? const Color(0xFFF59E0B)
            : const Color(0xFFEF4444);

    return SafeArea(
      top: false,
      bottom: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _BackButton(
                  isDark: isDark,
                  onTap: () => setState(() => _state = _ExState.select),
                ),
                const SizedBox(width: 12),
                Text(
                  'Result',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: pct / 100,
                      strokeWidth: 12,
                      backgroundColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation(ringColor),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$pct%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      Text(
                        'Result',
                        style: TextStyle(fontSize: 12, color: textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              pct == 100
                  ? '🏆'
                  : pct >= 80
                      ? '🎉'
                      : pct >= 50
                          ? '👍'
                          : '💪',
              style: const TextStyle(fontSize: 34),
            ),
            const SizedBox(height: 6),
            Text(
              pct == 100
                  ? 'Perfect! Incredible!'
                  : pct >= 80
                      ? 'Very well done!'
                      : pct >= 50
                          ? 'Good! Keep practicing!'
                          : 'Do not give up!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _ResultStat(
                    value: '$_score',
                    label: 'Correct',
                    bg: AppTokens.stateSuccessSurface(isDark),
                    fg: AppTokens.stateSuccessForeground(isDark),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ResultStat(
                    value: '$wrong',
                    label: 'Wrong',
                    bg: AppTokens.stateDangerSurface(isDark),
                    fg: AppTokens.stateDangerForeground(isDark),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ResultStat(
                    value: '+$xpEarned',
                    label: 'XP',
                    bg: AppTokens.stateInfoSurface(isDark),
                    fg: AppTokens.stateInfoForeground(isDark),
                  ),
                ),
              ],
            ),
            if (weakestTopic != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next focus',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      weakestTopic,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This topic has recently collected the most incorrect answers.',
                      style: TextStyle(fontSize: 12, color: textMuted),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (pct < 100) ...[
              AppActionButton.custom(
                label: 'Try again',
                onPressed: _retryWrongQuestions,
                icon: Icons.refresh_rounded,
                variant: AppActionButtonVariant.primary,
                backgroundColor: const Color(0xFFFB923C),
                foregroundColor: Colors.white,
                borderColor: Colors.transparent,
                fullWidth: true,
              ),
              const SizedBox(height: 12),
            ],
            if (weakestTopic != null)
              AppActionButton.custom(
                label: 'Practice weak area',
                onPressed: () => _openWeakTopicDestination(weakestTopic),
                icon: Icons.school_rounded,
                variant: AppActionButtonVariant.primary,
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                borderColor: Colors.transparent,
                fullWidth: true,
              ),
            if (weakestTopic != null) const SizedBox(height: 12),
            AppActionButton.secondary(
              label: 'Grammar List',
              onPressed: () => context.go('/grammar'),
              icon: Icons.menu_book_rounded,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(String t) {
    switch (t) {
      case 'multiple-choice':
        return 'Multiple choice';
      case 'fill-blank':
        return 'Fill in the blanks';
      case 'sentence-order':
        return 'Sentence order';
      case 'business-dialog':
        return 'Business dialog';
      default:
        return t;
    }
  }
}

class _ChoiceResult {
  _ChoiceResult(this.bg, this.textColor, this.circleBg, this.border, this.label,
      this.labelColor);
  final Color bg, textColor, circleBg, border, labelColor;
  final String label;
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class AppActionButton extends StatelessWidget {
  const AppActionButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
  })  : variant = AppActionButtonVariant.primary,
        backgroundColor = const Color(0xFF3B82F6),
        foregroundColor = Colors.white,
        borderColor = Colors.transparent;

  const AppActionButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
  })  : variant = AppActionButtonVariant.secondary,
        backgroundColor = Colors.transparent,
        foregroundColor = const Color(0xFF3B82F6),
        borderColor = const Color(0xFF3B82F6);

  const AppActionButton.custom({
    super.key,
    required this.label,
    required this.onPressed,
    required this.variant,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    this.icon,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final AppActionButtonVariant variant;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final child = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: child);
    }
    return child;
  }
}

enum AppActionButtonVariant { primary, secondary }

class _BackButton extends StatelessWidget {
  const _BackButton({required this.isDark, required this.onTap});
  final bool isDark;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              size: 16,
              color:
                  isDark ? const Color(0xFF94A3B8) : const Color(0xFF374151)),
        ),
      );
}

class _ResultStat extends StatelessWidget {
  const _ResultStat(
      {required this.value,
      required this.label,
      required this.bg,
      required this.fg});
  final String value, label;
  final Color bg, fg;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700, color: fg)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(fontSize: 11, color: fg.withOpacity(0.7))),
        ]),
      );
}
