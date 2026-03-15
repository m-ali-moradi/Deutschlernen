import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/database_providers.dart';
import '../../../shared/widgets/progress_ring.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsStreamProvider);

    return stats.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 44),
              const SizedBox(height: 10),
              const Text('Failed to load stats'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(userStatsStreamProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (userStats) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _PageHalo(),
                _Header(streak: userStats.streak, xp: userStats.xp),
                const SizedBox(height: 20),
                _WeeklyProgress(
                  progress: userStats.weeklyProgress,
                  wordsLearned: userStats.wordsLearned,
                  exercisesCompleted: userStats.exercisesCompleted,
                ),
                const SizedBox(height: 20),
                _ChallengeCard(
                  onStart: () => context.go('/vocabulary'),
                ),
                const SizedBox(height: 24),
                Text('Lernbereiche',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  'Wahle deinen Fokus fur heute',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF6B7280),
                      ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  emoji: '📘',
                  title: 'Grammar',
                  subtitle: 'Regeln & Struktur',
                  colors: const [Color(0xFFA855F7), Color(0xFF7C3AED)],
                  onTap: () => context.go('/grammar'),
                ),
                const SizedBox(height: 10),
                _SectionCard(
                  emoji: '📚',
                  title: 'Vocabulary',
                  subtitle: 'Worter & Business',
                  colors: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  onTap: () => context.go('/vocabulary'),
                ),
                const SizedBox(height: 10),
                _SectionCard(
                  emoji: '✏️',
                  title: 'Exercises',
                  subtitle: 'Tests & Quiz',
                  colors: const [Color(0xFFFB923C), Color(0xFFEA580C)],
                  onTap: () => context.go('/exercises'),
                ),
                const SizedBox(height: 20),
                _AchievementsPreview(onOpen: () => context.go('/profile')),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFFA855F7)],
                      ),
                    ),
                    child: Text(
                      'Aktuelles Level: ${userStats.level}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.streak, required this.xp});

  final int streak;
  final int xp;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lerne Deutsch 🇩🇪',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                'Willkommen zuruck!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        _MetricChip(
          icon: '🔥',
          value: '$streak',
          bg: isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFEDD5),
          fg: isDark ? const Color(0xFFFED7AA) : const Color(0xFF9A3412),
        ),
        const SizedBox(width: 8),
        _MetricChip(
          icon: '⚡',
          value: '$xp',
          bg: isDark ? const Color(0xFF713F12) : const Color(0xFFFEF3C7),
          fg: isDark ? const Color(0xFFFDE68A) : const Color(0xFFA16207),
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip(
      {required this.icon,
      required this.value,
      required this.bg,
      required this.fg});

  final String icon;
  final String value;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Text(icon, style: TextStyle(color: fg)),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _WeeklyProgress extends StatelessWidget {
  const _WeeklyProgress({
    required this.progress,
    required this.wordsLearned,
    required this.exercisesCompleted,
  });

  final int progress;
  final int wordsLearned;
  final int exercisesCompleted;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black.withValues(alpha: 0.07),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ProgressRing(
              progress: progress.clamp(0, 100).toDouble(),
              size: 96,
              strokeWidth: 8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$progress%',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('Woche', style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Wochenfortschritt',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _StatPill(
                          title: 'Worter',
                          value: '$wordsLearned',
                          bg: const Color(0xFFEFF6FF),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatPill(
                          title: 'Ubungen',
                          value: '$exercisesCompleted',
                          bg: const Color(0xFFECFDF5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.title, required this.value, required this.bg});

  final String title;
  final String value;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color.lerp(bg, const Color(0xFF0F172A), 0.82) : bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: isDark ? Colors.white70 : null),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: isDark ? Colors.white : null),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🏆 Tagliche Herausforderung',
                    style: TextStyle(
                        color: Color(0xFFF3F4F6), fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                const Text(
                  '5 Business-Worter lernen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.5,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '+50 XP Belohnung',
                  style: TextStyle(
                    color: Color(0xFFE5E7EB),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: onStart,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.24),
              foregroundColor: Colors.white,
              textStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.30),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFF1F5F9),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFE2E8F0),
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementsPreview extends StatelessWidget {
  const _AchievementsPreview({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      shadowColor: Colors.black.withValues(alpha: 0.07),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text('Erfolge', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                TextButton(
                    onPressed: onOpen, child: const Text('Alle anzeigen')),
              ],
            ),
            Row(
              children: [
                for (final item in [
                  ('🎯', true),
                  ('📚', true),
                  ('🔥', true),
                  ('💎', false),
                ])
                  Opacity(
                    opacity: item.$2 ? 1 : 0.45,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: item.$2
                              ? (isDark
                                  ? const Color(0xFF3F3A11)
                                  : const Color(0xFFFEF9C3))
                              : (isDark
                                  ? const Color(0xFF1F2937)
                                  : const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child:
                            Text(item.$1, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                  ),
                const Spacer(),
                Column(
                  children: [
                    Text('3/6', style: Theme.of(context).textTheme.titleLarge),
                    Text('freigeschaltet',
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PageHalo extends StatelessWidget {
  const _PageHalo();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IgnorePointer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1E1B4B).withValues(alpha: 0.7),
                    const Color(0xFF0F172A).withValues(alpha: 0.2),
                  ]
                : [
                    const Color(0xFFDBEAFE),
                    const Color(0xFFEDE9FE),
                  ],
          ),
        ),
      ),
    );
  }
}
