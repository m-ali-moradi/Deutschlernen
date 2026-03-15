import 'dart:convert';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/progress_ring.dart';

enum _ExerciseStage { select, playing, feedback, results }

class ExercisePage extends ConsumerStatefulWidget {
  const ExercisePage({super.key});

  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage> {
  late final ConfettiController _confetti;

  _ExerciseStage _stage = _ExerciseStage.select;
  String _selectedLevel = 'Alle';
  String _selectedType = 'all';
  List<Exercise> _activeExercises = const [];
  int _index = 0;
  int? _selectedAnswer;
  bool? _isCorrect;
  int _score = 0;
  final List<bool> _answers = [];

  static const _levelFilters = ['Alle', 'A1', 'A2', 'B1', 'B2'];

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

  String _normalizeType(String type) {
    return type.toLowerCase().replaceAll('_', '-').trim();
  }

  void _startSession(String type, List<Exercise> all) {
    var filtered = all;
    if (type != 'all') {
      filtered = all.where((e) => _normalizeType(e.type) == type).toList();
    }
    if (_selectedLevel != 'Alle') {
      filtered = filtered.where((e) => e.level == _selectedLevel).toList();
    }
    if (filtered.isEmpty) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        const SnackBar(content: Text('Keine passenden Übungen gefunden.')),
      );
      return;
    }
    filtered.shuffle(math.Random());
    setState(() {
      _selectedType = type;
      _activeExercises = filtered;
      _index = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _score = 0;
      _answers.clear();
      _stage = _ExerciseStage.playing;
    });
  }

  void _handleAnswer(int index) {
    if (_selectedAnswer != null || _activeExercises.isEmpty) return;
    final current = _activeExercises[_index];
    final correct = index == current.correctAnswer;
    setState(() {
      _selectedAnswer = index;
      _isCorrect = correct;
      if (correct) _score += 1;
      _answers.add(correct);
      _stage = _ExerciseStage.feedback;
    });
  }

  Future<void> _nextQuestion() async {
    if (_activeExercises.isEmpty) return;
    final isLast = _index >= _activeExercises.length - 1;
    if (!isLast) {
      setState(() {
        _index += 1;
        _selectedAnswer = null;
        _isCorrect = null;
        _stage = _ExerciseStage.playing;
      });
      return;
    }

    await ref.read(appSettingsActionsProvider).recordExerciseOutcome(
          correctAnswers: _score,
          total: _activeExercises.length,
        );

    final percentage = _activeExercises.isEmpty
        ? 0
        : ((_score / _activeExercises.length) * 100).round();
    if (percentage == 100) {
      _confetti.play();
    }

    if (!mounted) return;
    setState(() => _stage = _ExerciseStage.results);
  }

  void _restart() {
    setState(() {
      _stage = _ExerciseStage.select;
      _selectedType = 'all';
      _activeExercises = const [];
      _index = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _score = 0;
      _answers.clear();
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
    final typeOptions = _buildTypeOptions(all);

    Widget content;
    switch (_stage) {
      case _ExerciseStage.select:
        content = _SelectView(
          selectedLevel: _selectedLevel,
          levels: _levelFilters,
          typeOptions: typeOptions,
          onSelectLevel: (level) => setState(() => _selectedLevel = level),
          onSelectType: (type) => _startSession(type, all),
          onBack: () => context.go('/'),
        );
        break;
      case _ExerciseStage.playing:
      case _ExerciseStage.feedback:
        final current = _activeExercises.isNotEmpty
            ? _activeExercises[_index]
            : null;
        if (current == null) {
          content = const SizedBox.shrink();
          break;
        }
        content = _PlayingView(
          stage: _stage,
          currentIndex: _index,
          total: _activeExercises.length,
          exercise: current,
          selectedAnswer: _selectedAnswer,
          isCorrect: _isCorrect,
          onBack: () => setState(() => _stage = _ExerciseStage.select),
          onSelectAnswer: _handleAnswer,
          onContinue: _nextQuestion,
        );
        break;
      case _ExerciseStage.results:
        content = _ResultsView(
          score: _score,
          total: _activeExercises.length,
          exercises: _activeExercises,
          answers: _answers,
          onRestart: _restart,
          onHome: () => context.go('/'),
        );
        break;
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
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(
            key: ValueKey(_stage),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    content,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<_TypeOption> _buildTypeOptions(List<Exercise> all) {
    final counts = <String, int>{};
    for (final exercise in all) {
      final normalized = _normalizeType(exercise.type);
      counts[normalized] = (counts[normalized] ?? 0) + 1;
    }

    final options = <_TypeOption>[
      _TypeOption(
        type: 'all',
        label: 'Alle Übungen',
        icon: '📝',
        gradient: const [Color(0xFF3B82F6), Color(0xFF7C3AED)],
        count: all.length,
      ),
    ];

    for (final entry in counts.entries) {
      options.add(_typeOptionFor(entry.key, entry.value));
    }

    return options;
  }

  _TypeOption _typeOptionFor(String type, int count) {
    switch (type) {
      case 'multiple-choice':
        return _TypeOption(
          type: type,
          label: 'Multiple Choice',
          icon: '🔘',
          gradient: const [Color(0xFF818CF8), Color(0xFF6366F1)],
          count: count,
        );
      case 'fill-in-blank':
      case 'fill-blank':
        return _TypeOption(
          type: type,
          label: 'Lückentext',
          icon: '✍️',
          gradient: const [Color(0xFF2DD4BF), Color(0xFF0D9488)],
          count: count,
        );
      case 'sentence-order':
        return _TypeOption(
          type: type,
          label: 'Satzordnung',
          icon: '🔀',
          gradient: const [Color(0xFFFBBF24), Color(0xFFD97706)],
          count: count,
        );
      case 'matching':
        return _TypeOption(
          type: type,
          label: 'Matching',
          icon: '🧩',
          gradient: const [Color(0xFF34D399), Color(0xFF059669)],
          count: count,
        );
      case 'business-dialog':
        return _TypeOption(
          type: type,
          label: 'Business Dialog',
          icon: '💼',
          gradient: const [Color(0xFFFB7185), Color(0xFFF43F5E)],
          count: count,
        );
      default:
        return _TypeOption(
          type: type,
          label: type,
          icon: '📝',
          gradient: const [Color(0xFF94A3B8), Color(0xFF64748B)],
          count: count,
        );
    }
  }
}

class _TypeOption {
  const _TypeOption({
    required this.type,
    required this.label,
    required this.icon,
    required this.gradient,
    required this.count,
  });

  final String type;
  final String label;
  final String icon;
  final List<Color> gradient;
  final int count;
}

class _SelectView extends StatelessWidget {
  const _SelectView({
    required this.selectedLevel,
    required this.levels,
    required this.typeOptions,
    required this.onSelectLevel,
    required this.onSelectType,
    required this.onBack,
  });

  final String selectedLevel;
  final List<String> levels;
  final List<_TypeOption> typeOptions;
  final ValueChanged<String> onSelectLevel;
  final ValueChanged<String> onSelectType;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _IconButton(
              icon: Icons.arrow_back_rounded,
              onPressed: onBack,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Übungen ✏️',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isDark
                              ? AppTokens.darkText
                              : AppTokens.lightText,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tests & Quiz',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppTokens.darkTextMuted
                              : AppTokens.lightTextMuted,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: levels.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final level = levels[index];
              return _LevelChip(
                label: level,
                selected: selectedLevel == level,
                onTap: () => onSelectLevel(level),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Übungstypen',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark ? AppTokens.darkText : AppTokens.lightText,
              ),
        ),
        const SizedBox(height: 12),
        for (final option in typeOptions)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TypeCard(
              option: option,
              onTap: () => onSelectType(option.type),
            ),
          ),
        const SizedBox(height: 8),
        _TipsCard(),
      ],
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFFFB923C), Color(0xFFF97316)],
                )
              : null,
          color: selected
              ? null
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFF97316).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : (isDark
                    ? const Color(0xFFCBD5F5)
                    : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({required this.option, required this.onTap});

  final _TypeOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppTokens.radius20,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTokens.radius20,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: AppTokens.radius20,
            gradient: LinearGradient(colors: option.gradient),
            boxShadow: [
              BoxShadow(
                color: option.gradient.last.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(option.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${option.count} Fragen',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTokens.darkCard : AppTokens.lightCard,
        borderRadius: AppTokens.radius30,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tipps',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark ? AppTokens.darkText : AppTokens.lightText,
                ),
          ),
          const SizedBox(height: 12),
          _TipRow(
            color: const Color(0xFF3B82F6),
            icon: Icons.track_changes_rounded,
            text: 'Lies die Frage sorgfältig durch',
          ),
          const SizedBox(height: 10),
          _TipRow(
            color: const Color(0xFF22C55E),
            icon: Icons.bolt_rounded,
            text: 'Jede richtige Antwort = +10 XP',
          ),
          const SizedBox(height: 10),
          _TipRow(
            color: const Color(0xFFF59E0B),
            icon: Icons.warning_amber_rounded,
            text: '100% Score = Konfetti-Belohnung!',
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({
    required this.color,
    required this.icon,
    required this.text,
  });

  final Color color;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isDark ? color.withValues(alpha: 0.2) : color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppTokens.darkTextMuted
                      : AppTokens.lightTextMuted,
                ),
          ),
        ),
      ],
    );
  }
}

class _PlayingView extends StatelessWidget {
  const _PlayingView({
    required this.stage,
    required this.currentIndex,
    required this.total,
    required this.exercise,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.onBack,
    required this.onSelectAnswer,
    required this.onContinue,
  });

  final _ExerciseStage stage;
  final int currentIndex;
  final int total;
  final Exercise exercise;
  final int? selectedAnswer;
  final bool? isCorrect;
  final VoidCallback onBack;
  final ValueChanged<int> onSelectAnswer;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = total == 0 ? 0.0 : (currentIndex + 1) / total;
    final options = (jsonDecode(exercise.optionsJson) as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    final typeLabel = _typeLabelFor(exercise.type);
    final typeIcon = _typeIconFor(exercise.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _IconButton(icon: Icons.arrow_back_rounded, onPressed: onBack),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor:
                      isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFF97316),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${currentIndex + 1}/$total',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppTokens.darkTextMuted
                        : AppTokens.lightTextMuted,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Text(typeIcon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                typeLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppTokens.darkTextMuted
                          : AppTokens.lightTextMuted,
                    ),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E3A8A).withValues(alpha: 0.35)
                    : const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                exercise.level,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? const Color(0xFFBFDBFE)
                      : const Color(0xFF1D4ED8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppTokens.darkCard : AppTokens.lightCard,
            borderRadius: AppTokens.radius30,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            exercise.question,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark ? AppTokens.darkText : AppTokens.lightText,
                ),
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AnswerOption(
              index: i,
              label: options[i],
              selectedAnswer: selectedAnswer,
              correctAnswer: exercise.correctAnswer,
              isCorrect: isCorrect,
              onTap: stage == _ExerciseStage.playing
                  ? () => onSelectAnswer(i)
                  : null,
            ),
          ),
        const SizedBox(height: 6),
        if (stage == _ExerciseStage.feedback)
          _FeedbackFooter(
            isCorrect: isCorrect ?? false,
            correctAnswer: options[exercise.correctAnswer],
            onContinue: onContinue,
          ),
      ],
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.index,
    required this.label,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.onTap,
  });

  final int index;
  final String label;
  final int? selectedAnswer;
  final int correctAnswer;
  final bool? isCorrect;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg = isDark ? const Color(0xFF1E293B) : Colors.white;
    Color border = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    Color text = isDark ? AppTokens.darkText : AppTokens.lightText;
    Color circleBg = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    Color circleText =
        isDark ? const Color(0xFFCBD5F5) : const Color(0xFF64748B);

    if (selectedAnswer != null) {
      if (index == correctAnswer) {
        bg = isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5);
        border = const Color(0xFF10B981);
        text = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857);
        circleBg = const Color(0xFF10B981);
        circleText = Colors.white;
      } else if (index == selectedAnswer && isCorrect == false) {
        bg = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
        border = const Color(0xFFEF4444);
        text = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C);
        circleBg = const Color(0xFFEF4444);
        circleText = Colors.white;
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: AppTokens.radius24,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppTokens.radius24,
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: circleBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                selectedAnswer != null && index == correctAnswer
                    ? '✓'
                    : (selectedAnswer == index && isCorrect == false)
                        ? '✗'
                        : String.fromCharCode(65 + index),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: circleText,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: text,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackFooter extends StatelessWidget {
  const _FeedbackFooter({
    required this.isCorrect,
    required this.correctAnswer,
    required this.onContinue,
  });

  final bool isCorrect;
  final String correctAnswer;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isCorrect
        ? (isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7))
        : (isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2));
    final border = isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final text = isCorrect
        ? (isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857))
        : (isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C));

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: AppTokens.radius24,
            border: Border.all(color: border.withValues(alpha: 0.6)),
          ),
          child: Row(
            children: [
              Text(isCorrect ? '🎉' : '💡', style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isCorrect
                      ? 'Richtig! Gut gemacht!'
                      : 'Die richtige Antwort ist: $correctAnswer',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: text,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onContinue,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Nächste Frage'),
          ),
        ),
      ],
    );
  }
}

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.score,
    required this.total,
    required this.exercises,
    required this.answers,
    required this.onRestart,
    required this.onHome,
  });

  final int score;
  final int total;
  final List<Exercise> exercises;
  final List<bool> answers;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0 : ((score / total) * 100).round();
    final wrongCount = total - score;
    final wrongTopics = <String>[];
    for (var i = 0; i < exercises.length; i++) {
      final isWrong = i < answers.length ? !answers[i] : false;
      if (isWrong) wrongTopics.add(exercises[i].topic);
    }
    final uniqueWeakTopics = wrongTopics.toSet().toList();

    Gradient ringGradient;
    if (percentage >= 80) {
      ringGradient = const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF059669)],
      );
    } else if (percentage >= 50) {
      ringGradient = const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
      );
    } else {
      ringGradient = const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
      );
    }

    final message = percentage == 100
        ? 'Perfekt! Unglaublich!'
        : percentage >= 80
            ? 'Sehr gut gemacht!'
            : percentage >= 50
                ? 'Gut! Weiter üben!'
                : 'Nicht aufgeben!';
    final emoji = percentage == 100
        ? '🏆'
        : percentage >= 80
            ? '🎉'
            : percentage >= 50
                ? '👍'
                : '💪';

    return Column(
      children: [
        Row(
          children: [
            _IconButton(
              icon: Icons.arrow_back_rounded,
              onPressed: onRestart,
            ),
            const SizedBox(width: 10),
            Text(
              'Ergebnis',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 20),
        ProgressRing(
          progress: percentage.toDouble(),
          size: 180,
          strokeWidth: 12,
          gradient: ringGradient,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Ergebnis',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(emoji, style: const TextStyle(fontSize: 36)),
        const SizedBox(height: 6),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatBox(
                label: 'Richtig',
                value: '$score',
                bg: const Color(0xFFDCFCE7),
                fg: const Color(0xFF15803D),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatBox(
                label: 'Falsch',
                value: '$wrongCount',
                bg: const Color(0xFFFEE2E2),
                fg: const Color(0xFFB91C1C),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatBox(
                label: 'XP',
                value: '+${score * 10}',
                bg: const Color(0xFFDBEAFE),
                fg: const Color(0xFF1D4ED8),
              ),
            ),
          ],
        ),
        if (uniqueWeakTopics.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: AppTokens.radius24,
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded,
                        size: 16, color: Color(0xFFF59E0B)),
                    SizedBox(width: 6),
                    Text(
                      'Schwache Bereiche',
                      style: TextStyle(
                        color: Color(0xFFB45309),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final topic in uniqueWeakTopics)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          topic,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onRestart,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF97316),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Nochmal versuchen'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onHome,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF334155),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Zurück zum Home'),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.bg,
    required this.fg,
  });

  final String label;
  final String value;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppTokens.radius20,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: fg,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: fg.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      borderRadius: AppTokens.radius16,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppTokens.radius16,
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: AppTokens.radius16,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

String _typeLabelFor(String type) {
  switch (type.toLowerCase().replaceAll('_', '-')) {
    case 'multiple-choice':
      return 'Multiple Choice';
    case 'fill-in-blank':
    case 'fill-blank':
      return 'Lückentext';
    case 'sentence-order':
      return 'Satzordnung';
    case 'matching':
      return 'Matching';
    case 'business-dialog':
      return 'Business Dialog';
    default:
      return type;
  }
}

String _typeIconFor(String type) {
  switch (type.toLowerCase().replaceAll('_', '-')) {
    case 'multiple-choice':
      return '🔘';
    case 'fill-in-blank':
    case 'fill-blank':
      return '✍️';
    case 'sentence-order':
      return '🔀';
    case 'matching':
      return '🧩';
    case 'business-dialog':
      return '💼';
    default:
      return '📝';
  }
}
