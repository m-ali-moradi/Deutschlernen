import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
import 'package:deutschmate_mobile/shared/widgets/animated_progress_bar.dart';
import 'package:deutschmate_mobile/features/vocabulary/data/models/vocabulary_category.dart';

/// A card widget that displays a vocabulary category.
///
/// This widget is used to display a single vocabulary category in a card format.
/// It shows the category icon, title, word count, and progress bar.
///
/// [category]: The vocabulary category to display.
/// [title]: The title of the category.
/// [countLabel]: The label for the word count.
/// [progress]: The progress of the category (0.0 to 1.0).
/// [isCached]: Whether the category is cached locally.
/// [onTap]: The callback to be executed when the card is tapped.
/// [onDownload]: The callback to be executed when the download button is tapped.
class VocabularyCategoryCard extends StatelessWidget {
  const VocabularyCategoryCard({
    super.key,
    required this.category,
    required this.title,
    required this.countLabel,
    required this.progress,
    required this.isCached,
    required this.onTap,
  });

  final VocabularyCategory category;
  final String title;
  final String countLabel;
  final double progress;
  final bool isCached;
  final VoidCallback onTap;

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = category.gradient;

    return PremiumCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      useGlass: true,
      blur: 12,
      borderOpacity: isDark ? 0.08 : 0.05,
      shadowOpacity: isDark ? 0.12 : 0.04,
      child: Row(
        children: [
          // Icon with category gradient
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: gradient.last.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4))
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              getVocabularyCategoryIcon(category.id),
              size: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: AppTokens.textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  countLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.textMuted(isDark),
                  ),
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            AppTokens.textMuted(isDark).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    AnimatedProgressBar(
                      value: progress,
                      height: 8,
                      gradient: LinearGradient(colors: gradient),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.chevron_right_rounded,
            color: AppTokens.textMuted(isDark).withValues(alpha: 0.4),
            size: 22,
          ),
        ],
      ),
    );
  }
}
