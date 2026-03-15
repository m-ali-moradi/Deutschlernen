import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/database/seed_data.dart';

enum _VocabTab { words, phrases, favorites, difficult }

class VocabularyPage extends ConsumerStatefulWidget {
  const VocabularyPage({super.key});

  @override
  ConsumerState<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends ConsumerState<VocabularyPage> {
  _VocabTab _tab = _VocabTab.words;
  String _search = '';
  String? _selectedCategory;
  String? _selectedWordId;

  bool _flashcardMode = false;
  int _flashcardIndex = 0;
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(vocabularyStreamProvider);
    final prefsAsync = ref.watch(userPreferencesStreamProvider);

    if (wordsAsync.isLoading || prefsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (wordsAsync.hasError || prefsAsync.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 44),
              const SizedBox(height: 10),
              const Text('Failed to load vocabulary data'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  ref.invalidate(vocabularyStreamProvider);
                  ref.invalidate(userPreferencesStreamProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final words = wordsAsync.value!;
    final prefs = prefsAsync.value!;
    final isDari = prefs.nativeLanguage == 'dari';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    var filtered = words.where((w) {
      if (_tab == _VocabTab.favorites && !w.isFavorite) return false;
      if (_tab == _VocabTab.difficult && !w.isDifficult) return false;
      if (_selectedCategory != null && w.category != _selectedCategory) {
        return false;
      }
      if (_search.isNotEmpty) {
        final needle = _search.toLowerCase();
        final inGerman = w.german.toLowerCase().contains(needle);
        final inEnglish = w.english.toLowerCase().contains(needle);
        final inDari = w.dari.contains(needle);
        if (!(inGerman || inEnglish || inDari)) return false;
      }
      return true;
    }).toList();

    if (_selectedWordId != null) {
      final selected = words.where((w) => w.id == _selectedWordId).firstOrNull;
      if (selected == null) {
        _selectedWordId = null;
      } else {
        return _WordDetailView(
          word: selected,
          isDari: isDari,
          onBack: () => setState(() => _selectedWordId = null),
          onFavorite: () =>
              ref.read(appSettingsActionsProvider).toggleFavorite(selected.id),
          onDifficulty: (difficulty) => ref
              .read(appSettingsActionsProvider)
              .setWordDifficulty(selected.id, difficulty),
          onFlashcard: () {
            setState(() {
              _flashcardMode = true;
              _flashcardIndex = 0;
              _isFlipped = false;
              _selectedWordId = null;
            });
          },
        );
      }
    }

    final flashcardWords = filtered.isNotEmpty ? filtered : words;
    if (_flashcardMode && flashcardWords.isNotEmpty) {
      final currentWord =
          flashcardWords[_flashcardIndex % flashcardWords.length];
      return _FlashcardView(
        word: currentWord,
        isDari: isDari,
        index: (_flashcardIndex % flashcardWords.length) + 1,
        total: flashcardWords.length,
        isFlipped: _isFlipped,
        onToggleFlip: () => setState(() => _isFlipped = !_isFlipped),
        onClose: () => setState(() {
          _flashcardMode = false;
          _isFlipped = false;
          _flashcardIndex = 0;
        }),
        onDifficulty: (difficulty) async {
          await ref
              .read(appSettingsActionsProvider)
              .setWordDifficulty(currentWord.id, difficulty);
          if (!mounted) return;
          setState(() {
            _isFlipped = false;
            _flashcardIndex = (_flashcardIndex + 1) % flashcardWords.length;
          });
        },
      );
    }

    final categoryCounts = <String, int>{};
    for (final w in words) {
      categoryCounts[w.category] = (categoryCounts[w.category] ?? 0) + 1;
    }
    final categoryEntries =
        _sortCategoryEntries(categoryCounts.entries.toList());
    final showWordsOverview =
        _tab == _VocabTab.words && _selectedCategory == null && _search.isEmpty;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!showWordsOverview) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0EA5E9),
                      Color(0xFF4F46E5),
                      Color(0xFF9333EA)
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.28),
                      blurRadius: 26,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Wortschatz 📚',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(color: Colors.white)),
                          Text('Worter & Business',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white70)),
                        ],
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        final next = isDari ? 'en' : 'dari';
                        ref
                            .read(appSettingsActionsProvider)
                            .setNativeLanguage(next);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.22),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.translate_rounded, size: 16),
                      label: Text(isDari ? 'دری' : 'EN'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (value) => setState(() => _search = value),
                decoration: InputDecoration(
                  hintText: 'Wort suchen...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _TabChip(
                    label: 'Worter',
                    selected: _tab == _VocabTab.words,
                    onTap: () => setState(() {
                      _tab = _VocabTab.words;
                      _selectedCategory = null;
                    }),
                  ),
                  _TabChip(
                    label: 'Phrasen',
                    selected: _tab == _VocabTab.phrases,
                    onTap: () => setState(() {
                      _tab = _VocabTab.phrases;
                      _selectedCategory = null;
                    }),
                  ),
                  _TabChip(
                    label: 'Favoriten',
                    selected: _tab == _VocabTab.favorites,
                    onTap: () => setState(() {
                      _tab = _VocabTab.favorites;
                      _selectedCategory = null;
                    }),
                  ),
                  _TabChip(
                    label: 'Schwierig',
                    selected: _tab == _VocabTab.difficult,
                    onTap: () => setState(() {
                      _tab = _VocabTab.difficult;
                      _selectedCategory = null;
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_tab == _VocabTab.words && _selectedCategory == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Business-Kategorien',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 40 / 2,
                            color: const Color(0xFFF8FAFC),
                          )),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categoryEntries.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final entry = categoryEntries[index];
                      final style = _categoryStyleFor(entry.key, index);

                      return _CategoryTile(
                        title: entry.key,
                        count: entry.value,
                        style: style,
                        onTap: () =>
                            setState(() => _selectedCategory = entry.key),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            if (_selectedCategory != null)
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => _selectedCategory = null),
                    child: const Text('Alle Kategorien'),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 16),
                  Flexible(child: Text(_selectedCategory!)),
                ],
              ),
            if (_tab == _VocabTab.phrases)
              Column(
                children: [
                  for (final phrase in phraseSeed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(phrase['german']!),
                                  const SizedBox(height: 2),
                                  Text(
                                    isDari
                                        ? phrase['dari']!
                                        : phrase['english']!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF312E81)
                                    : const Color(0xFFEDE9FE),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                phrase['tag']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              )
            else if (_selectedCategory != null || _tab != _VocabTab.words)
              Column(
                children: [
                  for (final word in filtered)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => setState(() => _selectedWordId = word.id),
                        borderRadius: BorderRadius.circular(14),
                        child: Ink(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(word.german),
                                    Text(word.phonetic,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant)),
                                    const SizedBox(height: 2),
                                    Text(
                                      isDari ? word.dari : word.english,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: isDark
                                      ? const Color(0xFF1E3A5F)
                                      : const Color(0xFFEFF6FF),
                                ),
                                child: Text(
                                  word.tag,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? Colors.white : null),
                                ),
                              ),
                              IconButton(
                                onPressed: () => ref
                                    .read(appSettingsActionsProvider)
                                    .toggleFavorite(word.id),
                                icon: Icon(
                                  word.isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: word.isFavorite
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 10),
            if (!_flashcardMode && !showWordsOverview)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF4F46E5),
                  ),
                  onPressed: words.isEmpty
                      ? null
                      : () => setState(() {
                            _flashcardMode = true;
                            _flashcardIndex = 0;
                            _isFlipped = false;
                          }),
                  icon: const Icon(Icons.style_rounded),
                  label: const Text('Flashcard starten'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: selected
                  ? Theme.of(context).colorScheme.surface
                  : Colors.transparent,
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: isDark ? 0.24 : 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : (isDark
                          ? const Color(0xFFAFB8CC)
                          : const Color(0xFFD0DBED)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.title,
    required this.count,
    required this.style,
    required this.onTap,
  });

  final String title;
  final int count;
  final _CategoryStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: style.colors,
            ),
            boxShadow: [
              BoxShadow(
                color: style.colors.last.withValues(alpha: 0.30),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(style.emoji, style: const TextStyle(fontSize: 22)),
              const Spacer(),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count Worter',
                style: const TextStyle(
                  color: Color(0xFFBFDBFE),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryStyle {
  const _CategoryStyle({required this.emoji, required this.colors});

  final String emoji;
  final List<Color> colors;
}

const _categoryFallbackStyles = <_CategoryStyle>[
  _CategoryStyle(emoji: '💼', colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
  _CategoryStyle(emoji: '💬', colors: [Color(0xFF14B8A6), Color(0xFF0D9488)]),
  _CategoryStyle(emoji: '🤝', colors: [Color(0xFFA855F7), Color(0xFF7E22CE)]),
  _CategoryStyle(emoji: '💻', colors: [Color(0xFF06B6D4), Color(0xFF0E7490)]),
  _CategoryStyle(emoji: '💰', colors: [Color(0xFF22C55E), Color(0xFF16A34A)]),
  _CategoryStyle(emoji: '📄', colors: [Color(0xFFFF5A6E), Color(0xFFFF2D45)]),
  _CategoryStyle(emoji: '📢', colors: [Color(0xFFFF8A00), Color(0xFFFB5607)]),
  _CategoryStyle(emoji: '🎓', colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]),
];

const _categoryDesignStyles = <String, _CategoryStyle>{
  'Bewerbung & Karriere': _CategoryStyle(
      emoji: '💼', colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
  'Buro Kommunikation': _CategoryStyle(
      emoji: '💬', colors: [Color(0xFF14B8A6), Color(0xFF0D9488)]),
  'Meetings': _CategoryStyle(
      emoji: '🤝', colors: [Color(0xFFA855F7), Color(0xFF7E22CE)]),
  'IT & Technik': _CategoryStyle(
      emoji: '💻', colors: [Color(0xFF06B6D4), Color(0xFF0E7490)]),
  'Finanzen': _CategoryStyle(
      emoji: '💰', colors: [Color(0xFF22C55E), Color(0xFF16A34A)]),
  'Vertrage': _CategoryStyle(
      emoji: '📄', colors: [Color(0xFFFF5A6E), Color(0xFFFF2D45)]),
  'Marketing': _CategoryStyle(
      emoji: '📢', colors: [Color(0xFFFF8A00), Color(0xFFFB5607)]),
  'Bildung': _CategoryStyle(
      emoji: '🎓', colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]),
};

_CategoryStyle _categoryStyleFor(String category, int index) {
  return _categoryDesignStyles[category] ??
      _categoryFallbackStyles[index % _categoryFallbackStyles.length];
}

List<MapEntry<String, int>> _sortCategoryEntries(
    List<MapEntry<String, int>> entries) {
  const categoryOrder = <String>[
    'Bewerbung & Karriere',
    'Buro Kommunikation',
    'Meetings',
    'IT & Technik',
    'Finanzen',
    'Vertrage',
    'Marketing',
    'Bildung',
  ];

  final orderLookup = <String, int>{
    for (var i = 0; i < categoryOrder.length; i++) categoryOrder[i]: i,
  };

  entries.sort((a, b) {
    final ai = orderLookup[a.key] ?? 999;
    final bi = orderLookup[b.key] ?? 999;
    if (ai != bi) return ai.compareTo(bi);
    return a.key.compareTo(b.key);
  });
  return entries;
}

class _WordDetailView extends StatelessWidget {
  const _WordDetailView({
    required this.word,
    required this.isDari,
    required this.onBack,
    required this.onFavorite,
    required this.onDifficulty,
    required this.onFlashcard,
  });

  final VocabularyWord word;
  final bool isDari;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final ValueChanged<String> onDifficulty;
  final VoidCallback onFlashcard;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded)),
                const Spacer(),
                IconButton(
                  onPressed: onFavorite,
                  icon: Icon(
                    word.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: word.isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFFA855F7)]),
              ),
              child: Column(
                children: [
                  Text(word.german,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 30)),
                  const SizedBox(height: 4),
                  Text(word.phonetic,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _InfoCard(
                title: 'Bedeutung', content: isDari ? word.dari : word.english),
            const SizedBox(height: 8),
            _InfoCard(title: 'Beispielsatz', content: word.example),
            const SizedBox(height: 8),
            _InfoCard(
                title: 'Business-Kontext',
                content: isDari ? word.contextDari : word.context),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: word.difficulty,
                    items: const [
                      DropdownMenuItem(value: 'easy', child: Text('Leicht')),
                      DropdownMenuItem(value: 'medium', child: Text('Mittel')),
                      DropdownMenuItem(value: 'hard', child: Text('Schwer')),
                    ],
                    onChanged: (value) {
                      if (value != null) onDifficulty(value);
                    },
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: onFlashcard,
                    child: const Text('Flashcard'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(content),
          ],
        ),
      ),
    );
  }
}

class _FlashcardView extends StatelessWidget {
  const _FlashcardView({
    required this.word,
    required this.isDari,
    required this.index,
    required this.total,
    required this.isFlipped,
    required this.onToggleFlip,
    required this.onClose,
    required this.onDifficulty,
  });

  final VocabularyWord word;
  final bool isDari;
  final int index;
  final int total;
  final bool isFlipped;
  final VoidCallback onToggleFlip;
  final VoidCallback onClose;
  final ValueChanged<String> onDifficulty;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : index / total;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: onClose, icon: const Icon(Icons.close_rounded)),
                const Spacer(),
                Text('$index / $total'),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(value: progress, minHeight: 8),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: onToggleFlip,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: isFlipped ? 1 : 0),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      final angle = value * 3.1415926535897932;
                      final isBack = angle > 1.5707963267948966;

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        alignment: Alignment.center,
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 360),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: isBack
                                  ? const [Color(0xFF22C55E), Color(0xFF0D9488)]
                                  : const [
                                      Color(0xFF3B82F6),
                                      Color(0xFFA855F7)
                                    ],
                            ),
                          ),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..rotateY(isBack ? 3.1415926535897932 : 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    isBack
                                        ? (isDari ? 'دری' : 'English')
                                        : 'Deutsch',
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 10),
                                Text(
                                  isBack
                                      ? (isDari ? word.dari : word.english)
                                      : word.german,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 28),
                                ),
                                const SizedBox(height: 8),
                                if (!isBack)
                                  Text(word.phonetic,
                                      style: const TextStyle(
                                          color: Colors.white70)),
                                if (isBack) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(word.example,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onDifficulty('hard'),
                    child: const Text('❌ Schwer'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onDifficulty('medium'),
                    child: const Text('🤔 Mittel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => onDifficulty('easy'),
                    child: const Text('✅ Leicht'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
