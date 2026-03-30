import 'package:flutter/material.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../data/models/vocabulary_category.dart';

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
    this.onDownload,
  });

  final VocabularyCategory category;
  final String title;
  final String countLabel;
  final double progress;
  final bool isCached;
  final VoidCallback onTap;
  final VoidCallback? onDownload;

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = category.gradient;

    return Material(
      color: Colors.transparent,
      borderRadius: AppTokens.radius20,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTokens.radius20,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: AppTokens.radius20,
            boxShadow: [
              BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                  blurRadius: 16,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Row(
            children: [
              // Icon with category gradient
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: category.gradient.first.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ],
                ),
                alignment: Alignment.center,
                child:
                    Text(category.icon, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTokens.textPrimary(isDark),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!isCached && onDownload != null) ...[
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            splashRadius: 16,
                            tooltip: 'Download',
                            onPressed: onDownload,
                            icon: Icon(
                              Icons.download_rounded,
                              size: 18,
                              color: isDark
                                  ? const Color(0xFF60A5FA)
                                  : const Color(0xFF2563EB),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Icon(
                          Icons.chevron_right_rounded,
                          color: isDark
                              ? const Color(0xFF475569)
                              : const Color(0xFFCBD5E1),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      countLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTokens.textMuted(isDark),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 5,
                        backgroundColor: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE5E7EB),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(gradient.last),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
