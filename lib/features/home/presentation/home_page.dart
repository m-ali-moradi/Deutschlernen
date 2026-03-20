import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/database_providers.dart';
import '../../../core/learning/continue_learning.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_state_view.dart';
import '../../../shared/localization/app_ui_text.dart';

const _gradPurple = [Color(0xFF8B5CF6), Color(0xFF6D28D9)];
const _gradBlue = [Color(0xFF3B82F6), Color(0xFF1D4ED8)];
const _gradOrange = [Color(0xFFFB923C), Color(0xFFEA580C)];

class _ContinueStyle {
  const _ContinueStyle({
    required this.sectionKey,
    required this.icon,
    required this.gradient,
  });

  final String sectionKey;
  final String icon;
  final List<Color> gradient;
}

const _continueStyles = [
  _ContinueStyle(
    sectionKey: 'grammar',
    icon: '📘',
    gradient: _gradPurple,
  ),
  _ContinueStyle(
    sectionKey: 'vocabulary',
    icon: '📚',
    gradient: _gradBlue,
  ),
  _ContinueStyle(
    sectionKey: 'exercises',
    icon: '✏️',
    gradient: _gradOrange,
  ),
];

/// This is the main page that users see when they open the app.
///
/// It shows the user's progress summary and options to continue learning.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = AppTokens.surface(isDark);
    final textPrimary = AppTokens.textPrimary(isDark);
    final textMuted = AppTokens.textMuted(isDark);
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    final statsAsync = ref.watch(userStatsStreamProvider);
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final continueLearningItems = ref.watch(continueLearningItemsProvider);

    return statsAsync.when(
      data: (stats) {
        return summaryAsync.when(
          data: (summary) {
            return _buildContent(
              context,
              strings,
              isDark,
              cardColor,
              textPrimary,
              textMuted,
              stats.xp,
              stats.level,
              summary.wordsLearned,
              summary.exerciseAttemptCount,
              summary.weeklyProgress,
              continueLearningItems,
            );
          },
          loading: () => const Scaffold(
            body: AppStateView.loading(
              title: 'Loading weekly progress',
              message: 'Learning statistics are being synchronized.',
            ),
          ),
          error: (e, s) => Scaffold(
            body: AppStateView.error(
              message: 'The overview could not be loaded.\n$e',
              onAction: () => ref.invalidate(dashboardSummaryProvider),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: AppStateView.loading(
          title: 'Loading learning statistics',
          message: 'One moment please.',
        ),
      ),
      error: (e, s) => Scaffold(
        body: AppStateView.error(
          message: 'The learning statistics could not be loaded.\n$e',
          onAction: () => ref.invalidate(userStatsStreamProvider),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppUiText strings,
    bool isDark,
    Color cardColor,
    Color textPrimary,
    Color textMuted,
    int xp,
    String level,
    int wordsLearned,
    int exercisesDone,
    int weeklyProgress,
    List<ContinueLearningItem> continueLearningItems,
  ) {
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.either(
                          german: 'Lerne Deutsch 🇩🇪',
                          english: 'Learn German 🇩🇪',
                        ),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        strings.either(
                          german: 'Mach dort weiter, wo du aufgehört hast.',
                          english: 'Continue where you left off.',
                        ),
                        style: TextStyle(fontSize: 13, color: textMuted),
                      ),
                    ],
                  ),
                ),
                _Chip(
                  icon: '⚡',
                  label: '$xp XP',
                  bg: isDark
                      ? const Color(0xFF422006)
                      : const Color(0xFFFEFCE8),
                  fg: const Color(0xFFCA8A04),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              strings.either(
                german: 'Weiterlernen',
                english: 'Continue Learning',
              ),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...continueLearningItems.map((item) {
              final style = _styleForSection(item.sectionKey);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _GradCard(
                  gradient: style.gradient,
                  onTap: () => context.go(item.route),
                  child: Row(
                    children: [
                      Text(style.icon, style: const TextStyle(fontSize: 34)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.sectionLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.75),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withOpacity(0.6),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            _Card(
              color: cardColor,
              child: Row(
                children: [
                  _ProgressRing(
                    progress: weeklyProgress / 100,
                    size: 92,
                    label: '$weeklyProgress%',
                    sublabel: strings.either(german: 'Woche', english: 'Week'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.either(
                            german: 'Wochenfortschritt',
                            english: 'Weekly progress',
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _StatMini(
                                label: strings.either(
                                  german: 'Wörter',
                                  english: 'Words',
                                ),
                                value: '$wordsLearned',
                                bg: isDark
                                    ? const Color(0xFF1E3A5F)
                                    : const Color(0xFFEFF6FF),
                                fg: isDark
                                    ? const Color(0xFF93C5FD)
                                    : const Color(0xFF1D4ED8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _StatMini(
                                label: strings.either(
                                  german: 'Übungen',
                                  english: 'Exercises',
                                ),
                                value: '$exercisesDone',
                                bg: isDark
                                    ? const Color(0xFF14532D)
                                    : const Color(0xFFF0FDF4),
                                fg: isDark
                                    ? const Color(0xFF86EFAC)
                                    : const Color(0xFF15803D),
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
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      strings.either(
                        german: 'Aktuelles Level:',
                        english: 'Current level:',
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      level,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

_ContinueStyle _styleForSection(String sectionKey) {
  return _continueStyles.firstWhere(
    (style) => style.sectionKey == sectionKey,
    orElse: () => _continueStyles.first,
  );
}

/// This card is used to show information in a nice container.
class _Card extends StatelessWidget {
  const _Card({required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: child,
      );
}

/// This card uses a gradient background to highlight important sections.
class _GradCard extends StatelessWidget {
  const _GradCard({required this.gradient, required this.child, this.onTap});

  final List<Color> gradient;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      );
}

/// This small chip shows information like XP or points.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
  });

  final String icon;
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      );
}

class _StatMini extends StatelessWidget {
  const _StatMini({
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
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: fg)),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      );
}

/// This widget shows a progress circle for the weekly goal.
class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.progress,
    required this.size,
    required this.label,
    required this.sublabel,
  });

  final double progress;
  final double size;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor:
                  isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF6366F1)),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              Text(
                sublabel,
                style:
                    TextStyle(fontSize: 10, color: AppTokens.textMuted(isDark)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
