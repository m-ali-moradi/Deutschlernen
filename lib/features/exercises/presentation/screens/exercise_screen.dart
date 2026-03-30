import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
import 'package:deutschmate_mobile/shared/widgets/animated_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/features/exercises/data/models/exercise_type.dart';
import 'package:deutschmate_mobile/features/exercises/domain/exercise_providers.dart';
import '../notifiers/exercise_session_notifier.dart';
import '../widgets/exercise_selection_widgets.dart';
import '../widgets/exercise_session_widgets.dart';
import 'package:deutschmate_mobile/shared/widgets/app_icon_button.dart';

/// widget is the main screen for the exercises section.

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
  bool _didAutoStart = false;

  AppUiText get strings => AppUiText(ref.watch(displayLanguageProvider));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Always enter the general Exercises section in selection mode.
      ref.read(exerciseSessionProvider.notifier).exitToSelection();

      if (exerciseLevels.contains(widget.initialLevel)) {
        ref.read(exerciseLevelProvider.notifier).state = widget.initialLevel;
      }

      // Apply incoming topic/category filters after first frame.
      ref.read(exerciseTopicProvider.notifier).state = widget.initialTopic;
      ref.read(exerciseCategoryProvider.notifier).state =
          widget.initialCategory;

      // Allow a fresh auto-start decision after state reset.
      _didAutoStart = false;
    });
  }

  Future<void> _startSession(String type) async {
    final started =
        await ref.read(exerciseSessionProvider.notifier).startSession(type);
    if (!started && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.exerciseNoExercisesFound())),
      );
      return;
    }
  }

  Future<void> _restartSession() async {
    final started = await ref.read(exerciseSessionProvider.notifier).restartSession();
    if (!started && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.exerciseNoExercisesFound())),
      );
    }
  }

  /// widget to build the main screen
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final exercises = ref.watch(localExercisesProvider);
    final textPrimary = AppTokens.textPrimary(isDark);
    final textMuted = AppTokens.textMuted(isDark);
    final cardColor = AppTokens.surface(isDark);
    final session = ref.watch(exerciseSessionProvider);
    final currentExercise = session.currentExercise;

    return PopScope(
      canPop: session.mode == ExerciseSessionState.select,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (session.mode != ExerciseSessionState.select) {
          ref.read(exerciseSessionProvider.notifier).exitToSelection();
        }
      },
      child: Builder(
        builder: (context) {
          if (widget.autoStart &&
              !_didAutoStart &&
              session.mode == ExerciseSessionState.select &&
              exercises.isNotEmpty) {
            _didAutoStart = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _startSession('all');
            });
          }

          switch (session.mode) {
            case ExerciseSessionState.select:
              return ExerciseSelectionView(
                onStartExercise: _startSession,
                autoStart: widget.autoStart,
                initialTopic: widget.initialTopic,
                initialCategory: widget.initialCategory,
              );
            case ExerciseSessionState.playing:
            case ExerciseSessionState.feedback:
              final ex = currentExercise!;
              return Scaffold(
                extendBodyBehindAppBar: true,
                body: Stack(
                  children: [
                    AppTokens.meshBackground(isDark),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildPlayingHeader(session, isDark, textMuted),
                            const SizedBox(height: 24),
                            QuestionCard(
                              question: _questionTextForSession(session, ex),
                              isDark: isDark,
                              textPrimary: textPrimary,
                              cardColor: cardColor,
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: SingleChildScrollView(
                                child: _buildTypeSpecificContent(
                                  session,
                                  isDark,
                                  textPrimary,
                                  textMuted,
                                  cardColor,
                                ),
                              ),
                            ),
                            if (session.mode ==
                                ExerciseSessionState.feedback) ...[
                              _buildFeedbackBox(session, ex, isDark, strings),
                              const SizedBox(height: 24),
                              _buildNextButton(session, isDark, strings),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            case ExerciseSessionState.results:
              return _buildResultsView(
                session,
                isDark,
                textPrimary,
                textMuted,
                strings,
              );
          }
        },
      ),
    );
  }

  /// widget to build the playing header
  Widget _buildPlayingHeader(
      ExerciseSessionStateModel session, bool isDark, Color textMuted) {
    final progress = (session.currentIndex + 1) / session.exercises.length;
    final ex = session.currentExercise!;
    final formattedType = getExerciseTypeLabel(strings, ex.type);

    return Column(
      children: [
        Row(
          children: [
            AppIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              iconSize: 16,
              onPressed: () =>
                  ref.read(exerciseSessionProvider.notifier).exitToSelection(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ex.topic,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: AppTokens.textPrimary(isDark),
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    formattedType,
                    style: TextStyle(
                      fontSize: 12,
                      color: textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${session.currentIndex + 1}/${session.exercises.length}',
                style: TextStyle(
                  color: AppTokens.textPrimary(isDark).withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        AnimatedProgressBar(
          value: progress,
          height: 8,
          progressColor: const Color(0xFFFB923C),
          backgroundColor: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ],
    );
  }

  /// widget to build the type specific content
  Widget _buildTypeSpecificContent(ExerciseSessionStateModel session,
      bool isDark, Color textPrimary, Color textMuted, Color cardColor) {
    final ex = session.currentExercise!;
    if (ex.type == 'multiple-choice' || ex.type == 'fill-blank') {
      final options = List<String>.from(jsonDecode(ex.optionsJson));
      return MultipleChoiceOptions(
        options: options,
        selectedAnswer: session.selectedAnswer,
        correctAnswer: ex.correctAnswer,
        onOptionSelected:
            ref.read(exerciseSessionProvider.notifier).answerMultipleChoice,
        isDark: isDark,
        textPrimary: textPrimary,
        cardColor: cardColor,
      );
    } else if (ex.type == 'sentence-order') {
      return SentenceOrderWidget(
        userOrder: session.userOrder,
        availableWords: session.availableWords,
        onWordAdded: ref.read(exerciseSessionProvider.notifier).addSentenceWord,
        onWordRemoved:
            ref.read(exerciseSessionProvider.notifier).removeSentenceWord,
        isDark: isDark,
        cardColor: cardColor,
        textPrimary: textPrimary,
      );
    }
    return const Center(child: Text('Unsupported exercise type'));
  }

  /// widget to build the question text
  String _questionTextForSession(
    ExerciseSessionStateModel session,
    Exercise exercise,
  ) {
    if (exercise.type != 'sentence-order') {
      return exercise.question;
    }

    if (session.mode == ExerciseSessionState.feedback) {
      return exercise.question;
    }

    return strings.exerciseSentenceOrderPrompt();
  }

  /// widget to build the feedback box
  Widget _buildFeedbackBox(ExerciseSessionStateModel session, Exercise ex,
      bool isDark, AppUiText strings) {
    final isCorrect = session.isCorrect == true;

    return PremiumCard(
      useGlass: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: isCorrect
          ? (isDark
              ? const Color(0xFF064E3B).withValues(alpha: 0.3)
              : const Color(0xFFD1FAE5).withValues(alpha: 0.6))
          : (isDark
              ? const Color(0xFF7F1D1D).withValues(alpha: 0.3)
              : const Color(0xFFFEE2E2).withValues(alpha: 0.6)),
      borderOpacity: 0.2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCorrect
                  ? const Color(0xFF10B981).withValues(alpha: 0.15)
                  : const Color(0xFFEF4444).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              isCorrect ? '🎉' : '💡',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isCorrect
                      ? strings.exerciseCorrect()
                      : strings.either(german: 'Falsch', english: 'Incorrect'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: (isCorrect
                            ? AppTokens.stateSuccessForeground(isDark)
                            : AppTokens.stateDangerForeground(isDark))
                        .withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCorrect
                      ? (session.isPreviouslyAnswered
                          ? strings.exerciseAlreadyAnswered()
                          : strings.exerciseCorrect())
                      : ex.type == 'multiple-choice' || ex.type == 'fill-blank'
                          ? strings.exerciseIncorrectCorrect(
                              String.fromCharCode(65 + ex.correctAnswer),
                            )
                          : strings.exerciseIncorrectCorrect(ex.question),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isCorrect
                        ? AppTokens.stateSuccessForeground(isDark)
                        : AppTokens.stateDangerForeground(isDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// widget to build the next button
  Widget _buildNextButton(
      ExerciseSessionStateModel session, bool isDark, AppUiText strings) {
    final isLastQuestion = session.currentIndex + 1 >= session.exercises.length;
    final label = isLastQuestion ? strings.exerciseFinish() : strings.exerciseNext();

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppTokens.gradientBluePurple,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              ref.read(exerciseSessionProvider.notifier).nextQuestion(),
          borderRadius: BorderRadius.circular(18),
            child: Center(
              child: Text(
                label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// widget to build the results view
  Widget _buildResultsView(ExerciseSessionStateModel session, bool isDark,
      Color textPrimary, Color textMuted, AppUiText strings) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          AppTokens.meshBackground(isDark),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: PremiumCard(
                  padding: const EdgeInsets.all(32),
                  useGlass: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 24),
                      Text(
                        strings.exerciseSessionComplete(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: textPrimary,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        strings.exerciseScoreLabel(
                            session.score, session.exercises.length),
                        style: TextStyle(
                          fontSize: 18,
                          color: textMuted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppTokens.gradientBluePurple,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1)
                                    .withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _restartSession,
                              borderRadius: BorderRadius.circular(18),
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  child: Text(
                                    strings.exerciseTryAgain().toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => ref
                              .read(exerciseSessionProvider.notifier)
                              .exitToSelection(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.14)
                                  : Colors.black.withValues(alpha: 0.08),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(strings.either(
                            german: 'Zur Übungsauswahl',
                            english: 'Back to exercise list',
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
