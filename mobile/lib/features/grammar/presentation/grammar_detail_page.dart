import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import 'grammar_detail_map.dart';
import 'grammar_rich_detail_page.dart';
import 'grammar_seed.dart';

class GrammarDetailPage extends StatelessWidget {
  const GrammarDetailPage({super.key, required this.topicId});
  final String topicId;

  @override
  Widget build(BuildContext context) {
    final topic = grammarTopicsSeed.where((t) => t.id == topicId).firstOrNull;
    if (topic == null) {
      return const Center(child: Text('Thema nicht gefunden'));
    }

    // Rich detail view if data exists
    final detail = grammarDetailMap[topicId];
    if (detail != null) {
      return GrammarRichDetailPage(
        topicId: topic.id,
        topicTitle: topic.title,
        topicLevel: topic.level,
        topicProgress: topic.progress,
        detail: detail,
      );
    }

    // Fallback generic layout
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _BackButton(onPressed: () => context.go('/grammar'), isDark: isDark),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(topic.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: isDark ? AppTokens.darkText : AppTokens.lightText, fontSize: 22)),
                const SizedBox(height: 4),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.4) : const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(999)),
                    child: Text(topic.level, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFBFDBFE) : const Color(0xFF1D4ED8))),
                  ),
                  const SizedBox(width: 8),
                  Text(topic.category, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted)),
                ]),
              ])),
              Text(topic.icon, style: const TextStyle(fontSize: 32)),
            ]),
            const SizedBox(height: 18),
            _Card(isDark: isDark, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Icon(Icons.menu_book_rounded, size: 18, color: Color(0xFF3B82F6)), const SizedBox(width: 6), Text('Erklärung', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: isDark ? AppTokens.darkText : AppTokens.lightText))]),
              const SizedBox(height: 10),
              Text(topic.explanation, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted)),
            ])),
            const SizedBox(height: 14),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFA855F7)]), borderRadius: AppTokens.radius24,
                boxShadow: [BoxShadow(color: const Color(0xFFA855F7).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [Icon(Icons.lightbulb_rounded, size: 18, color: Color(0xFFFDE68A)), SizedBox(width: 6), Text('Regel', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))]),
                const SizedBox(height: 8),
                Text(topic.rule, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4)),
              ]),
            ),
            const SizedBox(height: 16),
            Text('Beispiele', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: isDark ? AppTokens.darkText : AppTokens.lightText)),
            const SizedBox(height: 10),
            for (var i = 0; i < topic.examples.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _Card(isDark: isDark, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 28, height: 28, decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), gradient: const LinearGradient(colors: [Color(0xFF60A5FA), Color(0xFFA855F7)])), alignment: Alignment.center, child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
                  const SizedBox(width: 10),
                  Expanded(child: Text(topic.examples[i], style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? AppTokens.darkText : AppTokens.lightText))),
                ])),
              ),
            const SizedBox(height: 8),
            _Card(isDark: isDark, child: Column(children: [
              Row(children: [
                Text('Fortschritt', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted)),
                const Spacer(),
                Text('${topic.progress}%', style: const TextStyle(fontSize: 13, color: Color(0xFF3B82F6), fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: topic.progress / 100, minHeight: 8, backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)))),
            ])),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go('/exercises'),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF97316), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: AppTokens.radius20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('Übung starten', style: TextStyle(fontSize: 16)), SizedBox(width: 6), Text('✏️')]),
              ),
            ),
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
  Widget build(BuildContext context) => Material(
    color: Colors.transparent, borderRadius: AppTokens.radius16,
    child: InkWell(onTap: onPressed, borderRadius: AppTokens.radius16,
      child: Ink(width: 40, height: 40,
        decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white, borderRadius: AppTokens.radius16, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 3))]),
        child: Icon(Icons.arrow_back_rounded, size: 20, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF64748B)))));
}

class _Card extends StatelessWidget {
  const _Card({required this.isDark, required this.child});
  final bool isDark;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: isDark ? const Color(0xFF0F172A) : Colors.white, borderRadius: AppTokens.radius24,
      boxShadow: [BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFE2E8F0).withValues(alpha: 0.8), blurRadius: 14, offset: const Offset(0, 6))]),
    child: child,
  );
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
