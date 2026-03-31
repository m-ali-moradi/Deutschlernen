import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/shared/widgets/app_icon_button.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
import 'package:deutschmate_mobile/shared/widgets/animated_progress_bar.dart';
import 'package:deutschmate_mobile/features/grammar/domain/grammar_logic.dart';
import 'package:deutschmate_mobile/features/grammar/data/models/grammar_topic_type.dart';

/// A chip widget for displaying a grammar level.
///
/// Used in the grammar list screen to filter by level.
class GrammarLevelChip extends StatelessWidget {
  const GrammarLevelChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      borderRadius: BorderRadius.circular(22),
      useGlass: !selected,
      gradient: selected
          ? const LinearGradient(
              colors: AppTokens.gradientBluePurple,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppTokens.textMuted(isDark),
          ),
        ),
      ),
    );
  }
}

/// (GrammarIconButton was here)
typedef GrammarIconButton = AppIconButton;

class GrammarTopicCard extends ConsumerWidget {
  const GrammarTopicCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final GrammarTopic entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final englishTitle = grammarEnglishTopicTitles[entry.title] ?? entry.title;

    return PremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      onTap: onTap,
      useGlass: true,
      blur: 12,
      borderOpacity: isDark ? 0.08 : 0.05,
      shadowOpacity: isDark ? 0.15 : 0.04,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildIcon(entry.icon.isEmpty ? '📚' : entry.icon, isDark,
                entry.category, entry.title),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: AppTokens.textPrimary(isDark),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    englishTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textMuted(isDark),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isGrammarTopicCompleted(entry.progress)
                          ? const Color(0xFF22C55E).withValues(alpha: 0.12)
                          : AppTokens.primary(isDark).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      grammarProgressStateLabel(
                        entry.progress,
                        isEnglish: strings.isEnglish,
                      ),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isGrammarTopicCompleted(entry.progress)
                            ? const Color(0xFF16A34A)
                            : AppTokens.primary(isDark),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      AnimatedProgressBar(
                        value: entry.progress / 100,
                        height: 8,
                        gradient: LinearGradient(
                          colors: getGrammarCategoryGradient(entry.category),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: AppTokens.textMuted(isDark).withValues(alpha: 0.4),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String icon, bool isDark, String category, String title) {
    final gradient = getGrammarCategoryGradient(category);
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradient.first,
            gradient.last,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withValues(alpha: 0.35),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.25),
            blurRadius: 0,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(
        getGrammarCategoryIcon(category, title),
        size: 26,
        color: Colors.white,
      ),
    );
  }
}
