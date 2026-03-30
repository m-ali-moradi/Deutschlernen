import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/widgets/app_state_view.dart';
import '../../../../shared/localization/app_ui_text.dart';
import '../widgets/home_widgets.dart';

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
  _ContinueStyle(sectionKey: 'grammar', icon: '📘', gradient: _gradPurple),
  _ContinueStyle(sectionKey: 'vocabulary', icon: '📚', gradient: _gradBlue),
  _ContinueStyle(sectionKey: 'exercises', icon: '✏️', gradient: _gradOrange),
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  _ContinueStyle _styleForSection(String sectionKey) {
    return _continueStyles.firstWhere(
      (style) => style.sectionKey == sectionKey,
      orElse: () => _continueStyles.first,
    );
  }

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
            return Scaffold(
              backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              body: SafeArea(
                top: false,
                bottom: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Header ---
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.either(german: 'Lerne Deutsch 🇩🇪', english: 'Learn German 🇩🇪'),
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  strings.either(german: 'Mach dort weiter, wo du aufgehört hast.', english: 'Continue where you left off.'),
                                  style: TextStyle(fontSize: 13, color: textMuted),
                                ),
                              ],
                            ),
                          ),
                          HomeChip(
                            icon: '⚡',
                            label: '${stats.xp} XP',
                            bg: isDark ? const Color(0xFF422006) : const Color(0xFFFEFCE8),
                            fg: const Color(0xFFCA8A04),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- Continue Learning Section ---
                      Text(
                        strings.either(german: 'Weiterlernen', english: 'Continue Learning'),
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textPrimary),
                      ),
                      const SizedBox(height: 12),
                      ...continueLearningItems.map((item) {
                        final style = _styleForSection(item.sectionKey);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: HomeGradCard(
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
                                          color: Colors.white.withValues(alpha: 0.75),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.title,
                                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.subtitle,
                                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.6), size: 22),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),

                      // --- Weekly Progress Card ---
                      HomeStatCard(
                        color: cardColor,
                        child: Row(
                          children: [
                            HomeProgressRing(
                              progress: summary.weeklyProgress / 100,
                              size: 92,
                              label: '${summary.weeklyProgress}%',
                              sublabel: strings.either(german: 'Woche', english: 'Week'),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    strings.either(german: 'Wochenfortschritt', english: 'Weekly progress'),
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: HomeStatMini(
                                          label: strings.either(german: 'Wörter', english: 'Words'),
                                          value: '${summary.wordsLearned}',
                                          bg: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF),
                                          fg: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: HomeStatMini(
                                          label: strings.either(german: 'Übungen', english: 'Exercises'),
                                          value: '${summary.exerciseAttemptCount}',
                                          bg: isDark ? const Color(0xFF14532D) : const Color(0xFFF0FDF4),
                                          fg: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
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

                      // --- Level Indicator ---
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF9333EA)]),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                strings.either(german: 'Aktuelles Level:', english: 'Current level:'),
                                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                stats.level,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
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
}
