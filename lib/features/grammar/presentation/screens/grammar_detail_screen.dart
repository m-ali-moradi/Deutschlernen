import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/content/sync/sync_service.dart';
import '../../../../core/content/sync/connectivity_service.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/localization/app_ui_text.dart';
import '../widgets/grammar_detail_widgets.dart';
import '../widgets/grammar_rich_detail_view.dart';
import '../grammar_seed.dart';

/// A detail screen for a specific grammar topic.
///
/// It acts as a wrapper that:
/// 1. Fetches data from [hybridGrammarProvider] (merging local & cloud).
/// 2. If already downloaded, renders [GrammarRichDetailView].
/// 3. If cloud-only, shows a fallback view with a download option.
class GrammarDetailScreen extends ConsumerWidget {
  const GrammarDetailScreen({
    super.key,
    required this.topicId,
    this.backLevel = 'Alle',
    this.backCategory = 'Alle',
    this.backShowFilters = false,
  });

  /// Unique ID for the grammar topic.
  final String topicId;
  final String backLevel;
  final String backCategory;
  final bool backShowFilters;

  void _goBackToGrammar(BuildContext context) {
    final uri = Uri(
      path: '/grammar',
      queryParameters: {
        'level': backLevel,
        'category': backCategory,
        'showFilters': backShowFilters ? '1' : '0',
      },
    );
    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hybridAsync = ref.watch(hybridGrammarProvider);
    final detailAsync = ref.watch(grammarDetailProvider(topicId));
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final isOnline = ref.watch(connectivityProvider).valueOrNull ?? false;

    // Find the entry from the hybrid provider (local + cloud)
    final entry = hybridAsync.valueOrNull?.where((e) => e.id == topicId).firstOrNull;
    
    // Fallback search in seed if hybrid is still loading or doesn't have it
    final seedTopic = grammarTopicsSeed.where((topic) => topic.id == topicId).firstOrNull;

    if (entry == null && seedTopic == null) {
      if (hybridAsync.isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => _goBackToGrammar(context))),
        body: Center(child: Text(strings.either(german: 'Thema nicht gefunden', english: 'Topic not found'))),
      );
    }

    final topicTitle = entry?.displayTitle ?? seedTopic!.title;
    final topicLevel = entry?.displayLevel ?? seedTopic!.level;
    final topicCategory = entry?.localData?.category ?? entry?.cloudMetadata?['category'] ?? seedTopic?.category ?? '';
    final topicIcon = entry?.localData?.icon ?? entry?.cloudMetadata?['icon'] ?? seedTopic?.icon ?? 'book';
    final topicExplanation = entry?.localData?.explanation ?? entry?.cloudMetadata?['explanation'] ?? seedTopic?.explanation ?? '';
    final topicRule = entry?.localData?.rule ?? entry?.cloudMetadata?['rule'] ?? seedTopic?.rule ?? '';
    final topicProgress = entry?.localData?.progress ?? 0;
    final isDownloaded = entry?.isDownloaded ?? true; // Seed topics are considered downloaded

    return detailAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Fehler beim Laden: $err'))),
      data: (detail) {
        if (detail != null) {
          return GrammarRichDetailView(
            topicTitle: topicTitle,
            topicCategory: topicCategory,
            topicLevel: topicLevel,
            topicProgress: topicProgress,
            detail: detail,
            onBack: () => _goBackToGrammar(context),
            onResetExercises: () => ref
                .read(appSettingsActionsProvider)
                .resetGrammarTopicExercises(topicTitle),
          );
        }

        // Fallback View if no rich detail payload is available (e.g., cloud-only or core meta only)
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textPrimary = isDark ? AppTokens.darkText : AppTokens.lightText;
        final textMuted = isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header ---
                  Row(
                    children: [
                      GrammarDetailBackButton(
                          onPressed: () => _goBackToGrammar(context),
                          isDark: isDark),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$topicTitle $topicIcon',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: textPrimary, fontSize: 22),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1E3A8A).withValues(alpha: 0.4)
                                          : const Color(0xFFDBEAFE),
                                      borderRadius: BorderRadius.circular(999)),
                                  child: Text(
                                    topicLevel,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: isDark
                                            ? const Color(0xFFBFDBFE)
                                            : const Color(0xFF1D4ED8)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  topicCategory,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Cloud Only Warning ---
                  if (!isDownloaded)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: AppTokens.radius16,
                        border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_off_rounded, color: Colors.orange, size: 32),
                          const SizedBox(height: 12),
                          Text(
                            strings.either(
                                german: 'Dieses Thema ist nur online verfügbar.',
                                english: 'This topic is only available online.'),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            strings.either(
                                german: 'Lade es herunter, um alle Details und Beispiele zu sehen.',
                                english: 'Download it to see all details and examples.'),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textMuted, fontSize: 13),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: !isOnline ? null : () async {
                                final lang = ref.read(displayLanguageProvider);
                                await ref.read(syncServiceProvider).downloadGrammarTopic(topicId, languageCode: lang);
                                // Refresh providers
                                ref.invalidate(grammarDetailProvider(topicId));
                                ref.invalidate(hybridGrammarProvider);
                              },
                              icon: const Icon(Icons.download_rounded),
                              label: Text(strings.either(german: 'Jetzt herunterladen', english: 'Download Now')),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          if (!isOnline)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                strings.offlineMessage(),
                                style: const TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ),
                        ],
                      ),
                    ),

                  // --- Explanation Card ---
                  GrammarDetailCard(
                    isDark: isDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.menu_book_rounded,
                                size: 18, color: Color(0xFF3B82F6)),
                            const SizedBox(width: 6),
                            Text(
                              strings.translate(
                                en: 'Explanation',
                                de: 'Erklärung',
                                fa: 'توضیحات',
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: textPrimary),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(topicExplanation,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: textMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // --- Rule Card ---
                  if (topicRule.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFFA855F7)]),
                        borderRadius: AppTokens.radius24,
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFFA855F7).withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_rounded,
                                  size: 18, color: Color(0xFFFDE68A)),
                              const SizedBox(width: 6),
                              Text(
                                strings.translate(
                                  en: 'Rule',
                                  de: 'Regel',
                                  fa: 'قاعده',
                                ),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(topicRule,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15, height: 1.4)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Progress Card removed as per user request

                  // --- Footer Actions ---
                  if (isDownloaded)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          if (topicTitle.isNotEmpty) {
                            context.go(
                                '/exercises?topic=${Uri.encodeComponent(topicTitle)}');
                          } else {
                            context.go('/exercises');
                          }
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFF97316),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: AppTokens.radius20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              strings.translate(
                                  en: 'Start exercises',
                                  de: 'Übungen starten',
                                  fa: 'شروع تمرینات'),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 6),
                            const Text('✏️')
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
