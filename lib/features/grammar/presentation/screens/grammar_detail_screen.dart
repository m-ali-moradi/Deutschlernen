import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import '../widgets/grammar_detail_widgets.dart';
import '../widgets/grammar_rich_detail_view.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
import '../grammar_seed.dart';
import 'package:deutschmate_mobile/features/grammar/domain/grammar_providers.dart';

/// A detail screen for a specific grammar topic.
///
/// It acts as a wrapper that:
/// 1. Fetches data from the local grammar database.
/// 2. Renders [GrammarRichDetailView] when the topic exists locally.
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
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(uri.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicsAsync = ref.watch(filteredGrammarTopicsProvider);
    final detailAsync = ref.watch(grammarDetailProvider(topicId));
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    // Find the entry from the topics list
    final entry =
        topicsAsync.valueOrNull?.where((e) => e.id == topicId).firstOrNull;

    // Fallback search in seed if hybrid is still loading or doesn't have it
    final seedTopic =
        grammarTopicsSeed.where((topic) => topic.id == topicId).firstOrNull;

    if (entry == null && seedTopic == null) {
      if (topicsAsync.isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return Scaffold(
        appBar: AppBar(
            leading: BackButton(onPressed: () => _goBackToGrammar(context))),
        body: Center(
            child: Text(strings.either(
                german: 'Thema nicht gefunden', english: 'Topic not found'))),
      );
    }

    final topicTitle = entry?.title ?? seedTopic!.title;
    final topicLevel = entry?.level ?? seedTopic!.level;
    final topicCategory = entry?.category ?? seedTopic?.category ?? '';
    final topicIcon = entry?.icon ?? seedTopic?.icon ?? 'book';
    final topicExplanation = entry?.explanation ?? seedTopic?.explanation ?? '';
    final topicRule = entry?.rule ?? seedTopic?.rule ?? '';
    final topicProgress = entry?.progress ?? 0;
    const isDownloaded = true;

    return detailAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('Fehler beim Laden: $err'))),
      data: (detail) {
        if (detail != null) {
          return GrammarRichDetailView(
            topicId: topicId,
            topicTitle: topicTitle,
            topicCategory: topicCategory,
            topicLevel: topicLevel,
            topicProgress: topicProgress,
            detail: detail,
            onBack: () => _goBackToGrammar(context),
            onResetExercises: () => ref
                .read(appSettingsActionsProvider)
                .resetGrammarTopicExercises(topicTitle),
            backLevel: backLevel,
            backCategory: backCategory,
            backShowFilters: backShowFilters,
          );
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textPrimary = isDark ? AppTokens.darkText : AppTokens.lightText;
        final textMuted =
            isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted;

        return Scaffold(
          backgroundColor: AppTokens.background(isDark),
          body: Stack(
            children: [
              // Premium Background
              Positioned.fill(child: AppTokens.meshBackground(isDark)),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Header ---
                      Row(
                        children: [
                          GrammarDetailBackButton(
                            onPressed: () => _goBackToGrammar(context),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$topicTitle $topicIcon',
                                  style: TextStyle(
                                    color: AppTokens.textPrimary(isDark),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF1E3A8A)
                                                  .withValues(alpha: 0.4)
                                              : const Color(0xFFDBEAFE),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        topicLevel,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: isDark
                                                ? const Color(0xFFBFDBFE)
                                                : const Color(0xFF1D4ED8)),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      topicCategory,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              color: textMuted,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // --- Explanation Card ---
                      PremiumCard(
                        padding: const EdgeInsets.all(20),
                        useGlass: true,
                        blur: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.menu_book_rounded,
                                    size: 20, color: Color(0xFF3B82F6)),
                                const SizedBox(width: 8),
                                Text(
                                  strings.translate(
                                    en: 'Explanation',
                                    de: 'Erklärung',
                                    fa: 'توضیحات',
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: textPrimary,
                                          fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(topicExplanation,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: textMuted, height: 1.5)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // --- Rule Card ---
                      if (topicRule.isNotEmpty) ...[
                        PremiumCard(
                          padding: const EdgeInsets.all(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.lightbulb_rounded,
                                      size: 20, color: Color(0xFFFDE68A)),
                                  const SizedBox(width: 8),
                                  Text(
                                    strings.translate(
                                      en: 'Rule',
                                      de: 'Regel',
                                      fa: 'قاعده',
                                    ),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(topicRule,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      height: 1.5)),
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
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: AppTokens.gradientBluePurple,
                              ),
                              borderRadius: AppTokens.radius20,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTokens.primary(isDark)
                                      .withValues(alpha: 0.28),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (topicTitle.isNotEmpty) {
                                  context.push(
                                      '/practice/exercises?topic=${Uri.encodeComponent(topicTitle)}');
                                } else {
                                  context.push('/practice/exercises');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppTokens.radius20,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    strings.translate(
                                        en: 'Start exercises',
                                        de: 'Übungen starten',
                                        fa: 'شروع تمرینات'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text('✏️')
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
