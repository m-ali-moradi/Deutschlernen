import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/content/sync/sync_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/localization/app_ui_text.dart';
import '../../domain/grammar_logic.dart';
import '../../data/models/grammar_topic_type.dart';

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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFFA855F7)])
              : null,
          color: selected
              ? null
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }
}

class GrammarIconButton extends StatelessWidget {
  const GrammarIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.isDark,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isDark;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF3B82F6)
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: active
              ? Colors.white
              : (isDark ? Colors.white70 : Colors.black87),
        ),
      ),
    );
  }
}

class GrammarTopicCard extends ConsumerWidget {
  const GrammarTopicCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDownload,
  });

  final SyncEntry<GrammarTopic> entry;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final t = entry.localData;
    final isDownloaded = entry.isDownloaded;
    final englishTitle = entry.displayEnglishTitle ??
        grammarEnglishTopicTitles[entry.displayTitle];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTokens.radius20,
        child: InkWell(
          borderRadius: AppTokens.radius20,
          onTap: isDownloaded ? onTap : onDownload,
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
                _buildIcon(entry.cloudMetadata?['icon'] ?? t?.icon ?? '📚',
                    isDark, entry.localData?.category ?? 'Default'),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.displayTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: isDark
                                ? AppTokens.darkText
                                : AppTokens.lightText),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isDownloaded
                            ? (englishTitle ?? t!.category)
                            : strings.either(
                                german: 'Online verfügbar',
                                english: 'Available online'),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? AppTokens.darkTextMuted
                                : AppTokens.lightTextMuted),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDownloaded &&
                                    isGrammarTopicCompleted(t!.progress)
                                ? (isDark
                                    ? const Color(0xFF052E16)
                                    : const Color(0xFFF0FDF4))
                                : (isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFEFF6FF)),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            isDownloaded
                                ? grammarProgressStateLabel(
                                    t!.progress,
                                    isEnglish: strings.isEnglish,
                                  )
                                : strings.either(
                                    german: 'Nicht heruntergeladen',
                                    english: 'Not downloaded'),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDownloaded &&
                                      isGrammarTopicCompleted(t!.progress)
                                  ? (isDark
                                      ? const Color(0xFF86EFAC)
                                      : const Color(0xFF15803D))
                                  : (isDark
                                      ? const Color(0xFF93C5FD)
                                      : const Color(0xFF1D4ED8)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Progress bar with category gradient
                      if (isDownloaded)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: t!.progress / 100,
                            minHeight: 5,
                            backgroundColor: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFE5E7EB),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                getGrammarCategoryGradient(t.category).last),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isDownloaded)
                  Icon(Icons.chevron_right_rounded,
                      color: isDark
                          ? const Color(0xFF475569)
                          : const Color(0xFFCBD5E1),
                      size: 20)
                else
                  const Icon(Icons.download_for_offline_outlined,
                      color: Colors.blueAccent),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(String icon, bool isDark, String category) {
    final gradient = getGrammarCategoryGradient(category);
    return Container(
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
              color: gradient.last.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      alignment: Alignment.center,
      child: Text(icon, style: const TextStyle(fontSize: 22)),
    );
  }
}
