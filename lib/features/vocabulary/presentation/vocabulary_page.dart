import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/content/phrase_content_service.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/learning/review_logic.dart';
import '../../../core/learning/vocabulary_review.dart';
import '../../../shared/widgets/app_state_view.dart';
import '../../../shared/localization/app_ui_text.dart';

typedef VocabWord = VocabularyWord;

class BizCategory {
  const BizCategory({
    required this.name,
    required this.icon,
    required this.gradient,
  });

  final String name;
  final String icon;
  final List<Color> gradient;
}

const _categories = [
  BizCategory(
      name: 'Bewerbung & Karriere',
      icon: '💼',
      gradient: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
  BizCategory(
      name: 'Meetings',
      icon: '🤝',
      gradient: [Color(0xFF0EA5E9), Color(0xFF0284C7)]),
  BizCategory(
      name: 'Finanzen',
      icon: '💰',
      gradient: [Color(0xFF22C55E), Color(0xFF15803D)]),
  BizCategory(
      name: 'Büro Kommunikation',
      icon: '📧',
      gradient: [Color(0xFFF59E0B), Color(0xFFD97706)]),
  BizCategory(
      name: 'IT & Technik',
      icon: '💻',
      gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
  BizCategory(
      name: 'Verträge',
      icon: '📋',
      gradient: [Color(0xFFEC4899), Color(0xFFDB2777)]),
  BizCategory(
      name: 'Marketing',
      icon: '📢',
      gradient: [Color(0xFFF97316), Color(0xFFEA580C)]),
  BizCategory(
      name: 'Bildung',
      icon: '🎓',
      gradient: [Color(0xFF14B8A6), Color(0xFF0D9488)]),
  BizCategory(
      name: 'Verhandlungen & Verträge',
      icon: '🤝',
      gradient: [Color(0xFF6366F1), Color(0xFF4338CA)]),
  BizCategory(
      name: 'Projektmanagement',
      icon: '📊',
      gradient: [Color(0xFFF59E0B), Color(0xFFD97706)]),
  BizCategory(
      name: 'Wirtschaft & Märkte',
      icon: '📈',
      gradient: [Color(0xFF10B981), Color(0xFF059669)]),
  BizCategory(
      name: 'Abstrakte Konzepte',
      icon: '💡',
      gradient: [Color(0xFF8B5CF6), Color(0xFF6D28D9)]),
  BizCategory(
      name: 'Akademischer Diskurs',
      icon: '📖',
      gradient: [Color(0xFFF43F5E), Color(0xFFE11D48)]),
  BizCategory(
      name: 'Unternehmensführung',
      icon: '🏛️',
      gradient: [Color(0xFF64748B), Color(0xFF334155)]),
];

final _phrases = PhraseContentService.businessPhrases;

String _categoryLabel(AppUiText strings, String category) {
  switch (category) {
    case 'Bewerbung & Karriere':
      return strings.either(
          german: 'Bewerbung & Karriere', english: 'Applications & careers');
    case 'Meetings':
      return strings.either(german: 'Meetings', english: 'Meetings');
    case 'Finanzen':
      return strings.either(german: 'Finanzen', english: 'Finance');
    case 'Büro Kommunikation':
      return strings.either(
          german: 'Büro Kommunikation', english: 'Office communication');
    case 'IT & Technik':
      return strings.either(german: 'IT & Technik', english: 'IT & technology');
    case 'Verträge':
      return strings.either(german: 'Verträge', english: 'Contracts');
    case 'Marketing':
      return strings.either(german: 'Marketing', english: 'Marketing');
    case 'Bildung':
      return strings.either(german: 'Bildung', english: 'Education');
    case 'Verhandlungen & Verträge':
      return strings.either(
          german: 'Verhandlungen & Verträge',
          english: 'Negotiations & contracts');
    case 'Projektmanagement':
      return strings.either(
          german: 'Projektmanagement', english: 'Project management');
    case 'Wirtschaft & Märkte':
      return strings.either(
          german: 'Wirtschaft & Märkte', english: 'Economy & markets');
    case 'Abstrakte Konzepte':
      return strings.either(
          german: 'Abstrakte Konzepte', english: 'Abstract concepts');
    case 'Akademischer Diskurs':
      return strings.either(
          german: 'Akademischer Diskurs', english: 'Academic discourse');
    case 'Unternehmensführung':
      return strings.either(
          german: 'Unternehmensführung', english: 'Leadership');
    default:
      return category;
  }
}

int _categoryLearnedCount(
  List<VocabWord> words,
  Map<String, VocabularyReviewInfo> reviewById,
  String category,
) {
  return words.where((word) {
    if (word.category != category) {
      return false;
    }
    final reviewInfo = reviewById[word.id];
    return reviewInfo != null &&
        reviewInfo.status != VocabularyReviewStatus.newWord;
  }).length;
}

int _categoryTotalCount(List<VocabWord> words, String category) {
  return words.where((word) => word.category == category).length;
}

// ─── VocabularyPage ───────────────────────────────────────────────────────────
/// This page shows lists of German words grouped by category.
///
/// It allows users to study words, mark favorites, and use flashcards.
class VocabularyPage extends ConsumerStatefulWidget {
  const VocabularyPage({
    super.key,
    this.initialCategory,
    this.initialTab = 'words',
    this.initialWordId,
  });

  final String? initialCategory;
  final String initialTab;
  final String? initialWordId;

  @override
  ConsumerState<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends ConsumerState<VocabularyPage>
    with SingleTickerProviderStateMixin {
  String _tab = 'words';
  String _search = '';
  String? _selectedCategory;
  bool _flashcardMode = false;
  VocabWord? _selectedWord;
  int _flashcardIndex = 0;
  bool _isFlipped = false;
  bool _isDari = false;
  List<String> _flashcardQueueIds = const [];
  bool _didApplyInitialWordSelection = false;
  bool _flashcardsOpenedFromCategory = false;

  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;

  AppUiText get strings => AppUiText(ref.watch(displayLanguageProvider));

  final _tabs = const [
    ('words', 'Wörter'),
    ('phrases', 'Phrasen'),
    ('favorites', 'Favoriten'),
  ];

  @override
  void initState() {
    super.initState();
    if (_tabs.any((tab) => tab.$1 == widget.initialTab)) {
      _tab = widget.initialTab;
    }
    _selectedCategory = widget.initialCategory;
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_flipController.isAnimating) return;
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    _isFlipped = !_isFlipped;
  }

  List<VocabWord> _filter(
    List<VocabWord> allWords,
  ) {
    return allWords.where((w) {
      if (_tab == 'favorites' && !w.isFavorite) return false;
      if (_selectedCategory != null && w.category != _selectedCategory) {
        return false;
      }
      if (_search.isNotEmpty) {
        final s = _search.toLowerCase();
        if (!w.german.toLowerCase().contains(s) &&
            !w.english.toLowerCase().contains(s) &&
            !w.dari.toLowerCase().contains(s) &&
            !w.category.toLowerCase().contains(s) &&
            !w.tag.toLowerCase().contains(s)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<String> _queueForCurrentView(
      List<String> reviewQueueIds, List<VocabWord> filtered) {
    if (reviewQueueIds.isNotEmpty) {
      return reviewQueueIds;
    }
    return filtered.map((word) => word.id).toList(growable: false);
  }

  void _startFlashcards(
    List<VocabWord> filtered,
    List<String> reviewQueueIds,
  ) {
    setState(() {
      _flashcardMode = true;
      _flashcardsOpenedFromCategory = false;
      _selectedWord = null;
      _flashcardIndex = 0;
      _isFlipped = false;
      _flipController.value = 0;
      _flashcardQueueIds = _queueForCurrentView(reviewQueueIds, filtered);
    });
  }

  void _startCategoryFlashcards(String category) {
    setState(() {
      _tab = 'words';
      _selectedCategory = category;
      _flashcardMode = true;
      _flashcardsOpenedFromCategory = true;
      _selectedWord = null;
      _flashcardIndex = 0;
      _isFlipped = false;
      _flipController.value = 0;
      _flashcardQueueIds = const [];
    });
  }

  void _exitFlashcards() {
    setState(() {
      _flashcardMode = false;
      _flashcardIndex = 0;
      _isFlipped = false;
      _flipController.value = 0;
      _flashcardQueueIds = const [];
      if (_flashcardsOpenedFromCategory) {
        _selectedCategory = null;
        _tab = 'words';
      }
      _flashcardsOpenedFromCategory = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vocabAsync = ref.watch(vocabularyStreamProvider);
    final reviewStateAsync = ref.watch(vocabularyReviewStateProvider);
    final reviewById = reviewStateAsync.valueOrNull?.byWordId ??
        const <String, VocabularyReviewInfo>{};
    final reviewQueueIds = ref.watch(
      vocabularyReviewQueueProvider((
        search: _search,
        category: _tab == 'words' ? _selectedCategory : null,
        favoritesOnly: _tab == 'favorites',
      )),
    );

    return vocabAsync.when(
      data: (words) {
        final textPrimary = AppTokens.textPrimary(isDark);
        final textMuted = AppTokens.textMuted(isDark);
        final cardColor = AppTokens.surface(isDark);
        final filtered = _filter(words);

        if (!_didApplyInitialWordSelection && widget.initialWordId != null) {
          _didApplyInitialWordSelection = true;
          final initialWord = words.cast<VocabWord?>().firstWhere(
                (candidate) => candidate?.id == widget.initialWordId,
                orElse: () => null,
              );
          if (initialWord != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              setState(() {
                _selectedCategory = initialWord.category;
                _selectedWord = initialWord;
              });
            });
          }
        }

        if (_flashcardMode) {
          return _buildFlashcard(
            isDark,
            filtered,
            words,
            reviewById,
          );
        }
        if (_selectedWord != null) {
          // Sync selected word with current state from stream
          final currentWord = words.firstWhere((w) => w.id == _selectedWord!.id,
              orElse: () => _selectedWord!);
          return _buildWordDetail(
            isDark,
            currentWord,
            textMuted,
            cardColor,
            filtered,
            reviewQueueIds,
          );
        }
        return _buildMain(
          isDark,
          words,
          filtered,
          reviewById,
          textPrimary,
          textMuted,
          cardColor,
          reviewQueueIds,
        );
      },
      loading: () => const Scaffold(
          body: AppStateView.loading(
        title: 'Loading vocabulary',
        message: 'Vocabulary and phrases are being synchronized.',
      )),
      error: (e, s) => Scaffold(
          body: AppStateView.error(
        message: 'The vocabulary could not be loaded.\n$e',
        onAction: () => ref.invalidate(vocabularyStreamProvider),
      )),
    );
  }

  // ── MAIN VIEW ─────────────────────────────────────────────────────────────
  Widget _buildMain(
    bool isDark,
    List<VocabWord> allWords,
    List<VocabWord> filtered,
    Map<String, VocabularyReviewInfo> reviewById,
    Color textPrimary,
    Color textMuted,
    Color cardColor,
    List<String> reviewQueueIds,
  ) {
    final tabBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final showCategoryFlashcards =
        _tab == 'words' && _selectedCategory != null && filtered.isNotEmpty;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final contentBottomPadding =
        showCategoryFlashcards ? bottomInset + 40 : bottomInset + 24;

    return Stack(children: [
      SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          24,
          20,
          contentBottomPadding,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Row(children: [
            _BackButton(isDark: isDark, onTap: () => context.go('/')),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                      strings.either(
                          german: 'Wortschatz 📚', english: 'Vocabulary 📚'),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: textPrimary)),
                  Text(
                      strings.either(
                        german: 'Einfach suchen und direkt lernen',
                        english: 'Search simply and learn right away',
                      ),
                      style: TextStyle(fontSize: 12, color: textMuted)),
                ])),
            // Lang toggle
            GestureDetector(
              onTap: () => setState(() => _isDari = !_isDari),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Row(children: [
                  const Icon(Icons.translate_rounded,
                      size: 15, color: Color(0xFF3B82F6)),
                  const SizedBox(width: 5),
                  Text(_isDari ? 'دری' : 'EN',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textPrimary)),
                ]),
              ),
            ),
          ]),

          const SizedBox(height: 14),

          // Search bar
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3))
              ],
            ),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF111827)),
              decoration: InputDecoration(
                hintText: strings.either(
                    german: 'Wort suchen...', english: 'Search words...'),
                hintStyle: TextStyle(color: textMuted, fontSize: 14),
                prefixIcon:
                    Icon(Icons.search_rounded, color: textMuted, size: 20),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: tabBg, borderRadius: BorderRadius.circular(16)),
            child: Row(
                children: _tabs.map((t) {
              final active = _tab == t.$1;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _tab = t.$1;
                    _selectedCategory = null;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? cardColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2))
                            ]
                          : null,
                    ),
                    child: Center(
                        child: Text(
                            strings.either(
                              german: t.$2,
                              english: t.$1 == 'words'
                                  ? 'Words'
                                  : t.$1 == 'phrases'
                                      ? 'Phrases'
                                      : 'Favorites',
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color:
                                  active ? const Color(0xFF2563EB) : textMuted,
                            ))),
                  ),
                ),
              );
            }).toList()),
          ),
          const SizedBox(height: 16),

          if (_tab == 'words' &&
              _selectedCategory == null &&
              _search.trim().isEmpty) ...[
            _ListHeading(
              title:
                  strings.either(german: 'Kategorien', english: 'Categories'),
              subtitle: strings.either(
                  german: 'Direkt in einen Bereich springen',
                  english: 'Jump directly to a section'),
            ),
            const SizedBox(height: 12),
            ..._categories.map((category) {
              final categoryCount =
                  _categoryTotalCount(allWords, category.name);
              final learnedCount = _categoryLearnedCount(
                allWords,
                reviewById,
                category.name,
              );
              final progress =
                  categoryCount == 0 ? 0.0 : learnedCount / categoryCount;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _VocabularyCategoryCard(
                  category: category,
                  title: _categoryLabel(strings, category.name),
                  countLabel: strings.either(
                    german: '$learnedCount/$categoryCount gelernt',
                    english: '$learnedCount/$categoryCount learned',
                  ),
                  progress: progress,
                  onTap: () => _startCategoryFlashcards(category.name),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],

          if (_tab == 'favorites') ...[
            _ListHeading(
              title: strings.either(german: 'Favoriten', english: 'Favorites'),
              subtitle: strings.either(
                  german: '${filtered.length} gespeicherte Wörter',
                  english: '${filtered.length} saved words'),
            ),
          ] else if (_tab == 'phrases') ...[
            _ListHeading(
              title: strings.either(
                  german: 'Business-Phrasen', english: 'Business phrases'),
              subtitle: strings.either(
                  german: 'Praktische Ausdrücke für Beruf und Alltag',
                  english: 'Practical expressions for work and daily life'),
            ),
          ],
          const SizedBox(height: 12),
          if (_tab == 'phrases')
            ..._phrases.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                                child: Text(p.german,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textPrimary))),
                            _MetaPill(
                              label: p.tag,
                              dark: isDark,
                              icon: Icons.local_offer_outlined,
                            ),
                          ]),
                          const SizedBox(height: 4),
                          Text(_isDari ? p.dari : p.english,
                              style: TextStyle(fontSize: 12, color: textMuted)),
                        ]),
                  ),
                ))
          else if (_tab == 'words')
            const SizedBox.shrink()
          else if (filtered.isEmpty)
            AppStateView.empty(
              title: _tab == 'favorites'
                  ? strings.either(
                      german: 'Keine Favoriten gespeichert',
                      english: 'No favorites saved')
                  : _selectedCategory != null
                      ? strings.either(
                          german: 'Keine Wörter in dieser Kategorie',
                          english: 'No words in this category')
                      : strings.either(
                          german: 'Keine Wörter gefunden',
                          english: 'No words found'),
              message: _tab == 'favorites'
                  ? strings.either(
                      german:
                          'Markiere Wörter mit dem Herz, um sie hier zu sammeln.',
                      english:
                          'Mark words with the heart to collect them here.')
                  : _selectedCategory != null
                      ? strings.either(
                          german:
                              'Passe die Suche an oder gehe zurück zu allen Wörtern.',
                          english: 'Adjust the search or go back to all words.')
                      : strings.either(
                          german:
                              'Passe die Suche an, um passende Wörter zu sehen.',
                          english: 'Adjust the search to see matching words.'),
              icon: Icons.search_off_rounded,
            )
          else
            ...filtered.map((w) {
              final showCategoryPill =
                  _selectedCategory == null || _tab == 'favorites';
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedWord = w),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(w.german,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: textPrimary)),
                                  Icon(Icons.volume_up_rounded,
                                      size: 14,
                                      color: const Color(0xFF3B82F6)
                                          .withOpacity(0.5)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(_isDari ? w.dari : w.english,
                                  style: TextStyle(
                                      fontSize: 12, color: textMuted)),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (showCategoryPill)
                                    _MetaPill(
                                      label: w.category,
                                      dark: isDark,
                                      icon: Icons.folder_open_rounded,
                                      onTap: () => setState(() {
                                        _tab = 'words';
                                        _selectedCategory = w.category;
                                      }),
                                    ),
                                  _MetaPill(
                                    label: w.tag,
                                    dark: isDark,
                                    icon: Icons.local_offer_outlined,
                                  ),
                                ],
                              ),
                            ])),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            _DifficultyDot(w.difficulty),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => ref
                                  .read(appSettingsActionsProvider)
                                  .toggleFavorite(w.id),
                              child: Icon(
                                  w.isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_outline_rounded,
                                  size: 18,
                                  color: w.isFavorite
                                      ? const Color(0xFFEF4444)
                                      : textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 8),
        ]),
      ),
      if (showCategoryFlashcards)
        Positioned(
          right: 20,
          bottom: 20,
          child: SafeArea(
            top: false,
            child: _FloatingFlashcardsButton(
              onTap: () => _startFlashcards(filtered, reviewQueueIds),
            ),
          ),
        ),
    ]);
  }

  Widget _buildWordDetail(
    bool isDark,
    VocabWord w,
    Color textMuted,
    Color cardColor,
    List<VocabWord> filtered,
    List<String> reviewQueueIds,
  ) {
    final translation = _isDari ? w.dari : w.english;
    final businessContext = _isDari ? w.contextDari : w.context;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _BackButton(
              isDark: isDark,
              onTap: () => setState(() => _selectedWord = null)),
          const Spacer(),
          GestureDetector(
            onTap: () =>
                ref.read(appSettingsActionsProvider).toggleFavorite(w.id),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Icon(
                  w.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  size: 18,
                  color: w.isFavorite ? const Color(0xFFEF4444) : textMuted),
            ),
          ),
        ]),
        const SizedBox(height: 14),

        // Header card (blue→purple)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(children: [
            Text(w.german,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(strings.either(
                          german: 'Audio wird abgespielt: ${w.german}',
                          english: 'Playing audio for: ${w.german}'))),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100)),
                child: const Icon(Icons.volume_up_rounded,
                    size: 20, color: Colors.white),
              ),
            ),
          ]),
        ),

        const SizedBox(height: 14),

        _DetailCard(
            cardColor: cardColor,
            title: strings.either(german: 'Bedeutung', english: 'Meaning'),
            child: Text(translation,
                style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF374151)),
                textDirection:
                    _isDari ? TextDirection.rtl : TextDirection.ltr)),

        const SizedBox(height: 10),

        _DetailCard(
            cardColor: cardColor,
            title: strings.either(
                german: 'Beispielsatz', english: 'Example sentence'),
            child: Text('"${w.example}"',
                style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF374151)))),

        const SizedBox(height: 10),

        _DetailCard(
            cardColor: cardColor,
            title: strings.either(
                german: 'Business-Kontext', english: 'Business context'),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (businessContext.trim().isNotEmpty) ...[
                Text(businessContext,
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF374151)),
                    textDirection:
                        _isDari ? TextDirection.rtl : TextDirection.ltr),
                const SizedBox(height: 8),
              ],
              _MetaPill(
                label: w.tag,
                dark: isDark,
                icon: Icons.local_offer_outlined,
              ),
            ])),

        const SizedBox(height: 14),

        Row(children: [
          Expanded(
              child: GestureDetector(
            onTap: () => _startFlashcards(filtered, reviewQueueIds),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF9333EA)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                  child: Text(
                strings.either(
                    german: 'Flashcard starten', english: 'Start flashcards'),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )),
            ),
          )),
        ]),
      ]),
    );
  }

  Widget _buildFlashcard(
    bool isDark,
    List<VocabWord> filtered,
    List<VocabWord> allWords,
    Map<String, VocabularyReviewInfo> reviewById,
  ) {
    final words = _flashcardQueueIds.isNotEmpty
        ? _flashcardQueueIds
            .map((id) => allWords.firstWhere((word) => word.id == id))
            .toList(growable: false)
        : filtered.isNotEmpty
            ? filtered
            : allWords;
    if (words.isEmpty) {
      return AppStateView.empty(
        title: strings.either(
            german: 'Keine Wörter verfügbar', english: 'No words available'),
        message: strings.either(
          german: 'Passe Filter oder Kategorie an, um Karten zu sehen.',
          english: 'Adjust the filters or category to see cards.',
        ),
        icon: Icons.inbox_rounded,
      );
    }
    final w = words[_flashcardIndex % words.length];
    final progress = (_flashcardIndex + 1) / words.length;
    final textMuted =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(children: [
          // Top bar
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _BackButton(isDark: isDark, onTap: _exitFlashcards),
            Expanded(
              child: Text(
                _selectedCategory ??
                    strings.either(
                        german: 'Wortschatz Review', english: 'Vocab Review'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTokens.textPrimary(isDark),
                ),
              ),
            ),
            Text('${_flashcardIndex + 1} / ${words.length}',
                style: TextStyle(fontSize: 13, color: textMuted)),
          ]),
          const SizedBox(height: 14),

          // Progress
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor:
                  isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF3B82F6)),
            ),
          ),
          const SizedBox(height: 24),

          // Flashcard
          Expanded(
            child: GestureDetector(
              onTap: _toggleFlip,
              onHorizontalDragEnd: (details) {
                final velocity = details.primaryVelocity ?? 0;
                if (velocity < -180) {
                  _nextFlashcard(ReviewResult.hard, words);
                } else if (velocity > 180) {
                  _nextFlashcard(ReviewResult.easy, words);
                }
              },
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, _) {
                  final angle = _flipAnimation.value * 3.141592653589793;
                  final showBack = angle > 1.5707963267948966;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: showBack
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(3.141592653589793),
                            child: _FlashcardBack(
                              key: const ValueKey('back'),
                              word: w,
                              isDari: _isDari,
                            ),
                          )
                        : _FlashcardFront(
                            key: const ValueKey('front'),
                            word: w,
                            strings: strings,
                          ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Difficulty buttons
          Row(children: [
            Expanded(
                child: _DiffBtn(
                    label: '',
                    emoji: '😞',
                    bg: isDark
                        ? const Color(0xFF450A0A)
                        : const Color(0xFFFEF2F2),
                    fg: const Color(0xFFEF4444),
                    border: isDark
                        ? null
                        : Border.all(color: const Color(0xFFFEE2E2)),
                    onTap: () => _nextFlashcard(ReviewResult.hard, words))),
            const SizedBox(width: 10),
            Expanded(
                child: _DiffBtn(
                    label: '',
                    emoji: '😐',
                    bg: isDark
                        ? const Color(0xFF1C1A09)
                        : const Color(0xFFFFFBEB),
                    fg: const Color(0xFFF59E0B),
                    border: isDark
                        ? null
                        : Border.all(color: const Color(0xFFFEF3C7)),
                    onTap: () => _nextFlashcard(ReviewResult.medium, words))),
            const SizedBox(width: 10),
            Expanded(
                child: _DiffBtn(
                    label: '',
                    emoji: '😊',
                    bg: isDark
                        ? const Color(0xFF052E16)
                        : const Color(0xFFF0FDF4),
                    fg: const Color(0xFF22C55E),
                    border: isDark
                        ? null
                        : Border.all(color: const Color(0xFFDCFCE7)),
                    onTap: () => _nextFlashcard(ReviewResult.easy, words))),
          ]),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  void _nextFlashcard(ReviewResult result, List<VocabWord> words) {
    if (words.isEmpty) {
      return;
    }

    final currentWord = words[_flashcardIndex % words.length];
    ref.read(appSettingsActionsProvider).recordVocabularyReview(
          wordId: currentWord.id,
          result: result,
        );

    if (_flashcardIndex >= words.length - 1) {
      _exitFlashcards();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Congratulations! All cards learned.')),
      );
    } else {
      setState(() {
        _isFlipped = false;
        _flipController.value = 0;
        _flashcardIndex++;
      });
    }
  }
}

/// This card shows a vocabulary category with an icon and progress bar.
class _VocabularyCategoryCard extends StatelessWidget {
  const _VocabularyCategoryCard({
    required this.category,
    required this.title,
    required this.countLabel,
    required this.progress,
    required this.onTap,
  });

  final BizCategory category;
  final String title;
  final String countLabel;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = category.gradient;

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
          child: Row(
            children: [
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
                child:
                    Text(category.icon, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTokens.textPrimary(isDark),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: isDark
                              ? const Color(0xFF475569)
                              : const Color(0xFFCBD5E1),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      countLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTokens.textMuted(isDark),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 5,
                        backgroundColor: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE5E7EB),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(gradient.last),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.isDark, required this.onTap});
  final bool isDark;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              size: 16,
              color:
                  isDark ? const Color(0xFF94A3B8) : const Color(0xFF374151)),
        ),
      );
}

/// This widget shows a small dot indicating word difficulty.
class _DifficultyDot extends StatelessWidget {
  const _DifficultyDot(this.difficulty);
  final String difficulty;
  @override
  Widget build(BuildContext context) {
    final color = difficulty == 'easy'
        ? const Color(0xFF22C55E)
        : difficulty == 'hard'
            ? const Color(0xFFEF4444)
            : const Color(0xFFF59E0B);
    return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

/// This card shows details for a specific vocabulary word.
class _DetailCard extends StatelessWidget {
  const _DetailCard(
      {required this.cardColor, required this.title, required this.child});
  final Color cardColor;
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF6B7280))),
        const SizedBox(height: 6),
        child,
      ]),
    );
  }
}

/// This is the front side of a flashcard showing the German word.
class _FlashcardFront extends StatelessWidget {
  const _FlashcardFront({super.key, required this.word, required this.strings});
  final VocabWord word;
  final AppUiText strings;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 10))
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(strings.either(german: 'Deutsch', english: 'German'),
              style: TextStyle(
                  fontSize: 12, color: Colors.white.withOpacity(0.6))),
          const SizedBox(height: 12),
          Text(word.german,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const SizedBox(height: 24),
          Text(
              strings.either(
                  german: 'Tippen zum Umdrehen', english: 'Tap to flip'),
              style: TextStyle(
                  fontSize: 12, color: Colors.white.withOpacity(0.4))),
        ]),
      );
}

/// This is the back side of a flashcard showing the translation and examples.
class _FlashcardBack extends StatelessWidget {
  const _FlashcardBack({super.key, required this.word, required this.isDari});
  final VocabWord word;
  final bool isDari;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF22C55E), Color(0xFF0D9488)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF22C55E).withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 10))
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(isDari ? 'دری' : 'English',
              style: TextStyle(
                  fontSize: 12, color: Colors.white.withOpacity(0.6))),
          const SizedBox(height: 12),
          Text(isDari ? word.dari : word.english,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              textAlign: TextAlign.center,
              textDirection: isDari ? TextDirection.rtl : TextDirection.ltr),
          const SizedBox(height: 14),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16)),
            child: Text(word.example,
                style: TextStyle(
                    fontSize: 13, color: Colors.white.withOpacity(0.9)),
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100)),
            child: Text(word.tag,
                style: const TextStyle(fontSize: 11, color: Colors.white)),
          ),
        ]),
      );
}

/// This button allows users to rate the difficulty of a flashcard.
class _DiffBtn extends StatelessWidget {
  const _DiffBtn({
    required this.label,
    required this.emoji,
    required this.bg,
    required this.fg,
    required this.onTap,
    this.border,
  });
  final String label, emoji;
  final Color bg, fg;
  final VoidCallback onTap;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: border,
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
        ),
      );
}

/// This widget shows a heading for a list of words or categories.
class _ListHeading extends StatelessWidget {
  const _ListHeading({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
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
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: AppTokens.textMuted(isDark),
          ),
        ),
      ],
    );
  }
}

/// This small pill shows metadata like categories or tags.
class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.label,
    required this.dark,
    required this.icon,
    this.onTap,
  });

  final String label;
  final bool dark;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF2563EB)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB)),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return chip;
    }

    return GestureDetector(onTap: onTap, child: chip);
  }
}

/// This button starts a flashcard session for a category.
class _FloatingFlashcardsButton extends StatelessWidget {
  const _FloatingFlashcardsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.style_rounded, size: 16, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Flashcards',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Removed custom transition in favor of inline transitionBuilder for better state management
