import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/database_providers.dart';
import '../../../core/theme/app_tokens.dart';
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
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(streak: userStats.streak, xp: userStats.xp),
                const SizedBox(height: 24),
                _WeeklyProgress(
                  progress: userStats.weeklyProgress,
                  wordsLearned: userStats.wordsLearned,
                  exercisesCompleted: userStats.exercisesCompleted,
                ),
                const SizedBox(height: 24),
                _ChallengeCard(onStart: () => context.go('/vocabulary')),
                const SizedBox(height: 24),
                Text(
                  'Lernbereiche',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  emoji: '📘',
                  title: 'Grammar',
                  subtitle: 'Regeln & Struktur',
                  colors: const [Color(0xFFA855F7), Color(0xFF7C3AED)],
                  shadowColor: const Color(0xFFD8B4FE),
                  onTap: () => context.go('/grammar'),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  emoji: '📚',
                  title: 'Vocabulary',
                  subtitle: 'Wörter & Business',
                  colors: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  shadowColor: const Color(0xFFBFDBFE),
                  onTap: () => context.go('/vocabulary'),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  emoji: '✏️',
                  title: 'Exercises',
                  subtitle: 'Tests & Quiz',
                  colors: const [Color(0xFFFB923C), Color(0xFFEA580C)],
                  shadowColor: const Color(0xFFFED7AA),
                  onTap: () => context.go('/exercises'),
                ),
                const SizedBox(height: 24),
                _AchievementsPreview(onOpen: () => context.go('/profile')),
                const SizedBox(height: 18),
                _LevelBadge(level: userStats.level),
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
              Text(
                'Lerne Deutsch 🇩🇪',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color:
                          isDark ? AppTokens.darkText : AppTokens.lightText,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Willkommen zurück!',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppTokens.darkTextMuted
                          : AppTokens.lightTextMuted,
                    ),
              ),
            ],
          ),
        ),
        _MetricChip(
          icon: Icons.local_fire_department_rounded,
          value: '$streak',
          bg: isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFEDD5),
          fg: isDark ? const Color(0xFFFED7AA) : const Color(0xFF9A3412),
        ),
        const SizedBox(width: 8),
        _MetricChip(
          icon: Icons.bolt_rounded,
          value: '$xp',
          bg: isDark ? const Color(0xFF713F12) : const Color(0xFFFEF3C7),
          fg: isDark ? const Color(0xFFFDE68A) : const Color(0xFFA16207),
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.value,
    required this.bg,
    required this.fg,
  });

  final IconData icon;
  final String value;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(color: fg, fontWeight: FontWeight.w600),
          ),
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
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          ProgressRing(
            progress: progress.clamp(0, 100).toDouble(),
            size: 100,
            strokeWidth: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$progress%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isDark
                            ? AppTokens.darkText
                            : AppTokens.lightText,
                      ),
                ),
                Text(
                  'Woche',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppTokens.darkTextMuted
                            : AppTokens.lightTextMuted,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wochenfortschritt',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppTokens.darkText
                            : AppTokens.lightText,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatPill(
                        title: 'Wörter',
                        value: '$wordsLearned',
                        bg: const Color(0xFFDBEAFE),
                        fg: const Color(0xFF1D4ED8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatPill(
                        title: 'Übungen',
                        value: '$exercisesCompleted',
                        bg: const Color(0xFFDCFCE7),
                        fg: const Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.title,
    required this.value,
    required this.bg,
    required this.fg,
  });

  final String title;
  final String value;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? bg.withValues(alpha: 0.2) : bg,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isDark ? fg.withValues(alpha: 0.9) : fg,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark ? fg.withValues(alpha: 0.9) : fg,
                ),
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
        borderRadius: AppTokens.radius30,
        gradient: const LinearGradient(
          colors: AppTokens.gradientIndigoPurplePink,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA855F7).withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.emoji_events_rounded,
                        size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Tägliche Herausforderung',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  '5 Business-Wörter lernen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '+50 XP Belohnung',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: onStart,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
    required this.shadowColor,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final Color shadowColor;
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
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: AppTokens.radius20,
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.45),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 34)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white70,
                size: 26,
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

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTokens.darkCard : AppTokens.lightCard,
        borderRadius: AppTokens.radius30,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Erfolge',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color:
                          isDark ? AppTokens.darkText : AppTokens.lightText,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onOpen,
                child: const Text('Alle anzeigen'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (final item in [
                ('🎯', true),
                ('📚', true),
                ('🔥', true),
                ('💎', false),
              ])
                Opacity(
                  opacity: item.$2 ? 1 : 0.4,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: item.$2
                            ? (isDark
                                ? const Color(0xFF3F3A11)
                                : const Color(0xFFFEF9C3))
                            : (isDark
                                ? const Color(0xFF1F2937)
                                : const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(item.$1, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '3/6',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isDark
                              ? AppTokens.darkText
                              : AppTokens.lightText,
                        ),
                  ),
                  Text(
                    'freigeschaltet',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppTokens.darkTextMuted
                              : AppTokens.lightTextMuted,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppTokens.gradientBluePurple,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Aktuelles Level:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              level,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
