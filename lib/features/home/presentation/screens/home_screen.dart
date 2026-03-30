import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/widgets/app_state_view.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
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
  final IconData icon;
  final List<Color> gradient;
}

const _continueStyles = [
  _ContinueStyle(
      sectionKey: 'grammar', icon: Icons.menu_book_rounded, gradient: _gradPurple),
  _ContinueStyle(
      sectionKey: 'vocabulary',
      icon: Icons.auto_stories_rounded,
      gradient: _gradBlue),
  _ContinueStyle(
      sectionKey: 'exercises',
      icon: Icons.edit_note_rounded,
      gradient: _gradOrange),
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
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    final xpAsync = ref.watch(userXpProvider);
    final levelAsync = ref.watch(userLevelProvider);
    final weeklyProgressAsync = ref.watch(weeklyProgressProvider);
    final wordsLearnedAsync = ref.watch(wordsLearnedCountProvider);
    final exerciseAttemptsAsync = ref.watch(exerciseAttemptCountProvider);
    final continueLearningItems = ref.watch(continueLearningItemsProvider);

    final isLoading = xpAsync.isLoading || 
                      levelAsync.isLoading || 
                      weeklyProgressAsync.isLoading;
    
    if (isLoading) {
      return Scaffold(
        body: Stack(
          children: [
            AppTokens.meshBackground(isDark),
            const SafeArea(
              child: AppStateView.loading(
                title: 'Loading DeutschMate',
                message: 'Preparing your learning dashboard...',
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Premium Mesh Background
          AppTokens.meshBackground(isDark),
                  if (isDark)
                    Positioned(
                      top: -100,
                      right: -100,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                        ),
                      ),
                    ),

                  SafeArea(
                    bottom: true,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                                      'DeutschMate',
                                      style: AppTokens.headingStyle(context, isDark).copyWith(
                                        letterSpacing: -0.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      strings.homeScreenSubtitle(),
                                      style: AppTokens.subheadingStyle(context, isDark),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              HomeChip(
                                icon: Icons.auto_awesome_rounded,
                                label: '${xpAsync.value ?? 0} XP',
                                bg: isDark
                                    ? const Color(0xFF1E1B4B)
                                    : const Color(0xFFFEFCE8),
                                fg: const Color(0xFFCA8A04),
                              ),
                              const SizedBox(width: 8),
                              // User Profile Dropdown
                              PopupMenuButton<String>(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isDark
                                          ? [const Color(0xFF334155), const Color(0xFF1E293B)]
                                          : [Colors.white, const Color(0xFFF1F5F9)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : Colors.black.withValues(alpha: 0.05),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 20,
                                    color: textPrimary.withValues(alpha: 0.9),
                                  ),
                                ),
                                position: PopupMenuPosition.under,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onSelected: (value) {
                                  if (value == 'profile') {
                                    context.push('/profile');
                                  } else if (value == 'login') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Login service integration coming soon.')),
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'profile',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.person_rounded, size: 20, color: Color(0xFF6366F1)),
                                        const SizedBox(width: 12),
                                        Text(
                                          strings.either(german: 'Profil', english: 'Profile'),
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'login',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.login_rounded, size: 20, color: Color(0xFF10B981)),
                                        const SizedBox(width: 12),
                                        Text(
                                          strings.either(german: 'Anmelden', english: 'Sign In'),
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // --- Continue Learning Section ---
                          Text(
                            strings.either(
                                german: 'Weiterlernen',
                                english: 'Continue Learning'),
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: textPrimary),
                          ),
                          const SizedBox(height: 12),
                          ...continueLearningItems.map((item) {
                            final style = _styleForSection(item.sectionKey);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: HomeGradCard(
                                gradient: style.gradient,
                                onTap: () => context.push(item.route),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(style.icon,
                                          size: 30, color: Colors.white),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.sectionLabel,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white
                                                  .withValues(alpha: 0.75),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.subtitle,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white
                                                    .withValues(alpha: 0.8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.chevron_right_rounded,
                                        color: Colors.white.withValues(alpha: 0.6),
                                        size: 22),
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
                                  progress: (weeklyProgressAsync.value ?? 0) / 100,
                                  size: 92,
                                  label: '${weeklyProgressAsync.value ?? 0}%',
                                  sublabel: strings.either(
                                      german: 'Woche', english: 'Week'),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        strings.either(
                                            german: 'Wochenfortschritt',
                                            english: 'Weekly progress'),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: textPrimary),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: HomeStatMini(
                                              label: strings.either(
                                                  german: 'Wörter',
                                                  english: 'Words'),
                                              value: '${wordsLearnedAsync.value ?? 0}',
                                              icon: Icons.auto_awesome_rounded,
                                              bg: isDark
                                                  ? AppTokens.surfaceMuted(isDark)
                                                  : const Color(0xFFF5F3FF),
                                              fg: isDark
                                                  ? const Color(0xFFA78BFA)
                                                  : const Color(0xFF7C3AED),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: HomeStatMini(
                                              label: strings.either(
                                                  german: 'Übungen',
                                                  english: 'Exercises'),
                                              value:
                                                  '${exerciseAttemptsAsync.value ?? 0}',
                                              icon: Icons.rocket_launch_rounded,
                                              bg: isDark
                                                  ? AppTokens.surfaceMuted(isDark)
                                                  : const Color(0xFFFFF7ED),
                                              fg: isDark
                                                  ? const Color(0xFFFB923C)
                                                  : const Color(0xFFEA580C),
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
                            child: PremiumCard(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              borderRadius: BorderRadius.circular(100),
                              gradient: const LinearGradient(
                                  colors: [Color(0xFF3B82F6), Color(0xFF9333EA)]),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.trending_up_rounded,
                                      size: 14, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    strings.either(
                                        german: 'Level:',
                                        english: 'Level:'),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withValues(alpha: 0.9)),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    levelAsync.value ?? 'A1',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white),
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
                ],
              ),
            );
  }
}



