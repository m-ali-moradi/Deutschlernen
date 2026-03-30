import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/shared/widgets/app_icon_button.dart';
import 'package:deutschmate_mobile/features/grammar/data/models/grammar_detail_models.dart';
import 'package:deutschmate_mobile/features/grammar/domain/grammar_logic.dart';
import 'package:deutschmate_mobile/features/grammar/data/models/grammar_topic_type.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';

// ─── Main Widget ──────────────────────────────────────────────────────────────

/// A rich, interactive view for rendering comprehensive grammar topics.
///
/// This widget handles:
/// - Displaying headers with level and category badges.
/// - Rendering a dynamic list of sections (Concept, Examples, Conjugation, etc.).
/// - Localization of UI labels using [AppUiText].
/// - Audio playback for German sentences.
class GrammarRichDetailView extends ConsumerWidget {
  /// Unique ID of the grammar topic.
  final String topicId;

  /// The title of the grammar topic.
  final String topicTitle;

  /// The category (e.g., 'Noun', 'Verb').
  final String topicCategory;

  /// The CEFR level (e.g., 'A1', 'B2').
  final String topicLevel;

  /// User's current progress (0-100).
  final int topicProgress;

  /// The full rich detail payload.
  final GrammarDetailData detail;

  /// Callback for navigation.
  final VoidCallback onBack;

  /// Callback to reset topic-specific exercises.
  final VoidCallback onResetExercises;

  /// Filter state used for returning to the grammar list.
  final String backLevel;
  final String backCategory;
  final bool backShowFilters;

  const GrammarRichDetailView({
    super.key,
    required this.topicId,
    required this.topicTitle,
    required this.topicCategory,
    required this.topicLevel,
    required this.topicProgress,
    required this.detail,
    required this.onBack,
    required this.onResetExercises,
    required this.backLevel,
    required this.backCategory,
    required this.backShowFilters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppTokens.background(isDark),
      body: Stack(
        children: [
          // Premium Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF0F172A),
                          const Color(0xFF1E293B),
                          const Color(0xFF0F172A),
                        ]
                      : [
                          const Color(0xFFF8FAFC),
                          const Color(0xFFF1F5F9),
                          const Color(0xFFE2E8F0),
                        ],
                ),
              ),
            ),
          ),
          if (isDark)
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTokens.primary(true).withValues(alpha: 0.1),
                ),
              ),
            ),
          if (isDark)
            Positioned(
              bottom: -100,
              left: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6366F1).withValues(alpha: 0.05),
                ),
              ),
            ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  _Header(
                    title: topicTitle,
                    category: topicCategory,
                    level: topicLevel,
                    subtitle: detail.subtitle,
                    levelBg: isDark
                        ? detail.levelBg.withValues(alpha: 0.25)
                        : detail.levelBg,
                    levelText: detail.levelText,
                    onBack: onBack,
                  ),
                  const SizedBox(height: 24),

                  // ── Dynamic Sections ──
                  for (final section in detail.sections) ...[
                    _RenderSection(section: section, strings: strings),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 8),

                  // ── Exercise Button ──
                  if (topicProgress >= 100) ...[
                    PremiumCard(
                      padding: EdgeInsets.zero,
                      blur: 15,
                      child: InkWell(
                        onTap: () => context.push(
                          resolveGrammarExerciseRoute(
                            topicId: topicId,
                            title: topicTitle,
                            category: topicCategory,
                            level: topicLevel,
                            backLevel: backLevel,
                            backCategory: backCategory,
                            backShowFilters: backShowFilters,
                          ),
                        ),
                        borderRadius: AppTokens.radius24,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                strings.grammarLabel('completed'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AppTokens.darkText
                                          : AppTokens.lightText,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.check_circle_rounded,
                                  size: 20, color: Colors.green),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: onResetExercises,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: Text(strings.grammarLabel('reset_exercises')),
                        style: TextButton.styleFrom(
                          foregroundColor: isDark
                              ? AppTokens.darkTextMuted
                              : AppTokens.lightTextMuted,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: AppTokens.radius24,
                          boxShadow: [
                            BoxShadow(
                              color: AppTokens.primary(isDark)
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => context.push(
                            resolveGrammarExerciseRoute(
                              topicId: topicId,
                              title: topicTitle,
                              category: topicCategory,
                              level: topicLevel,
                              backLevel: backLevel,
                              backCategory: backCategory,
                              backShowFilters: backShowFilters,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTokens.primary(isDark),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppTokens.radius24,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                strings.grammarLabel('start_exercises'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.category,
    required this.level,
    required this.subtitle,
    required this.levelBg,
    required this.levelText,
    required this.onBack,
  });

  final String title, category, level, subtitle;
  final Color levelBg, levelText;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        PremiumCard(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(12),
          child: AppIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            iconSize: 16,
            onPressed: onBack,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: isDark
                                ? AppTokens.darkText
                                : AppTokens.lightText,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTokens.primary(isDark).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      getGrammarCategoryIcon(category, title),
                      color: AppTokens.primary(isDark),
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: levelBg.withValues(alpha: isDark ? 0.2 : 0.8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: levelBg.withValues(alpha: 0.3),
                          width: 1,
                        )),
                    child: Text(level,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isDark ? levelBg : levelText,
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppTokens.darkTextMuted
                                : AppTokens.lightTextMuted,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
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

class _RenderSection extends StatelessWidget {
  const _RenderSection({required this.section, required this.strings});
  final GrammarSection section;
  final AppUiText strings;

  @override
  Widget build(BuildContext context) {
    if (section is ConceptSection) {
      return _ConceptCard(s: section as ConceptSection, strings: strings);
    }
    if (section is FormulaSection) {
      return _FormulaCard(s: section as FormulaSection);
    }
    if (section is ConjugationSection) {
      return _ConjugationCard(
          s: section as ConjugationSection, strings: strings);
    }
    if (section is ExamplesSection) {
      return _ExamplesCard(s: section as ExamplesSection, strings: strings);
    }
    if (section is ComparisonSection) {
      return _ComparisonCard(s: section as ComparisonSection, strings: strings);
    }
    if (section is RulesSection) {
      return _RulesCard(s: section as RulesSection, strings: strings);
    }
    if (section is TipSection) return _TipCard(s: section as TipSection);
    if (section is TransformSection) {
      return _TransformCard(s: section as TransformSection, strings: strings);
    }
    return const SizedBox.shrink();
  }
}

// ─── ConceptCard ──────────────────────────────────────────────────────────────

class _ConceptCard extends StatelessWidget {
  const _ConceptCard({required this.s, required this.strings});
  final ConceptSection s;
  final AppUiText strings;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTokens.primary(isDark).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: AppTokens.primary(isDark),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
                child: Text(
              strings.grammarSectionTitle(s.title),
              style: _titleStyle(context, isDark),
            )),
          ]),
          const SizedBox(height: 16),
          Text(s.text, style: _bodyStyle(context, isDark)),
          if (s.bullets != null) ...[
            const SizedBox(height: 18),
            Container(
              decoration: BoxDecoration(
                  color: AppTokens.primary(isDark)
                      .withValues(alpha: isDark ? 0.08 : 0.04),
                  borderRadius: AppTokens.radius16,
                  border: Border.all(
                    color: AppTokens.primary(isDark).withValues(alpha: 0.1),
                  )),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: s.bullets!
                    .map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Icon(Icons.check_circle_outline_rounded,
                                      size: 16, color: AppTokens.primary(isDark)),
                                ),
                                const SizedBox(width: 10),
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

class _ConjugationCard extends StatelessWidget {
  const _ConjugationCard({required this.s, required this.strings});
  final ConjugationSection s;
  final AppUiText strings;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = s.color;
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: c.bg.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.table_chart_outlined,
                color: c.bg,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(strings.grammarSectionTitle(s.title),
                style: _subtitleStyle(context, isDark)),
          ]),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: AppTokens.radius16,
            child: Column(
              children: s.rows.asMap().entries.map((e) {
                final even = e.key % 2 == 0;
                return Container(
                  color: even 
                    ? c.bg.withValues(alpha: isDark ? 0.1 : 0.05) 
                    : Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(children: [
                    SizedBox(
                        width: 110,
                        child: Text(e.value.left,
                            style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppTokens.darkText : AppTokens.lightText,
                                fontWeight: FontWeight.w600))),
                    Expanded(
                      child: Text(e.value.right,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 14, 
                              fontFamily: 'monospace',
                              color: isDark ? AppTokens.darkText : AppTokens.lightText,
                          )),
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

class _ExamplesCard extends StatelessWidget {
  const _ExamplesCard({required this.s, required this.strings});
  final ExamplesSection s;
  final AppUiText strings;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = s.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(strings.grammarSectionTitle(s.title),
              style: _smallMutedStyle(context, isDark)?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                fontSize: 11,
              )),
        ),
        for (var i = 0; i < s.items.length; i++) ...[
          PremiumCard(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: c.bg.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: c.bg.withValues(alpha: 0.2)),
                ),
                alignment: Alignment.center,
                child: Text('${i + 1}',
                    style: TextStyle(
                        color: c.bg,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(s.items[i].de,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isDark
                                ? AppTokens.darkText
                                : AppTokens.lightText,
                            fontWeight: FontWeight.w600,
                            height: 1.4)),
                    const SizedBox(height: 4),
                    Text(s.items[i].translation,
                        style: TextStyle(
                            fontSize: 13,
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

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.s, required this.strings});
  final ComparisonSection s;
  final AppUiText strings;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF64748B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.compare_arrows_rounded,
                color: Color(0xFF64748B),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(strings.grammarSectionTitle(s.title),
                    style: _subtitleStyle(context, isDark))),
          ]),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ClipRRect(
              borderRadius: AppTokens.radius16,
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                border: TableBorder(
                    horizontalInside: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.05),
                        width: 1)),
                children: [
                  // Header row
                  TableRow(
                    decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.02)),
                    children: s.headers
                        .map((h) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Text(h,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
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
                              ? Colors.transparent
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.02)
                                  : Colors.black.withValues(alpha: 0.01))),
                      children: s.rows[i].cells
                          .map((cell) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                child: Text(cell,
                                    style: TextStyle(
                                        fontSize: 13,
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

class _RulesCard extends StatelessWidget {
  const _RulesCard({required this.s, required this.strings});
  final RulesSection s;
  final AppUiText strings;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                size: 20,
                color: Color(0xFFFDE68A),
              ),
            ),
            const SizedBox(width: 14),
            Text(strings.grammarSectionTitle(s.title),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3)),
          ]),
          const SizedBox(height: 20),
          for (var i = 0; i < s.items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      )),
                  alignment: Alignment.center,
                  child: Text('${i + 1}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(s.items[i],
                        style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 14, 
                            height: 1.5,
                            fontWeight: FontWeight.w500))),
              ]),
            ),
        ],
      ),
    );
  }
}

// ─── TipCard ─────────────────────────────────────────────────────────────────

class _TipCard extends StatelessWidget {
  const _TipCard({required this.s});
  final TipSection s;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color bg, iconColor;
    IconData icon;
    switch (s.variant) {
      case TipVariant.warning:
        bg = const Color(0xFFF59E0B);
        iconColor = const Color(0xFFF59E0B);
        icon = Icons.warning_amber_rounded;
        break;
      case TipVariant.success:
        bg = const Color(0xFF22C55E);
        iconColor = const Color(0xFF22C55E);
        icon = Icons.check_circle_outline_rounded;
        break;
      default: // info
        bg = AppTokens.primary(isDark);
        iconColor = AppTokens.primary(isDark);
        icon = Icons.info_outline_rounded;
    }
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: bg.withValues(alpha: isDark ? 0.15 : 0.08),
      borderOpacity: 0.2,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
            child: Text(s.text,
                style: TextStyle(
                    fontSize: 13, 
                    color: isDark ? AppTokens.darkText : AppTokens.lightText, 
                    height: 1.5,
                    fontWeight: FontWeight.w500))),
      ]),
    );
  }
}

// ─── TransformCard ───────────────────────────────────────────────────────────

class _TransformCard extends StatelessWidget {
  const _TransformCard({required this.s, required this.strings});
  final TransformSection s;
  final AppUiText strings;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.grammarSectionTitle(s.title),
              style: _subtitleStyle(context, isDark)),
          const SizedBox(height: 16),
          _TransformBox(
            label: s.from.label,
            text: s.from.text,
            isDark: isDark,
            color: const Color(0xFF22C55E),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(children: [
              const SizedBox(width: 20),
              const Icon(Icons.keyboard_double_arrow_down_rounded,
                  size: 20, color: Color(0xFFF97316)),
              if (s.note != null) ...[
                const SizedBox(width: 10),
                Flexible(
                    child: Text(s.note!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppTokens.darkTextMuted
                              : AppTokens.lightTextMuted,
                          fontStyle: FontStyle.italic,
                        )))
              ],
            ]),
          ),
          _TransformBox(
            label: s.to.label,
            text: s.to.text,
            isDark: isDark,
            color: const Color(0xFFF97316),
            isBottom: true,
          ),
        ],
      ),
    );
  }
}

class _TransformBox extends StatelessWidget {
  const _TransformBox({
    required this.label,
    required this.text,
    required this.isDark,
    required this.color,
    this.isBottom = false,
  });

  final String label, text;
  final bool isDark, isBottom;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.05),
        borderRadius: AppTokens.radius16,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0)),
          const SizedBox(height: 6),
          Text(text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppTokens.darkText : AppTokens.lightText,
                    fontWeight: FontWeight.w600,
                  )),
        ],
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────



TextStyle? _titleStyle(BuildContext ctx, bool isDark) =>
    Theme.of(ctx).textTheme.titleSmall?.copyWith(
        color: isDark ? AppTokens.darkText : AppTokens.lightText, 
        fontSize: 16,
        fontWeight: FontWeight.w700);
TextStyle? _subtitleStyle(BuildContext ctx, bool isDark) =>
    Theme.of(ctx).textTheme.titleSmall?.copyWith(
        color: isDark ? AppTokens.darkText : AppTokens.lightText, 
        fontSize: 15,
        fontWeight: FontWeight.w700);
TextStyle? _bodyStyle(BuildContext ctx, bool isDark) =>
    Theme.of(ctx).textTheme.bodyMedium?.copyWith(
        color: isDark ? AppTokens.darkText : AppTokens.lightText,
        height: 1.6);
TextStyle? _smallStyle(BuildContext ctx, bool isDark) =>
    Theme.of(ctx).textTheme.bodyMedium?.copyWith(
        fontSize: 13,
        color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted);
TextStyle? _smallMutedStyle(BuildContext ctx, bool isDark) =>
    Theme.of(ctx).textTheme.bodySmall?.copyWith(
        color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted);



