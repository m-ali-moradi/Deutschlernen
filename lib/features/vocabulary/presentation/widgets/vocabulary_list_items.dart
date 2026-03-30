import 'package:flutter/material.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/content/sync/sync_service.dart';
import '../../../../core/database/app_database.dart';
import 'vocabulary_common_widgets.dart';

/// A card widget representing a single vocabulary word in the dictionary list.
/// Displays the word, translated meaning, tag, difficulty and a favorite toggle.
class WordCard extends StatelessWidget {
  const WordCard({
    super.key,
    required this.entry,
    required this.reviewStatus,
    required this.isDark,
    required this.isDari,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  final SyncEntry<VocabularyWord> entry;
  final String reviewStatus;
  final bool isDark;
  final bool isDari;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final word = entry.localData;
    final isFav = word?.isFavorite ?? false;
    final title = entry.displayTitle;
    final meaning = isDari
        ? (word?.dari ?? entry.cloudMetadata?['dari']?.toString() ?? '')
        : (word?.english ?? entry.cloudMetadata?['english']?.toString() ?? '');
    final tag = word?.tag ?? entry.cloudMetadata?['tag'] ?? '';
    final difficulty = word?.difficulty ?? 'medium';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                DifficultyDot(difficulty),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTokens.textPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        meaning,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTokens.textMuted(isDark),
                        ),
                        textDirection:
                            isDari ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      if (tag.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        MetaPill(
                          label: tag,
                          dark: isDark,
                          icon: Icons.label_outline_rounded,
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFav ? Colors.red : AppTokens.textMuted(isDark),
                    size: 20,
                  ),
                  onPressed: onFavoriteToggle,
                ),
              ],
            ),
          ),
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            phrase,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTokens.textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            english,
            style: TextStyle(
              fontSize: 13,
              color: AppTokens.textMuted(isDark),
            ),
          ),
        ],
      ),
    );
  }
}
