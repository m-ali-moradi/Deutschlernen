import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/learning/grammar_exercise_route.dart';
import '../../../core/theme/app_tokens.dart';
import 'grammar_section.dart';

// ─── Main Widget ──────────────────────────────────────────────────────────────

/// This page shows a beautiful, detailed explanation of a grammar topic.
///
/// It uses dynamic sections like tables, examples, and rules to help the user learn.
class GrammarRichDetailPage extends StatelessWidget {
  const GrammarRichDetailPage({
    super.key,
    required this.topicTitle,
    required this.topicCategory,
    required this.topicLevel,
    required this.topicProgress,
    required this.detail,
    required this.onBack,
    required this.onResetExercises,
  });

  final String topicTitle;
  final String topicCategory;
  final String topicLevel;
  final int topicProgress;
  final GrammarDetailData detail;
  final VoidCallback onBack;
  final VoidCallback onResetExercises;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            _Header(
              title: '$topicTitle ${detail.emoji}',
              level: topicLevel,
              subtitle: detail.subtitle,
              levelBg: isDark
                  ? detail.levelBg.withValues(alpha: 0.25)
                  : detail.levelBg,
              levelText: detail.levelText,
              onBack: onBack,
            ),
            const SizedBox(height: 20),

            // ── Dynamic Sections ──
            for (final section in detail.sections) ...[
              _RenderSection(section: section),
              const SizedBox(height: 14),
            ],

            // ── Exercise Button ──
            if (topicProgress >= 100) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go(
                    resolveGrammarExerciseRoute(
                      title: topicTitle,
                      category: topicCategory,
                      level: topicLevel,
                    ),
                  ),
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
                      _localizedUiLabel(
                        context,
                        german: 'Fertig',
                        english: 'Completed',
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    const Text('✅'),
                  ]),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onResetExercises,
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
                      _localizedUiLabel(
                        context,
                        german: 'Übungen zurücksetzen',
                        english: 'Reset exercises',
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    const Text('🔄'),
                  ]),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go(
                    resolveGrammarExerciseRoute(
                      title: topicTitle,
                      category: topicCategory,
                      level: topicLevel,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF97316),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: AppTokens.radius20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _localizedUiLabel(
                          context,
                          german: 'Übungen starten',
                          english: 'Start exercises',
                        ),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      const Text('✏️'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

/// This widget builds the header with the title, level, and emoji.
class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.level,
    required this.subtitle,
    required this.levelBg,
    required this.levelText,
    required this.onBack,
  });

  final String title, level, subtitle;
  final Color levelBg, levelText;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        _SmallIconButton(icon: Icons.arrow_back_rounded, onPressed: onBack),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isDark ? AppTokens.darkText : AppTokens.lightText,
                      fontSize: 22)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: levelBg,
                        borderRadius: BorderRadius.circular(999)),
                    child: Text(level,
                        style: TextStyle(fontSize: 11, color: levelText)),
                  ),
                  const SizedBox(width: 8),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppTokens.darkTextMuted
                              : AppTokens.lightTextMuted)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Section Dispatcher ───────────────────────────────────────────────────────

/// This widget chooses which type of section to render (e.g., table or text).
class _RenderSection extends StatelessWidget {
  const _RenderSection({required this.section});
  final GrammarSection section;

  @override
  Widget build(BuildContext context) {
    if (section is ConceptSection) {
      return _ConceptCard(s: section as ConceptSection);
    }
    if (section is FormulaSection) {
      return _FormulaCard(s: section as FormulaSection);
    }
    if (section is ConjugationSection) {
      return _ConjugationCard(s: section as ConjugationSection);
    }
    if (section is ExamplesSection) {
      return _ExamplesCard(s: section as ExamplesSection);
    }
    if (section is ComparisonSection) {
      return _ComparisonCard(s: section as ComparisonSection);
    }
    if (section is RulesSection) return _RulesCard(s: section as RulesSection);
    if (section is TipSection) return _TipCard(s: section as TipSection);
    if (section is TransformSection) {
      return _TransformCard(s: section as TransformSection);
    }
    return const SizedBox.shrink();
  }
}

// ─── ConceptCard ──────────────────────────────────────────────────────────────

/// This card shows a clear and simple explanation of a grammar concept.
class _ConceptCard extends StatelessWidget {
  const _ConceptCard({required this.s});
  final ConceptSection s;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: _cardDecoration(isDark),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _ColoredIcon(
                icon: Icons.menu_book_rounded,
                color: const Color(0xFF3B82F6),
                size: 16,
                boxSize: 32,
                radius: 10),
            const SizedBox(width: 10),
            Expanded(
                child: Text(
              _localizedSectionTitle(context, s.title),
              style: _titleStyle(context, isDark),
            )),
          ]),
          const SizedBox(height: 10),
          Text(s.text, style: _bodyStyle(context, isDark)),
          if (s.bullets != null) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6)
                      .withValues(alpha: isDark ? 0.15 : 0.07),
                  borderRadius: AppTokens.radius16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                children: s.bullets!
                    .map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle_outline_rounded,
                                    size: 14, color: const Color(0xFF3B82F6)),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(b,
                                        style: _smallStyle(context, isDark))),
                              ]),
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── FormulaCard ─────────────────────────────────────────────────────────────

/// This card shows a formula or a pattern for the grammar topic.
class _FormulaCard extends StatelessWidget {
  const _FormulaCard({required this.s});
  final FormulaSection s;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: s.colors),
          borderRadius: AppTokens.radius16,
          boxShadow: [
            BoxShadow(
                color: s.colors.last.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt_rounded, size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Text('${s.label}: ',
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Flexible(
                child: Text(s.formula,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }
}

// ─── ConjugationCard ─────────────────────────────────────────────────────────

/// This card displays a table with word forms or verb changes.
class _ConjugationCard extends StatelessWidget {
  const _ConjugationCard({required this.s});
  final ConjugationSection s;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = s.color;
    return Container(
      decoration: _cardDecoration(isDark),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _ColoredIcon(
                icon: Icons.table_chart_outlined,
                color: c.bg,
                size: 14,
                boxSize: 28,
                radius: 8),
            const SizedBox(width: 8),
            Text(_localizedSectionTitle(context, s.title),
                style: _subtitleStyle(context, isDark)),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: AppTokens.radius16,
            child: Column(
              children: s.rows.asMap().entries.map((e) {
                final even = e.key % 2 == 0;
                return Container(
                  color: even
                      ? c.lightBg
                      : (isDark ? const Color(0xFF0F172A) : Colors.white),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  child: Row(children: [
                    SizedBox(
                        width: 100,
                        child: Text(e.value.left,
                            style: TextStyle(
                                fontSize: 13,
                                color: c.text,
                                fontWeight: FontWeight.w500))),
                    Expanded(
                      child: Text(e.value.right,
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 12.5, fontFamily: 'monospace')),
                    ),
                  ]),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ExamplesCard ─────────────────────────────────────────────────────────────

/// This card shows example sentences in both German and English.
class _ExamplesCard extends StatelessWidget {
  const _ExamplesCard({required this.s});
  final ExamplesSection s;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = s.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(_localizedSectionTitle(context, s.title),
              style: _smallMutedStyle(context, isDark)),
        ),
        for (var i = 0; i < s.items.length; i++) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                  : Colors.white,
              borderRadius: AppTokens.radius20,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3))
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: c.bg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('${i + 1}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(s.items[i].de,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppTokens.darkText
                                : AppTokens.lightText)),
                    const SizedBox(height: 2),
                    Text(s.items[i].en,
                        style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppTokens.darkTextMuted
                                : AppTokens.lightTextMuted,
                            fontStyle: FontStyle.italic)),
                  ])),
            ]),
          ),
        ],
      ],
    );
  }
}

// ─── ComparisonCard ──────────────────────────────────────────────────────────

/// This card shows a table to compare different grammar rules.
class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.s});
  final ComparisonSection s;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: _cardDecoration(isDark),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _ColoredIcon(
                icon: Icons.table_chart_outlined,
                color: const Color(0xFF64748B),
                size: 14,
                boxSize: 28,
                radius: 8),
            const SizedBox(width: 8),
            Expanded(
                child: Text(_localizedSectionTitle(context, s.title),
                    style: _subtitleStyle(context, isDark))),
          ]),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ClipRRect(
              borderRadius: AppTokens.radius16,
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                border: TableBorder(
                    horizontalInside: BorderSide(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE5E7EB),
                        width: 0.5)),
                children: [
                  // Header row
                  TableRow(
                    decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9)),
                    children: s.headers
                        .map((h) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Text(h,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppTokens.darkTextMuted
                                          : AppTokens.lightTextMuted)),
                            ))
                        .toList(),
                  ),
                  // Data rows
                  for (var i = 0; i < s.rows.length; i++)
                    TableRow(
                      decoration: BoxDecoration(
                          color: i % 2 == 0
                              ? (isDark
                                  ? const Color(0xFF0F172A)
                                      .withValues(alpha: 0.5)
                                  : const Color(0xFFF8FAFC))
                              : (isDark
                                  ? const Color(0xFF0F172A)
                                  : Colors.white)),
                      children: s.rows[i].cells
                          .map((cell) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 9),
                                child: Text(cell,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppTokens.darkText
                                            : AppTokens.lightText)),
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── RulesCard ───────────────────────────────────────────────────────────────

/// This card shows important rules the user should remember.
class _RulesCard extends StatelessWidget {
  const _RulesCard({required this.s});
  final RulesSection s;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.lightbulb_rounded,
                size: 18, color: Color(0xFFFDE68A)),
            const SizedBox(width: 8),
            Text(_localizedRulesTitle(context, s.title),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 12),
          for (var i = 0; i < s.items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('${i + 1}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(s.items[i],
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13, height: 1.4))),
              ]),
            ),
        ],
      ),
    );
  }
}

String _localizedRulesTitle(BuildContext context, String title) {
  if (title != 'Merke dir!') {
    return title;
  }

  final languageCode = Localizations.localeOf(context).languageCode;
  return languageCode == 'de' ? 'Merke dir!' : 'Remember!';
}

String _localizedSectionTitle(BuildContext context, String title) {
  final languageCode = Localizations.localeOf(context).languageCode;
  final isGerman = languageCode == 'de';

  switch (title) {
    case 'Merke dir!':
      return isGerman ? 'Merke dir!' : 'Remember!';
    case 'Beispiele':
      return isGerman ? 'Beispiele' : 'Examples';
    case 'Erklärung':
      return isGerman ? 'Erklärung' : 'Explanation';
    case 'Regel':
      return isGerman ? 'Regel' : 'Rule';
    case 'Wichtige Regeln':
      return isGerman ? 'Wichtige Regeln' : 'Important rules';
    default:
      return title;
  }
}

// ─── TipCard ─────────────────────────────────────────────────────────────────

/// This card shows helpful tips or warnings about common mistakes.
class _TipCard extends StatelessWidget {
  const _TipCard({required this.s});
  final TipSection s;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color bg, border, iconColor, textColor;
    IconData icon;
    switch (s.variant) {
      case TipVariant.warning:
        bg = isDark
            ? const Color(0xFFF59E0B).withValues(alpha: 0.15)
            : const Color(0xFFFFFBEB);
        border = isDark ? const Color(0xFFD97706) : const Color(0xFFFDE68A);
        iconColor = const Color(0xFFF59E0B);
        textColor = isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);
        icon = Icons.warning_amber_rounded;
        break;
      case TipVariant.success:
        bg = isDark
            ? const Color(0xFF22C55E).withValues(alpha: 0.15)
            : const Color(0xFFF0FDF4);
        border = isDark ? const Color(0xFF16A34A) : const Color(0xFFBBF7D0);
        iconColor = const Color(0xFF22C55E);
        textColor = isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D);
        icon = Icons.check_circle_outline_rounded;
        break;
      default: // info
        bg = isDark
            ? const Color(0xFF3B82F6).withValues(alpha: 0.15)
            : const Color(0xFFEFF6FF);
        border = isDark ? const Color(0xFF1D4ED8) : const Color(0xFFBFDBFE);
        iconColor = const Color(0xFF3B82F6);
        textColor = isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8);
        icon = Icons.info_outline_rounded;
    }
    return Container(
      decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: AppTokens.radius16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 15, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
            child: Text(s.text,
                style:
                    TextStyle(fontSize: 12, color: textColor, height: 1.45))),
      ]),
    );
  }
}

// ─── TransformCard ───────────────────────────────────────────────────────────

/// This card shows how a sentence changes from one form to another.
class _TransformCard extends StatelessWidget {
  const _TransformCard({required this.s});
  final TransformSection s;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: _cardDecoration(isDark),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.title, style: _subtitleStyle(context, isDark)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF14532D).withValues(alpha: 0.4)
                  : const Color(0xFFF0FDF4),
              border: Border.all(
                  color: isDark
                      ? const Color(0xFF166534)
                      : const Color(0xFFBBF7D0)),
              borderRadius: AppTokens.radius12,
            ),
            padding: const EdgeInsets.all(12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.from.label,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF22C55E),
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(s.from.text, style: Theme.of(context).textTheme.bodyMedium),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(children: [
              const SizedBox(width: 12),
              const Icon(Icons.arrow_downward_rounded,
                  size: 14, color: Color(0xFFF97316)),
              if (s.note != null) ...[
                const SizedBox(width: 6),
                Flexible(
                    child: Text(s.note!,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey)))
              ],
            ]),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF7C2D12).withValues(alpha: 0.4)
                  : const Color(0xFFFFF7ED),
              border: Border.all(
                  color: isDark
                      ? const Color(0xFF9A3412)
                      : const Color(0xFFFED7AA)),
              borderRadius: AppTokens.radius12,
            ),
            padding: const EdgeInsets.all(12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.to.label,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFF97316),
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(s.to.text, style: Theme.of(context).textTheme.bodyMedium),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

class _SmallIconButton extends StatelessWidget {
  const _SmallIconButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
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
          icon == Icons.arrow_back_rounded
              ? Icons.arrow_back_ios_new_rounded
              : icon,
          size: 16,
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

String _localizedUiLabel(
  BuildContext context, {
  required String german,
  required String english,
}) {
  return Localizations.localeOf(context).languageCode == 'de'
      ? german
      : english;
}

class _ColoredIcon extends StatelessWidget {
  const _ColoredIcon(
      {required this.icon,
      required this.color,
      required this.size,
      required this.boxSize,
      required this.radius});
  final IconData icon;
  final Color color;
  final double size, boxSize, radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}

BoxDecoration _cardDecoration(bool isDark) => BoxDecoration(
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      borderRadius: AppTokens.radius24,
      boxShadow: [
        BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.8),
            blurRadius: 14,
            offset: const Offset(0, 6))
      ],
    );

TextStyle? _titleStyle(BuildContext ctx, bool isDark) =>
    Theme.of(ctx).textTheme.titleSmall?.copyWith(
        color: isDark ? AppTokens.darkText : AppTokens.lightText, fontSize: 15);
TextStyle? _subtitleStyle(BuildContext ctx, bool isDark) =>
    Theme.of(ctx).textTheme.titleSmall?.copyWith(
        color: isDark ? AppTokens.darkText : AppTokens.lightText, fontSize: 14);
TextStyle? _bodyStyle(BuildContext ctx, bool isDark) =>
    Theme.of(ctx).textTheme.bodyMedium?.copyWith(
        color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted,
        height: 1.5);
TextStyle? _smallStyle(BuildContext ctx, bool isDark) =>
    Theme.of(ctx).textTheme.bodySmall?.copyWith(
        color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted);
TextStyle? _smallMutedStyle(BuildContext ctx, bool isDark) =>
    Theme.of(ctx).textTheme.bodySmall?.copyWith(
        color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted);
