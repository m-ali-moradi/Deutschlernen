import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/features/exercises/data/models/exercise_type.dart';
import 'package:deutschmate_mobile/features/exercises/domain/exercise_providers.dart';
import 'package:deutschmate_mobile/features/exercises/presentation/widgets/exercise_session_widgets.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
import 'package:deutschmate_mobile/shared/widgets/animated_progress_bar.dart';
import 'package:deutschmate_mobile/shared/widgets/app_icon_button.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import '../notifiers/grammar_topic_exercise_session_notifier.dart';

class GrammarTopicExerciseScreen extends ConsumerStatefulWidget {
  const GrammarTopicExerciseScreen({
    super.key,
    required this.topicId,
    required this.topicTitle,
    required this.topicCategory,
    required this.topicLevel,
    this.backLevel = 'Alle',
    this.backCategory = 'Alle',
    this.backShowFilters = false,
  });

  final String topicId;
  final String topicTitle;
  final String topicCategory;
  final String topicLevel;
  final String backLevel;
  final String backCategory;
  final bool backShowFilters;

  @override
  ConsumerState<GrammarTopicExerciseScreen> createState() =>
      _GrammarTopicExerciseScreenState();
}

class _GrammarTopicExerciseScreenState
    extends ConsumerState<GrammarTopicExerciseScreen> {
  bool _didStart = false;
  bool _hasNoExercises = false;

  GrammarTopicExerciseSessionRequest get _request =>
      GrammarTopicExerciseSessionRequest(
        topicId: widget.topicId,
        topicTitle: widget.topicTitle,
        topicCategory: widget.topicCategory,
        topicLevel: widget.topicLevel,
      );

  @override
  void initState() {
    super.initState();
  }

  Future<void> _startIfNeeded() async {
    if (_didStart) return;
    _didStart = true;
    final started = await ref
        .read(grammarTopicExerciseSessionProvider(_request).notifier)
        .startSession();
    if (!started && mounted) {
      setState(() => _hasNoExercises = true);
    }
  }

  void _goBackToDetail() {
    ref
        .read(grammarTopicExerciseSessionProvider(_request).notifier)
        .exitToSelection();

    if (context.canPop()) {
      context.pop();
    } else {
      final uri = Uri(
        path: '/grammar/${widget.topicId}',
        queryParameters: {
          'level': widget.backLevel,
          'category': widget.backCategory,
          'showFilters': widget.backShowFilters ? '1' : '0',
        },
      );
      context.go(uri.toString());
    }
  }

  void _goBackToGrammarList() {
    ref
        .read(grammarTopicExerciseSessionProvider(_request).notifier)
        .exitToSelection();

    final uri = Uri(
      path: '/grammar',
      queryParameters: {
        'level': widget.backLevel,
        'category': widget.backCategory,
        'showFilters': widget.backShowFilters ? '1' : '0',
      },
    );
    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(grammarTopicExerciseSessionProvider(_request));
    final exercises = ref.watch(localExercisesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = AppTokens.textPrimary(isDark);
    final textMuted = AppTokens.textMuted(isDark);
    final cardColor = AppTokens.surface(isDark);
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _goBackToDetail();
      },
      child: Builder(
        builder: (context) {
          if (!_didStart && !_hasNoExercises) {
            if (exercises.isEmpty) {
              _hasNoExercises = true;
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _startIfNeeded();
              });
            }
          }

          if (_hasNoExercises) {
            return Scaffold(
              body: Stack(
                children: [
                  AppTokens.meshBackground(isDark),
                  Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leadingWidth: 56,
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: AppIconButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            iconSize: 16,
                            onPressed: _goBackToDetail,
                          ),
                        ),
                        title: Text(
                          widget.topicTitle,
                          style: AppTokens.appBarTitleStyle(context, isDark),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            strings.exerciseNoExercisesFoundForTopic(),
                            style: TextStyle(color: textMuted),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          if (session.mode == ExerciseSessionState.results) {
            return _buildResultsView(
              session,
              isDark,
              textPrimary,
              textMuted,
              strings,
            );
          }

          final ex = session.currentExercise;
          if (ex == null) {
            return Scaffold(
              body: Stack(
                children: [
                  AppTokens.meshBackground(isDark),
                  const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          }

          return Scaffold(
            body: Stack(
              children: [
                AppTokens.meshBackground(isDark),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: _buildHeader(session, isDark, textMuted),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
                          child: Column(
                            children: [
                              QuestionCard(
                                question: (ex.type == 'sentence-order' &&
                                        session.mode !=
                                            ExerciseSessionState.feedback)
                                    ? strings.exerciseSentenceOrderPrompt()
                                    : ex.question,
                                isDark: isDark,
                                textPrimary: textPrimary,
                                cardColor: cardColor,
                              ),
                              const SizedBox(height: 24),
                              _buildTypeSpecificContent(
                                session,
                                isDark,
                                textPrimary,
                                cardColor,
                                strings,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (session.mode == ExerciseSessionState.feedback)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: _buildFeedbackArea(session, ex, isDark, strings),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(GrammarTopicExerciseSessionStateModel session,
      bool isDark, Color textMuted) {
    final progress = session.exercises.isEmpty
        ? 0.0
        : (session.currentIndex + 1) / session.exercises.length;

    return Column(
      children: [
        Row(
          children: [
            AppIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              iconSize: 16,
              onPressed: _goBackToDetail,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.topicTitle,
                    style: AppTokens.appBarTitleStyle(context, isDark)
                        .copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.topicCategory,
                    style: AppTokens.subheadingStyle(context, isDark)
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
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

  Widget _buildTypeSpecificContent(
    GrammarTopicExerciseSessionStateModel session,
    bool isDark,
    Color textPrimary,
    Color cardColor,
    AppUiText strings,
  ) {
    final ex = session.currentExercise!;

    if (ex.type == 'multiple-choice' || ex.type == 'fill-blank') {
      final options = List<String>.from(jsonDecode(ex.optionsJson));
      return MultipleChoiceOptions(
        options: options,
        selectedAnswer: session.selectedAnswer,
        correctAnswer: ex.correctAnswer,
        onOptionSelected: ref
            .read(grammarTopicExerciseSessionProvider(_request).notifier)
            .answerMultipleChoice,
        isDark: isDark,
        textPrimary: textPrimary,
        cardColor: cardColor,
      );
    }

    if (ex.type == 'sentence-order') {
      return SentenceOrderWidget(
        userOrder: session.userOrder,
        availableWords: session.availableWords,
        onWordAdded: ref
            .read(grammarTopicExerciseSessionProvider(_request).notifier)
            .addSentenceWord,
        onWordRemoved: ref
            .read(grammarTopicExerciseSessionProvider(_request).notifier)
            .removeSentenceWord,
        isDark: isDark,
        cardColor: cardColor,
        textPrimary: textPrimary,
      );
    }

    return Center(
        child: Text(strings.exerciseUnsupportedType(),
            style: TextStyle(color: textPrimary)));
  }

  Widget _buildFeedbackArea(
    GrammarTopicExerciseSessionStateModel session,
    Exercise ex,
    bool isDark,
    AppUiText strings,
  ) {
    final isCorrect = session.isCorrect == true;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PremiumCard(
          useGlass: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: isCorrect
              ? (isDark
                  ? const Color(0xFF064E3B).withValues(alpha: 0.5)
                  : const Color(0xFFD1FAE5).withValues(alpha: 0.95))
              : (isDark
                  ? const Color(0xFF7F1D1D).withValues(alpha: 0.5)
                  : const Color(0xFFFEE2E2).withValues(alpha: 0.95)),
          borderOpacity: isDark ? 0.3 : 0.6,
          shadowOpacity: isDark ? 0.1 : 0.2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                      : const Color(0xFFEF4444).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  isCorrect ? '🎉' : '💡',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isCorrect
                        ? AppTokens.stateSuccessForeground(isDark)
                        : AppTokens.stateDangerForeground(isDark),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppTokens.gradientBluePurple,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => ref
                  .read(grammarTopicExerciseSessionProvider(_request).notifier)
                  .nextQuestion(),
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Text(
                  strings.exerciseNext().toUpperCase(),
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
        ),
      ],
    );
  }

  Widget _buildResultsView(
    GrammarTopicExerciseSessionStateModel session,
    bool isDark,
    Color textPrimary,
    Color textMuted,
    AppUiText strings,
  ) {
    final pct = session.progressPercent;
    final wrong = session.exercises.length - session.score;
    final xpEarned = session.score * 10;

    final ringColor = pct >= 80
        ? const Color(0xFF22C55E)
        : pct >= 50
            ? const Color(0xFFF59E0B)
            : const Color(0xFFEF4444);

    return Scaffold(
      body: Stack(
        children: [
          AppTokens.meshBackground(isDark),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      AppIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        iconSize: 16,
                        onPressed: _goBackToGrammarList,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        strings.exerciseResultTitle(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  PremiumCard(
                    useGlass: true,
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 140,
                                height: 140,
                                child: CircularProgressIndicator(
                                  value: pct / 100,
                                  strokeWidth: 10,
                                  backgroundColor: isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : Colors.black.withValues(alpha: 0.05),
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
                                      fontWeight: FontWeight.w900,
                                      color: textPrimary,
                                    ),
                                  ),
                                  Text(
                                    strings.exerciseResultTitle().toLowerCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          pct == 100
                              ? strings.either(
                                  german: 'Perfekt!', english: 'Perfect!')
                              : pct >= 80
                                  ? strings.either(
                                      german: 'Sehr gut!',
                                      english: 'Very good!')
                                  : strings.either(
                                      german: 'Gut gemacht!',
                                      english: 'Well done!'),
                          style: AppTokens.appBarTitleStyle(context, isDark)
                              .copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _ResultStat(
                                value: '${session.score}',
                                label: 'Richtig',
                                fg: const Color(0xFF10B981),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ResultStat(
                                value: '$wrong',
                                label: 'Falsch',
                                fg: const Color(0xFFEF4444),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ResultStat(
                                value: '+$xpEarned',
                                label: 'XP',
                                fg: const Color(0xFF6366F1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Action Buttons
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppTokens.gradientBluePurple,
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
                        onTap: () async {
                          final started = await ref
                              .read(
                                  grammarTopicExerciseSessionProvider(_request)
                                      .notifier)
                              .retryIncorrectExercises();
                          if (!started && mounted) {
                            setState(() => _hasNoExercises = true);
                          }
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.refresh_rounded,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                strings.exerciseTryAgain().toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PremiumCard(
                    onTap: _goBackToGrammarList,
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      alignment: Alignment.center,
                      child: Text(
                        strings.isGerman ? 'Zurück zur Grammatik' : 'Back to grammar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({
    required this.value,
    required this.label,
    required this.fg,
  });

  final String value;
  final String label;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: fg,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: fg.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
