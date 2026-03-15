import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/database/seed_data.dart';
import '../../../core/theme/app_tokens.dart';

enum _VocabTab { words, phrases, favorites, difficult }

class VocabularyPage extends ConsumerStatefulWidget {
  const VocabularyPage({super.key});

  @override
  ConsumerState<VocabularyPage> createState() => _VocabularyPageState();
}

class _Header extends StatelessWidget {
  const _Header({
    required this.isDari,
    required this.onBack,
    required this.onToggleLanguage,
  });

  final bool isDari;
  final VoidCallback onBack;
  final VoidCallback onToggleLanguage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        _IconButton(
          icon: Icons.arrow_back_rounded,
          onPressed: onBack,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wortschatz 📚',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color:
                          isDark ? AppTokens.darkText : AppTokens.lightText,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                'Wörter & Business',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppTokens.darkTextMuted
                          : AppTokens.lightTextMuted,
                    ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onToggleLanguage,
          borderRadius: AppTokens.radius16,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: AppTokens.radius16,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.translate_rounded,
                    size: 16, color: Color(0xFF3B82F6)),
                const SizedBox(width: 6),
                Text(
                  isDari ? 'دری' : 'EN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppTokens.darkText
                        : const Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: 'Wort suchen...',
        prefixIcon: Icon(Icons.search_rounded),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.tab, required this.onChanged});

  final _VocabTab tab;
  final ValueChanged<_VocabTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: AppTokens.radius20,
      ),
      child: Row(
        children: [
          _TabButton(
            label: 'Wörter',
            selected: tab == _VocabTab.words,
            onTap: () => onChanged(_VocabTab.words),
          ),
          _TabButton(
            label: 'Phrasen',
            selected: tab == _VocabTab.phrases,
            onTap: () => onChanged(_VocabTab.phrases),
          ),
          _TabButton(
            label: 'Favoriten',
            selected: tab == _VocabTab.favorites,
            onTap: () => onChanged(_VocabTab.favorites),
          ),
          _TabButton(
            label: 'Schwierig',
            selected: tab == _VocabTab.difficult,
            onTap: () => onChanged(_VocabTab.difficult),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
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
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTokens.radius16,
        child: Ink(
          height: 38,
          decoration: BoxDecoration(
            color: selected
                ? (isDark ? const Color(0xFF334155) : Colors.white)
                : Colors.transparent,
            borderRadius: AppTokens.radius16,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
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
                fontWeight: FontWeight.w600,
                color: selected
                    ? (isDark
                        ? const Color(0xFF60A5FA)
                        : const Color(0xFF3B82F6))
                    : (isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B)),
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
      borderRadius: AppTokens.radius20,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTokens.radius20,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppTokens.radius20,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: style.colors,
            ),
            boxShadow: [
              BoxShadow(
                color: style.colors.last.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count Wörter',
                style: const TextStyle(
                  color: Color(0xFFBFDBFE),
                  fontSize: 12,
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

class _PhraseCard extends StatelessWidget {
  const _PhraseCard({
    required this.phrase,
    required this.isDari,
  });

  final Map<String, String> phrase;
  final bool isDari;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final translation = isDari ? phrase['dari']! : phrase['english']!;
    final translationStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted,
          fontFamily: isDari ? 'Vazirmatn' : null,
        );

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTokens.darkCard : AppTokens.lightCard,
        borderRadius: AppTokens.radius24,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.18)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phrase['german']!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            isDark ? AppTokens.darkText : AppTokens.lightText,
                      ),
                ),
                const SizedBox(height: 4),
                Directionality(
                  textDirection:
                      isDari ? TextDirection.rtl : TextDirection.ltr,
                  child: Text(
                    translation,
                    textAlign: isDari ? TextAlign.right : TextAlign.left,
                    style: translationStyle,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF312E81)
                  : const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              phrase['tag']!,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.white : const Color(0xFF6D28D9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  const _WordCard({
    required this.word,
    required this.isDari,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final VocabularyWord word;
  final bool isDari;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: AppTokens.radius24,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTokens.darkCard : AppTokens.lightCard,
          borderRadius: AppTokens.radius24,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.18)
                  : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.german,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color:
                              isDark ? AppTokens.darkText : AppTokens.lightText,
                        ),
                  ),
                  Text(
                    word.phonetic,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppTokens.darkTextMuted
                              : AppTokens.lightTextMuted,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Directionality(
                    textDirection:
                        isDari ? TextDirection.rtl : TextDirection.ltr,
                    child: Text(
                      isDari ? word.dari : word.english,
                      textAlign: isDari ? TextAlign.right : TextAlign.left,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppTokens.darkTextMuted
                                : AppTokens.lightTextMuted,
                            fontFamily: isDari ? 'Vazirmatn' : null,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            _TagChip(tag: word.tag),
            IconButton(
              onPressed: onToggleFavorite,
              icon: Icon(
                word.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: word.isFavorite
                    ? const Color(0xFFEF4444)
                    : (isDark
                        ? const Color(0xFF475569)
                        : const Color(0xFFCBD5F5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color fg;

    switch (tag) {
      case 'HR':
        bg = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE);
        fg = isDark ? const Color(0xFFBFDBFE) : const Color(0xFF1D4ED8);
        break;
      case 'Finance':
        bg = isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7);
        fg = isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D);
        break;
      case 'IT':
        bg = isDark ? const Color(0xFF155E75) : const Color(0xFFECFEFF);
        fg = isDark ? const Color(0xFF67E8F9) : const Color(0xFF0E7490);
        break;
      case 'Legal':
        bg = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
        fg = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C);
        break;
      case 'Marketing':
        bg = isDark ? const Color(0xFF9A3412) : const Color(0xFFFFEDD5);
        fg = isDark ? const Color(0xFFFED7AA) : const Color(0xFFC2410C);
        break;
      case 'Sales':
        bg = isDark ? const Color(0xFF92400E) : const Color(0xFFFEF3C7);
        fg = isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);
        break;
      case 'Learning':
        bg = isDark ? const Color(0xFF312E81) : const Color(0xFFEDE9FE);
        fg = isDark ? const Color(0xFFC4B5FD) : const Color(0xFF6D28D9);
        break;
      default:
        bg = isDark ? const Color(0xFF312E81) : const Color(0xFFEDE9FE);
        fg = isDark ? const Color(0xFFC4B5FD) : const Color(0xFF6D28D9);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        tag,
        style: TextStyle(fontSize: 10, color: fg),
      ),
    );
  }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final translation = isDari ? word.dari : word.english;
    final contextText = isDari ? word.contextDari : word.context;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: onBack,
                ),
                const Spacer(),
                _IconButton(
                  icon: word.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  iconColor: word.isFavorite
                      ? const Color(0xFFEF4444)
                      : null,
                  onPressed: onFavorite,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: AppTokens.radius30,
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFFA855F7)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    word.german,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word.phonetic,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.volume_up_rounded,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _InfoCard(
              title: 'Bedeutung',
              content: translation,
              isDari: isDari,
            ),
            const SizedBox(height: 10),
            _InfoCard(
              title: 'Beispielsatz',
              content: word.example,
            ),
            const SizedBox(height: 10),
            _InfoCard(
              title: 'Business-Kontext',
              content: contextText,
              isDari: isDari,
              chip: word.tag,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: word.difficulty,
                    items: const [
                      DropdownMenuItem(value: 'easy', child: Text('Leicht')),
                      DropdownMenuItem(value: 'medium', child: Text('Mittel')),
                      DropdownMenuItem(value: 'hard', child: Text('Schwer')),
                    ],
                    onChanged: (value) {
                      if (value != null) onDifficulty(value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: onFlashcard,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Flashcard starten'),
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
  const _InfoCard({
    required this.title,
    required this.content,
    this.isDari = false,
    this.chip,
  });

  final String title;
  final String content;
  final bool isDari;
  final String? chip;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTokens.darkCard : AppTokens.lightCard,
        borderRadius: AppTokens.radius30,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.16)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppTokens.darkText : AppTokens.lightText,
                ),
          ),
          const SizedBox(height: 6),
          Directionality(
            textDirection: isDari ? TextDirection.rtl : TextDirection.ltr,
            child: Text(
              content,
              textAlign: isDari ? TextAlign.right : TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppTokens.darkTextMuted
                        : AppTokens.lightTextMuted,
                    fontFamily: isDari ? 'Vazirmatn' : null,
                  ),
            ),
          ),
          if (chip != null) ...[
            const SizedBox(height: 10),
            _TagChip(tag: chip!),
          ],
        ],
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
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          children: [
            Row(
              children: [
                _IconButton(
                  icon: Icons.close_rounded,
                  onPressed: onClose,
                ),
                const Spacer(),
                Text(
                  '$index / $total',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
              ),
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
                      final angle = value * math.pi;
                      final isBack = angle > math.pi / 2;

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        alignment: Alignment.center,
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 360),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: AppTokens.radius30,
                            gradient: LinearGradient(
                              colors: isBack
                                  ? const [Color(0xFF22C55E), Color(0xFF0D9488)]
                                  : const [Color(0xFF3B82F6), Color(0xFFA855F7)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..rotateY(isBack ? math.pi : 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isBack
                                      ? (isDari ? 'دری' : 'English')
                                      : 'Deutsch',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 10),
                                Directionality(
                                  textDirection: isBack && isDari
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  child: Text(
                                    isBack
                                        ? (isDari ? word.dari : word.english)
                                        : word.german,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: isBack && isDari
                                          ? 'Vazirmatn'
                                          : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (!isBack)
                                  Text(
                                    word.phonetic,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                if (isBack) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      word.example,
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      word.tag,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onDifficulty('hard'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                    ),
                    child: const Text('❌ Schwer'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onDifficulty('medium'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB45309),
                    ),
                    child: const Text('🤔 Mittel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => onDifficulty('easy'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                    ),
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

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onPressed,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      borderRadius: AppTokens.radius16,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppTokens.radius16,
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: AppTokens.radius16,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor ??
                (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }
}

class _FlashcardFab extends StatelessWidget {
  const _FlashcardFab({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedOpacity(
        opacity: onPressed == null ? 0.4 : 1,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFFA855F7)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.style_rounded, color: Colors.white),
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

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
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

    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(
                  isDari: isDari,
                  onBack: () => context.go('/'),
                  onToggleLanguage: () {
                    final next = isDari ? 'en' : 'dari';
                    ref.read(appSettingsActionsProvider).setNativeLanguage(next);
                  },
                ),
                const SizedBox(height: 14),
                _SearchField(
                  onChanged: (value) => setState(() => _search = value),
                ),
                const SizedBox(height: 14),
                _TabBar(
                  tab: _tab,
                  onChanged: (next) => setState(() {
                    _tab = next;
                    _selectedCategory = null;
                  }),
                ),
                const SizedBox(height: 16),
                if (_tab == _VocabTab.words && _selectedCategory == null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business-Kategorien',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: isDark
                                  ? AppTokens.darkText
                                  : AppTokens.lightText,
                            ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoryEntries.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.25,
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
                    ],
                  ),
                if (_selectedCategory != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () =>
                              setState(() => _selectedCategory = null),
                          child: const Text('Alle Kategorien'),
                        ),
                        const Icon(Icons.chevron_right_rounded, size: 16),
                        Flexible(
                          child: Text(
                            _selectedCategory!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_tab == _VocabTab.phrases)
                  Column(
                    children: [
                      for (final phrase in phraseSeed)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _PhraseCard(
                            phrase: phrase,
                            isDari: isDari,
                          ),
                        ),
                    ],
                  )
                else if (_selectedCategory != null || _tab != _VocabTab.words)
                  Column(
                    children: [
                      for (final word in filtered)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _WordCard(
                            word: word,
                            isDari: isDari,
                            onTap: () =>
                                setState(() => _selectedWordId = word.id),
                            onToggleFavorite: () => ref
                                .read(appSettingsActionsProvider)
                                .toggleFavorite(word.id),
                          ),
                        ),
                      if (filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            children: [
                              Text(
                                _tab == _VocabTab.favorites
                                    ? '💝'
                                    : _tab == _VocabTab.difficult
                                        ? '💪'
                                        : '🔍',
                                style: const TextStyle(fontSize: 36),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _tab == _VocabTab.favorites
                                    ? 'Keine Favoriten'
                                    : _tab == _VocabTab.difficult
                                        ? 'Keine schwierigen Wörter'
                                        : 'Keine Ergebnisse',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 90,
            child: _FlashcardFab(
              onPressed: words.isEmpty
                  ? null
                  : () => setState(() {
                        _flashcardMode = true;
                        _flashcardIndex = 0;
                        _isFlipped = false;
                      }),
            ),
          ),
        ],
      ),
    );
  }
}
