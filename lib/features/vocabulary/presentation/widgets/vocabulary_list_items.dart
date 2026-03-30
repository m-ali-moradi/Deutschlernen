import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
import 'package:deutschmate_mobile/core/learning/review_logic.dart';
import './vocabulary_common_widgets.dart';

/// A card widget representing a single vocabulary word in the dictionary list.
/// Displays the word, translated meaning, tag, difficulty and a favorite toggle.
class WordCard extends StatelessWidget {
  const WordCard({
    super.key,
    required this.entry,
    required this.lastResult,
    required this.isDark,
    required this.isDari,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  final VocabularyWord entry;
  final ReviewResult? lastResult;
  final bool isDark;
  final bool isDari;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final word = entry;
    final isFav = word.isFavorite;
    final title = word.german;
    final meaning = isDari ? word.dari : word.english;
    final tag = word.tag;

    return PremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      onTap: onTap,
      useGlass: true,
      blur: 10,
      borderOpacity: isDark ? 0.08 : 0.06,
      shadowOpacity: isDark ? 0.15 : 0.04,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            DifficultyDot(lastResult),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: AppTokens.textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meaning,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textMuted(isDark),
                    ),
                    textDirection:
                        isDari ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  if (tag.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    MetaPill(
                      label: tag,
                      dark: isDark,
                      icon: Icons.label_outline_rounded,
                    ),
                  ],
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFav
                      ? const Color(0xFFEF4444)
                      : AppTokens.textMuted(isDark).withValues(alpha: 0.3),
                  size: 22,
                ),
                onPressed: onFavoriteToggle,
                splashRadius: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A card widget representing a static phrase in the phrase list.
class PhraseCard extends StatelessWidget {
  const PhraseCard({
    super.key,
    required this.phrase,
    required this.english,
    required this.isDark,
  });

  final String phrase;
  final String english;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      useGlass: true,
      blur: 10,
      borderOpacity: isDark ? 0.08 : 0.04,
      shadowOpacity: isDark ? 0.1 : 0.02,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              phrase,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: AppTokens.textPrimary(isDark),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              english,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTokens.textMuted(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
