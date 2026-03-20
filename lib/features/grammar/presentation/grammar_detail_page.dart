import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/database_providers.dart';
import '../../../core/learning/grammar_progress.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/localization/app_ui_text.dart';
import 'grammar_detail_map.dart';
import 'grammar_rich_detail_page.dart';
import 'grammar_seed.dart';

/// This page shows the explanation, rules, and examples for a grammar topic.
///
/// It also allows users to track their progress and start exercises for the topic.
class GrammarDetailPage extends ConsumerWidget {
  const GrammarDetailPage({
    super.key,
    required this.topicId,
    this.backLevel = 'Alle',
    this.backCategory = 'Alle',
    this.backShowFilters = false,
  });

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
    final grammarAsync = ref.watch(grammarTopicsStreamProvider);
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final liveTopic = grammarAsync.valueOrNull
        ?.where((topic) => topic.id == topicId)
        .toList(growable: false)
        .firstOrNull;
    final seedTopic = grammarTopicsSeed
        .where((topic) => topic.id == topicId)
        .toList(growable: false)
        .firstOrNull;

    if (seedTopic == null && liveTopic == null) {
      return const Center(child: Text('Thema nicht gefunden'));
    }

    final topicTitle = liveTopic?.title ?? seedTopic!.title;
    final topicLevel = liveTopic?.level ?? seedTopic!.level;
    final topicCategory = liveTopic?.category ?? seedTopic!.category;
    final topicIcon = liveTopic?.icon ?? seedTopic!.icon;
    final topicExplanation = liveTopic?.explanation ?? seedTopic!.explanation;
    final topicRule = liveTopic?.rule ?? seedTopic!.rule;
    final topicExamples = seedTopic!.examples;
    final topicProgress = liveTopic?.progress ?? seedTopic.progress;

    Future<void> onMarkLearned() => ref
        .read(appSettingsActionsProvider)
        .updateGrammarProgress(topicId, 100);
    Future<void> onUpdateProgress() => ref
        .read(appSettingsActionsProvider)
        .updateGrammarProgress(topicId, advanceGrammarProgress(topicProgress));

    final detail = grammarDetailMap[topicId];
    if (detail != null) {
      return GrammarRichDetailPage(
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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progressLabel = grammarProgressStateLabel(
      topicProgress,
      isEnglish: strings.isEnglish,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _BackButton(
                  onPressed: () => _goBackToGrammar(context), isDark: isDark),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$topicTitle $topicIcon',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isDark
                                ? AppTokens.darkText
                                : AppTokens.lightText,
                            fontSize: 22)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E3A8A).withValues(alpha: 0.4)
                                : const Color(0xFFDBEAFE),
                            borderRadius: BorderRadius.circular(999)),
                        child: Text(topicLevel,
                            style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? const Color(0xFFBFDBFE)
                                    : const Color(0xFF1D4ED8))),
                      ),
                      const SizedBox(width: 8),
                      Text(topicCategory,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: isDark
                                      ? AppTokens.darkTextMuted
                                      : AppTokens.lightTextMuted)),
                    ]),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 18),
            _Card(
                isDark: isDark,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.menu_book_rounded,
                            size: 18, color: Color(0xFF3B82F6)),
                        const SizedBox(width: 6),
                        Text('Erklärung',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: isDark
                                        ? AppTokens.darkText
                                        : AppTokens.lightText))
                      ]),
                      const SizedBox(height: 10),
                      Text(topicExplanation,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: isDark
                                      ? AppTokens.darkTextMuted
                                      : AppTokens.lightTextMuted)),
                    ])),
            const SizedBox(height: 14),
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
                  ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      Icon(Icons.lightbulb_rounded,
                          size: 18, color: Color(0xFFFDE68A)),
                      SizedBox(width: 6),
                      Text('Regel',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600))
                    ]),
                    const SizedBox(height: 8),
                    Text(topicRule,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15, height: 1.4)),
                  ]),
            ),
            const SizedBox(height: 16),
            Text('Beispiele',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark ? AppTokens.darkText : AppTokens.lightText)),
            const SizedBox(height: 10),
            for (var i = 0; i < topicExamples.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _Card(
                    isDark: isDark,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  gradient: const LinearGradient(colors: [
                                    Color(0xFF60A5FA),
                                    Color(0xFFA855F7)
                                  ])),
                              alignment: Alignment.center,
                              child: Text('${i + 1}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(topicExamples[i],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: isDark
                                              ? AppTokens.darkText
                                              : AppTokens.lightText))),
                        ])),
              ),
            const SizedBox(height: 8),
            _Card(
                isDark: isDark,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text('Fortschritt',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: isDark
                                        ? AppTokens.darkTextMuted
                                        : AppTokens.lightTextMuted)),
                        const Spacer(),
                        Text('$topicProgress%',
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF3B82F6),
                                fontWeight: FontWeight.w600)),
                      ]),
                      const SizedBox(height: 6),
                      Text(progressLabel,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: isDark
                                      ? AppTokens.darkTextMuted
                                      : AppTokens.lightTextMuted)),
                      const SizedBox(height: 8),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                              value: topicProgress / 100,
                              minHeight: 8,
                              backgroundColor: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE5E7EB),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF3B82F6)))),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed:
                                topicProgress >= 100 ? null : onMarkLearned,
                            style: OutlinedButton.styleFrom(
                                foregroundColor: isDark
                                    ? AppTokens.darkText
                                    : AppTokens.lightText,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                side: BorderSide(
                                    color: isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFE2E8F0)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: AppTokens.radius16)),
                            child: Text(
                              strings.either(
                                german: 'Als gelernt markieren',
                                english: 'Mark as learned',
                              ),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: onUpdateProgress,
                            style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: AppTokens.radius16)),
                            child: Text(
                              strings.either(
                                german: 'Fortschritt aktualisieren',
                                english: 'Update progress',
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ]),
                    ])),
            const SizedBox(height: 14),
            if (topicProgress >= 100) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    if (topicTitle.isNotEmpty) {
                      context.go(
                          '/exercises?topic=${Uri.encodeComponent(topicTitle)}');
                    } else {
                      context.go('/exercises');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                      foregroundColor:
                          isDark ? AppTokens.darkText : AppTokens.lightText,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppTokens.radius20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      strings.either(german: 'Fertig', english: 'Completed'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    const Text('✅')
                  ]),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => ref
                      .read(appSettingsActionsProvider)
                      .resetGrammarTopicExercises(topicTitle),
                  style: FilledButton.styleFrom(
                      backgroundColor: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFF94A3B8), // Gray fill
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppTokens.radius20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      strings.either(
                        german: 'Übungen zurücksetzen',
                        english: 'Reset exercises',
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    const Text('🔄')
                  ]),
                ),
              ),
            ] else ...[
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
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      strings.either(
                        german: 'Übungen starten',
                        english: 'Start exercises',
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    const Text('✏️')
                  ]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed, required this.isDark});
  final VoidCallback onPressed;
  final bool isDark;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF64748B),
          ),
        ),
      );
}

/// This card is used to display information like explanations or progress.
class _Card extends StatelessWidget {
  const _Card({required this.isDark, required this.child});
  final bool isDark;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: AppTokens.radius24,
            boxShadow: [
              BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                  blurRadius: 14,
                  offset: const Offset(0, 6))
            ]),
        child: child,
      );
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
