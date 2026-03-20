import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/learning/grammar_progress.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/widgets/app_state_view.dart';
import '../../../shared/localization/app_ui_text.dart';
import 'grammar_seed.dart';

// ─── Category gradient colors matching Figma ─────────────────────────────────

List<Color> _categoryGradient(String category) {
  switch (category) {
    case 'Artikel':
    case 'Artikel & Nomen':
      return const [Color(0xFF60A5FA), Color(0xFF2563EB)];
    case 'Satzbau':
      return const [Color(0xFF22D3EE), Color(0xFF0891B2)];
    case 'Fälle':
    case 'Kasus':
      return const [Color(0xFFA78BFA), Color(0xFF7C3AED)];
    case 'Pronomen':
      return const [Color(0xFF2DD4BF), Color(0xFF0D9488)];
    case 'Zeiten':
      return const [Color(0xFFFBBF24), Color(0xFFD97706)];
    case 'Verben':
      return const [Color(0xFF4ADE80), Color(0xFF16A34A)];
    case 'Prapositionen':
    case 'Präpositionen':
      return const [Color(0xFFF472B6), Color(0xFFDB2777)];
    case 'Adjektive':
      return const [Color(0xFFE879F9), Color(0xFFA21CAF)];
    case 'Nebensatze':
    case 'Nebensätze':
      return const [Color(0xFF2DD4BF), Color(0xFF0F766E)];
    case 'Konjunktiv':
      return const [Color(0xFFC084FC), Color(0xFF7C3AED)];
    case 'Partikeln':
      return const [Color(0xFFFB7185), Color(0xFFE11D48)];
    case 'Relativsatze':
    case 'Relativsätze':
      return const [Color(0xFF818CF8), Color(0xFF6366F1)];
    case 'Infinitivkonstruktionen':
      return const [Color(0xFF34D399), Color(0xFF059669)];
    case 'Passiv':
      return const [Color(0xFFFB923C), Color(0xFFEA580C)];
    case 'Indirekte Rede':
      return const [Color(0xFF06B6D4), Color(0xFF0E7490)];
    case 'Konditionalsatze':
    case 'Konditionalsätze':
      return const [Color(0xFF8B5CF6), Color(0xFF6D28D9)];
    case 'Partizipien':
      return const [Color(0xFF6366F1), Color(0xFF4338CA)];
    case 'Nominalisierung':
      return const [Color(0xFFEC4899), Color(0xFFBE185D)];
    case 'Textverknupfung':
    case 'Textverknüpfung':
      return const [Color(0xFF3B82F6), Color(0xFF6366F1)];
    default:
      return const [Color(0xFF9CA3AF), Color(0xFF4B5563)];
  }
}

const Map<String, String> _englishTopicTitles = {
  'Bestimmte Artikel': 'Definite Articles',
  'Satzbau': 'Sentence Structure',
  'Nominativ & Akkusativ': 'Nominative & Accusative',
  'Personalpronomen': 'Personal Pronouns',
  'Präsens': 'Present Tense',
  'Modalverben': 'Modal Verbs',
  'Trennbare Verben': 'Separable Verbs',
  'Präpositionen (Akk/Dat)': 'Prepositions (Acc/Dat)',
  'Adjektive Grundlagen': 'Adjective Basics',
  'Pluralbildung': 'Plural Formation',
  'Negation': 'Negation',
  'Perfekt': 'Perfect Tense',
  'Präteritum': 'Simple Past',
  'Futur I': 'Future I',
  'Nebensätze': 'Subordinate Clauses',
  'Relativsätze (Grundlagen)': 'Relative Clauses (Basics)',
  'Infinitivkonstruktionen': 'Infinitive Constructions',
  'Wechselpräpositionen': 'Two-Way Prepositions',
  'Adjektivdeklination': 'Adjective Declension',
  'Komparativ & Superlativ': 'Comparative & Superlative',
  'Reflexive Verben': 'Reflexive Verbs',
  'Indefinitpronomen': 'Indefinite Pronouns',
  'Dativ': 'Dative',
  'Verben mit Präpositionen': 'Verbs with Prepositions',
  'Passiv (Grundlagen)': 'Passive Voice (Basics)',
  'Plusquamperfekt': 'Past Perfect',
  'Futur I & II': 'Future I & II',
  'Erweiterte Nebensätze': 'Advanced Subordinate Clauses',
  'Konditionalsätze': 'Conditional Clauses',
  'Konjunktiv II': 'Subjunctive II',
  'Relativsätze (Fortgeschritten)': 'Relative Clauses (Advanced)',
  'Partizipien als Adjektive': 'Participles as Adjectives',
  'Nominalisierung': 'Nominalization',
  'Indirekte Rede': 'Reported Speech',
  'Genitiv': 'Genitive',
  'n-Deklination': 'n-Declension',
  'Wortstellung (Fortgeschritten)': 'Advanced Word Order',
  'Konjunktiv I': 'Subjunctive I',
  'Konjunktiv II (Fortgeschritten)': 'Subjunctive II (Advanced)',
  'Passiv': 'Passive Voice',
  'Partizipialkonstruktionen': 'Participial Constructions',
  'Erweiterte Nebensätze (B2)': 'Advanced Subordinate Clauses',
  'Nominalstil': 'Nominal Style',
  'Konnektoren': 'Connectors',
  'Genitiv-Präpositionen': 'Genitive Prepositions',
  'Doppelkonnektoren': 'Paired Conjunctions',
  'Passiversatzformen': 'Passive Alternatives',
  'Funktionsverbgefüge': 'Light-Verb Constructions',
  'Modalpartikeln': 'Modal Particles',
  'Subjektive Modalverben': 'Subjective Modal Verbs',
  'Nomen-Verb-Verbindungen': 'Noun-Verb Collocations',
  'Erweiterte Passivformen': 'Advanced Passive Forms',
  'Weiterführende Nebensätze': 'Advanced Clause Patterns',
  'Apposition': 'Apposition',
  'Komplexe Attribute': 'Complex Attributes',
};

// ─── GrammarPage ─────────────────────────────────────────────────────────────

/// This page shows a list of German grammar topics.
///
/// Users can filter the topics by level (A1, A2, etc.) or by category.
class GrammarPage extends ConsumerStatefulWidget {
  const GrammarPage({
    super.key,
    this.initialLevel = 'Alle',
    this.initialCategory = 'Alle',
    this.initialShowFilters = false,
  });

  final String initialLevel;
  final String initialCategory;
  final bool initialShowFilters;

  @override
  ConsumerState<GrammarPage> createState() => _GrammarPageState();
}

/// This state manages the filtering and display of grammar topics.
class _GrammarPageState extends ConsumerState<GrammarPage> {
  String _selectedLevel = 'Alle';
  String _selectedCategory = 'Alle';
  bool _showFilters = false;

  static const _levels = ['Alle', 'A1', 'A2', 'B1', 'B2', 'C1'];
  static const _categories = [
    'Alle',
    'Artikel',
    'Satzbau',
    'Fälle',
    'Pronomen',
    'Zeiten',
    'Verben',
    'Präpositionen',
    'Adjektive',
    'Nebensätze',
    'Konjunktiv',
    'Partikeln'
  ];

  String _grammarCategoryLabel(AppUiText strings, String category) {
    switch (category) {
      case 'Alle':
        return strings.either(german: 'Alle', english: 'All');
      case 'Artikel':
        return strings.either(german: 'Artikel', english: 'Articles');
      case 'Satzbau':
        return strings.either(german: 'Satzbau', english: 'Sentence structure');
      case 'Fälle':
        return strings.either(german: 'Fälle', english: 'Cases');
      case 'Pronomen':
        return strings.either(german: 'Pronomen', english: 'Pronouns');
      case 'Zeiten':
        return strings.either(german: 'Zeiten', english: 'Tenses');
      case 'Verben':
        return strings.either(german: 'Verben', english: 'Verbs');
      case 'Präpositionen':
        return strings.either(german: 'Präpositionen', english: 'Prepositions');
      case 'Adjektive':
        return strings.either(german: 'Adjektive', english: 'Adjectives');
      case 'Nebensätze':
        return strings.either(
            german: 'Nebensätze', english: 'Subordinate clauses');
      case 'Konjunktiv':
        return strings.either(german: 'Konjunktiv', english: 'Subjunctive');
      case 'Partikeln':
        return strings.either(german: 'Partikeln', english: 'Particles');
      default:
        return category;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedLevel =
        _levels.contains(widget.initialLevel) ? widget.initialLevel : 'Alle';
    _selectedCategory = _categories.contains(widget.initialCategory)
        ? widget.initialCategory
        : 'Alle';
    _showFilters = widget.initialShowFilters;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grammarAsync = ref.watch(grammarTopicsStreamProvider);
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    return grammarAsync.when(
      data: (allTopics) {
        final filtered = allTopics.where((t) {
          if (_selectedLevel != 'Alle' && t.level != _selectedLevel) {
            return false;
          }
          if (_selectedCategory != 'Alle') {
            final cat = _selectedCategory.toLowerCase();
            final tCat = t.category.toLowerCase();
            if (!tCat.contains(cat) && !cat.contains(tCat.split(' ').first)) {
              return false;
            }
          }
          return true;
        }).toList()
          ..sort(_compareGrammarTopics);

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(children: [
                  _IconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onPressed: () => context.go('/'),
                      isDark: isDark),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                            strings.either(
                                german: 'Grammatik 📘', english: 'Grammar 📘'),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: isDark
                                        ? AppTokens.darkText
                                        : AppTokens.lightText)),
                        const SizedBox(height: 2),
                        Text(
                            strings.either(
                                german: 'Regeln & Struktur',
                                english: 'Rules & structure'),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: isDark
                                        ? AppTokens.darkTextMuted
                                        : AppTokens.lightTextMuted)),
                      ])),
                  _IconButton(
                    icon: Icons.filter_alt_rounded,
                    onPressed: () =>
                        setState(() => _showFilters = !_showFilters),
                    isDark: isDark,
                    active: _showFilters,
                  ),
                ]),
                const SizedBox(height: 16),

                // ── Level Filter ──
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _levels.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final level = _levels[i];
                      final selected = _selectedLevel == level;
                      return _LevelChip(
                        label: _grammarCategoryLabel(strings, level),
                        selected: selected,
                        onTap: () => setState(() => _selectedLevel = level),
                        isDark: isDark,
                      );
                    },
                  ),
                ),

                // ── Category Filter (animated) ──
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 220),
                  crossFadeState: _showFilters
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final selected = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFFA855F7)
                                  : (isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFF1F5F9)),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(_grammarCategoryLabel(strings, cat),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: selected
                                        ? Colors.white
                                        : (isDark
                                            ? const Color(0xFFCBD5E1)
                                            : const Color(0xFF64748B)))),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),

                // ── Grammar Cards ──
                if (filtered.isEmpty)
                  AppStateView.empty(
                    title: strings.either(
                        german: 'Keine Themen gefunden',
                        english: 'No topics found'),
                    message: strings.either(
                      german:
                          'Passe Level oder Kategorie an, um passende Grammatikthemen zu sehen.',
                      english:
                          'Adjust the level or category to see matching grammar topics.',
                    ),
                    icon: Icons.search_off_rounded,
                  )
                else
                  for (final topic in filtered)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _GrammarCard(
                        topic: topic,
                        isDark: isDark,
                        strings: strings,
                        onTap: () {
                          final uri = Uri(
                            path: '/grammar/${topic.id}',
                            queryParameters: {
                              'level': _selectedLevel,
                              'category': _selectedCategory,
                              'showFilters': _showFilters ? '1' : '0',
                            },
                          );
                          context.go(uri.toString());
                        },
                      ),
                    ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
          body: AppStateView.loading(
        title: 'Loading grammar',
        message: 'The topics are being synchronized.',
      )),
      error: (e, s) => Scaffold(
          body: AppStateView.error(
        message: 'The grammar could not be loaded.\n$e',
        onAction: () => ref.invalidate(grammarTopicsStreamProvider),
      )),
    );
  }
}

int _compareGrammarTopics(GrammarTopic left, GrammarTopic right) {
  final completionCompare =
      _completionRank(left).compareTo(_completionRank(right));
  if (completionCompare != 0) {
    return completionCompare;
  }

  final rankCompare =
      grammarTopicSortRank(left.id).compareTo(grammarTopicSortRank(right.id));
  if (rankCompare != 0) {
    return rankCompare;
  }

  final titleCompare = left.title.compareTo(right.title);
  if (titleCompare != 0) {
    return titleCompare;
  }

  return left.id.compareTo(right.id);
}

int _completionRank(GrammarTopic topic) =>
    isGrammarTopicCompleted(topic.progress) ? 1 : 0;

// ─── Grammar Card ─────────────────────────────────────────────────────────────

/// This card displays a single grammar topic with its progress and icon.
class _GrammarCard extends StatelessWidget {
  const _GrammarCard({
    required this.topic,
    required this.isDark,
    required this.strings,
    required this.onTap,
  });
  final GrammarTopic topic;
  final bool isDark;
  final AppUiText strings;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradient = _categoryGradient(topic.category);
    final englishTitle = _englishTopicTitles[topic.title];
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
                      ? Colors.black.withOpacity(0.2)
                      : const Color(0xFFE2E8F0).withOpacity(0.8),
                  blurRadius: 16,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Row(children: [
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
                      color: gradient.last.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ],
              ),
              alignment: Alignment.center,
              child: Text(topic.icon, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(topic.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    color: isDark
                                        ? AppTokens.darkText
                                        : AppTokens.lightText),
                            overflow: TextOverflow.ellipsis),
                        if (englishTitle != null) ...[
                          const SizedBox(height: 2),
                          Text(englishTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: isDark
                                          ? AppTokens.darkTextMuted
                                          : AppTokens.lightTextMuted,
                                      fontSize: 11)),
                        ],
                      ],
                    )),
                    const SizedBox(width: 6),
                    // Level badge — blue pill matching Figma
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E3A8A).withOpacity(0.4)
                            : const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(topic.level,
                          style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? const Color(0xFFBFDBFE)
                                  : const Color(0xFF1D4ED8))),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(topic.category,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppTokens.darkTextMuted
                              : AppTokens.lightTextMuted)),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isGrammarTopicCompleted(topic.progress)
                            ? (isDark
                                ? const Color(0xFF052E16)
                                : const Color(0xFFF0FDF4))
                            : (isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFEFF6FF)),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        grammarProgressStateLabel(
                          topic.progress,
                          isEnglish: strings.isEnglish,
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isGrammarTopicCompleted(topic.progress)
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: topic.progress / 100,
                      minHeight: 5,
                      backgroundColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE5E7EB),
                      valueColor: AlwaysStoppedAnimation<Color>(gradient.last),
                    ),
                  ),
                ])),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded,
                color:
                    isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                size: 20),
          ]),
        ),
      ),
    );
  }
}

// ─── Level Chip ──────────────────────────────────────────────────────────────

/// This chip is used for selecting the grammar level filter.
class _LevelChip extends StatelessWidget {
  const _LevelChip(
      {required this.label,
      required this.selected,
      required this.onTap,
      required this.isDark});
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
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : (isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF64748B)))),
      ),
    );
  }
}

// ─── Icon Button ─────────────────────────────────────────────────────────────

class _IconButton extends StatelessWidget {
  const _IconButton(
      {required this.icon,
      required this.onPressed,
      required this.isDark,
      this.active = false});
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
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: active
              ? Colors.white
              : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF64748B)),
        ),
      ),
    );
  }
}
