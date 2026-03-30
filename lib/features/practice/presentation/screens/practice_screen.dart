import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Premium Mesh Background
          AppTokens.meshBackground(isDark),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isDark, strings),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // Exercises section
                      _PracticeCard(
                        title: strings.exerciseSectionTitle(),
                        subtitle: strings.exerciseSubtitle(),
                        icon: Icons.edit_note_rounded,
                        color: const Color(0xFF3B82F6),
                        onTap: () => context.push('/practice/exercises'),
                      ),
                      // Exams section
                      _PracticeCard(
                        title: strings.examsSectionTitle(),
                        subtitle: strings.examsSubtitle(),
                        icon: Icons.assignment_rounded,
                        color: const Color(0xFF8B5CF6),
                        onTap: () => context.push('/practice/exams'),
                      ),
                      // Dialogues section
                      _PracticeCard(
                        title: strings.dialogueSectionTitle(),
                        subtitle: strings.dialogueSubtitle(),
                        icon: Icons.chat_bubble_rounded,
                        color: const Color(0xFF10B981),
                        onTap: () => context.push('/practice/dialogues'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, AppUiText strings) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.practiceSectionTitle(),
                  style: AppTokens.headingStyle(context, isDark),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.practiceSubtitle(),
                  style: AppTokens.subheadingStyle(context, isDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  const _PracticeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PremiumCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildColoredIcon(icon, color, isDark),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppTokens.textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTokens.textMuted(isDark),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppTokens.textMuted(isDark).withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildColoredIcon(IconData icon, Color color, bool isDark) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
