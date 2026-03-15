import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';

enum _ExerciseType { multipleChoice, matching, fillBlank }

enum _SessionStage { pickType, playing, feedback, results }

class ExercisePage extends ConsumerStatefulWidget {
  const ExercisePage({super.key});

  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage> {
  late final ConfettiController _confetti;

  _SessionStage _stage = _SessionStage.pickType;
  _ExerciseType? _selectedType;
  List<Exercise> _activeExercises = const [];
  int _index = 0;
  int _selectedOption = -1;
  bool? _lastCorrect;
  int _correctCount = 0;

  bool _isMultipleChoiceType(String type) {
    final normalized = type.toLowerCase().replaceAll('_', '-').trim();
    return normalized == 'multiple-choice' ||
        normalized == 'multiple choice' ||
        normalized == 'mcq';
  }

  bool _isMatchingType(String type) {
    final normalized = type.toLowerCase().replaceAll('_', '-').trim();
    return normalized == 'matching' ||
        normalized == 'sentence-order' ||
        normalized == 'sentence order';
  }

  bool _isFillBlankType(String type) {
    final normalized = type.toLowerCase().replaceAll('_', '-').trim();
    return normalized == 'fill-in-blank' ||
        normalized == 'fill-blank' ||
        normalized == 'fill in blank';
  }

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _startSession(_ExerciseType type, List<Exercise> exercises) {
    setState(() {
      _selectedType = type;
      _activeExercises = exercises;
      _index = 0;
      _selectedOption = -1;
      _lastCorrect = null;
      _correctCount = 0;
      _stage = _SessionStage.playing;
    });
  }

  void _submitAnswer() {
    if (_selectedOption < 0 || _activeExercises.isEmpty) return;

    final current = _activeExercises[_index];
    final isCorrect = current.correctAnswer == _selectedOption;

    setState(() {
      _lastCorrect = isCorrect;
      if (isCorrect) _correctCount += 1;
      _stage = _SessionStage.feedback;
    });
  }

  Future<void> _nextOrFinish() async {
    final isLast = _index >= _activeExercises.length - 1;
    if (!isLast) {
      setState(() {
        _index += 1;
        _selectedOption = -1;
        _lastCorrect = null;
        _stage = _SessionStage.playing;
      });
      return;
    }

    await ref.read(appSettingsActionsProvider).recordExerciseOutcome(
          correctAnswers: _correctCount,
          total: _activeExercises.length,
        );

    final ratio = _activeExercises.isEmpty
        ? 0.0
        : _correctCount / _activeExercises.length;
    if (ratio >= 0.8) {
      _confetti.play();
    }

    if (!mounted) return;
    setState(() => _stage = _SessionStage.results);
  }

  void _restart() {
    setState(() {
      _stage = _SessionStage.pickType;
      _selectedType = null;
      _activeExercises = const [];
      _index = 0;
      _selectedOption = -1;
      _lastCorrect = null;
      _correctCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesStreamProvider);

    if (exercisesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (exercisesAsync.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 44),
              const SizedBox(height: 10),
              const Text('Failed to load exercises'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(exercisesStreamProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final all = exercisesAsync.value!;
    final multipleChoice =
        all.where((e) => _isMultipleChoiceType(e.type)).toList();
    final matching = all.where((e) => _isMatchingType(e.type)).toList();
    final fillBlank = all.where((e) => _isFillBlankType(e.type)).toList();

    Future<void> onSelectType(
      _ExerciseType type,
      List<Exercise> exercises,
    ) async {
      if (exercises.isEmpty) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        messenger?.showSnackBar(
          const SnackBar(
            content: Text('No exercises found for this type yet.'),
          ),
        );
        return;
      }
      _startSession(type, exercises);
    }

    final current =
        _activeExercises.isNotEmpty ? _activeExercises[_index] : null;
    final progress =
        _activeExercises.isEmpty ? 0.0 : (_index + 1) / _activeExercises.length;

    Widget stageContent = const SizedBox.shrink();
    if (_stage == _SessionStage.pickType) {
      if (all.isEmpty) {
        stageContent = _NoExercisesView(
          onRepair: () async {
            final messenger = ScaffoldMessenger.maybeOf(context);
            await ref.read(appSettingsActionsProvider).reseedContent();
            if (!mounted) return;
            messenger?.showSnackBar(
              const SnackBar(
                content: Text('Exercise data repaired. Please try again.'),
              ),
            );
          },
        );
      } else {
        stageContent = _PickTypeView(
          multipleChoiceCount: multipleChoice.length,
          matchingCount: matching.length,
          fillBlankCount: fillBlank.length,
          onSelect: (type) async {
            switch (type) {
              case _ExerciseType.multipleChoice:
                await onSelectType(type, multipleChoice);
                break;
              case _ExerciseType.matching:
                await onSelectType(type, matching);
                break;
              case _ExerciseType.fillBlank:
                await onSelectType(type, fillBlank);
                break;
            }
          },
        );
      }
    } else if (_stage == _SessionStage.playing && current != null) {
      stageContent = _QuestionView(
        type: _selectedType!,
        index: _index + 1,
        total: _activeExercises.length,
        progress: progress,
        question: current.question,
        explanation: 'Topic: ${current.topic} • Level: ${current.level}',
        options: (jsonDecode(current.optionsJson) as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        selectedOption: _selectedOption,
        onSelectOption: (value) => setState(() => _selectedOption = value),
        onSubmit: _submitAnswer,
      );
    } else if (_stage == _SessionStage.feedback && current != null) {
      stageContent = _FeedbackView(
        isCorrect: _lastCorrect ?? false,
        correctAnswer: current.correctAnswer,
        options: (jsonDecode(current.optionsJson) as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        explanation: 'Topic: ${current.topic} • Level: ${current.level}',
        onContinue: _nextOrFinish,
      );
    } else if (_stage == _SessionStage.results) {
      stageContent = _ResultsView(
        type: _selectedType,
        correct: _correctCount,
        total: _activeExercises.length,
        onRestart: _restart,
      );
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ConfettiWidget(
          confettiController: _confetti,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          numberOfParticles: 24,
          gravity: 0.2,
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF97316),
                        Color(0xFFEA580C),
                        Color(0xFFDB2777)
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEA580C).withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Uebungen 🎯',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.white)),
                      Text('Interactive business German practice',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.02, 0.03),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey(
                        '${_stage.name}-$_index-${_selectedType?.name ?? 'none'}'),
                    child: stageContent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NoExercisesView extends StatelessWidget {
  const _NoExercisesView({required this.onRepair});

  final Future<void> Function() onRepair;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No exercises available right now.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap Repair to re-seed exercise content into your local database.',
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRepair,
            child: const Text('Repair Exercises'),
          ),
        ],
      ),
    );
  }
}

class _PickTypeView extends StatelessWidget {
  const _PickTypeView({
    required this.multipleChoiceCount,
    required this.matchingCount,
    required this.fillBlankCount,
    required this.onSelect,
  });

  final int multipleChoiceCount;
  final int matchingCount;
  final int fillBlankCount;
  final ValueChanged<_ExerciseType> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFFFB923C), Color(0xFFF97316)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF97316).withValues(alpha: 0.28),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Text(
            'Wahle einen Ubungstyp und sammle XP fur jede richtige Antwort.',
            style: TextStyle(color: Colors.white),
          ),
        ),
        _TypeCard(
          title: 'Multiple Choice Quiz',
          subtitle: '$multipleChoiceCount questions',
          colorA: const Color(0xFF3B82F6),
          colorB: const Color(0xFF2563EB),
          icon: Icons.quiz_rounded,
          onTap: () => onSelect(_ExerciseType.multipleChoice),
        ),
        const SizedBox(height: 10),
        _TypeCard(
          title: 'Matching Exercise',
          subtitle: '$matchingCount questions',
          colorA: const Color(0xFF10B981),
          colorB: const Color(0xFF059669),
          icon: Icons.compare_arrows_rounded,
          onTap: () => onSelect(_ExerciseType.matching),
        ),
        const SizedBox(height: 10),
        _TypeCard(
          title: 'Fill-in-the-Blank',
          subtitle: '$fillBlankCount questions',
          colorA: const Color(0xFFF59E0B),
          colorB: const Color(0xFFD97706),
          icon: Icons.edit_note_rounded,
          onTap: () => onSelect(_ExerciseType.fillBlank),
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.title,
    required this.subtitle,
    required this.colorA,
    required this.colorB,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color colorA;
  final Color colorB;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [colorA, colorB]),
          boxShadow: [
            BoxShadow(
              color: colorB.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    required this.type,
    required this.index,
    required this.total,
    required this.progress,
    required this.question,
    required this.explanation,
    required this.options,
    required this.selectedOption,
    required this.onSelectOption,
    required this.onSubmit,
  });

  final _ExerciseType type;
  final int index;
  final int total;
  final double progress;
  final String question;
  final String explanation;
  final List<String> options;
  final int selectedOption;
  final ValueChanged<int> onSelectOption;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final typeLabel = switch (type) {
      _ExerciseType.multipleChoice => 'Multiple Choice Quiz',
      _ExerciseType.matching => 'Matching Exercise',
      _ExerciseType.fillBlank => 'Fill in the Blank',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(typeLabel, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Row(
          children: [
            Text('Question $index of $total'),
            const Spacer(),
            Text('${(progress * 100).round()}%'),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(value: progress, minHeight: 8),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(question, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(explanation,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onSelectOption(i),
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: selectedOption == i
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerLow,
                  border: Border.all(
                    color: selectedOption == i
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                    width: selectedOption == i ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    if (selectedOption == i)
                      Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: theme.colorScheme.primary,
                      )
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${i + 1}. ${options[i]}',
                        style: TextStyle(
                          color: selectedOption == i
                              ? theme.colorScheme.onPrimaryContainer
                              : (isDark ? Colors.white : null),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: selectedOption < 0 ? null : onSubmit,
            child: const Text('Submit Answer'),
          ),
        ),
      ],
    );
  }
}

class _FeedbackView extends StatelessWidget {
  const _FeedbackView({
    required this.isCorrect,
    required this.correctAnswer,
    required this.options,
    required this.explanation,
    required this.onContinue,
  });

  final bool isCorrect;
  final int correctAnswer;
  final List<String> options;
  final String explanation;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final icon = isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final title = isCorrect ? 'Richtig!' : 'Nicht ganz';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 10),
          if (!isCorrect)
            Text('Correct answer: ${options[correctAnswer]}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
          if (!isCorrect) const SizedBox(height: 6),
          Text(explanation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onContinue,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.type,
    required this.correct,
    required this.total,
    required this.onRestart,
  });

  final _ExerciseType? type;
  final int correct;
  final int total;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : correct / total;
    final stars = (ratio * 3).ceil().clamp(1, 3);
    final xp = correct * 10;
    final label = switch (type) {
      _ExerciseType.multipleChoice => 'Multiple Choice Quiz',
      _ExerciseType.matching => 'Matching Exercise',
      _ExerciseType.fillBlank => 'Fill in the Blank',
      null => 'Exercise',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6D28D9).withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Exercise Complete!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Text(
            '$correct / $total',
            style: const TextStyle(
                color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 3; i++)
                Icon(
                  i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                  color: const Color(0xFFFBBF24),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text('+$xp XP earned', style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              onPressed: onRestart,
              child: const Text('Try Another Exercise'),
            ),
          ),
        ],
      ),
    );
  }
}
