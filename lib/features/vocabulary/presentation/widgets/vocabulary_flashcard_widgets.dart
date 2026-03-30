import 'package:flutter/material.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/learning/review_logic.dart'; // provides ReviewResult
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';

/// Alias for `VocabularyWord` to make the code cleaner.
typedef VocabWord = VocabularyWord;

/// Widget representing the front side of a vocabulary flashcard.
///
/// This widget displays the primary language word (e.g., German) on a gradient background.
/// It acts as the initial state before the user taps to flip the card and reveal
/// the translation and context on the back.

class FlashcardFront extends StatelessWidget {
  const FlashcardFront({
    super.key,
    required this.word,
    required this.strings,
    this.lastResult,
  });

  final VocabWord word;
  final AppUiText strings;
  final ReviewResult? lastResult;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                blurRadius: 30,
                offset: const Offset(0, 12))
          ],
        ),
        child: Stack(
          children: [
            // Inner Highlight
            Positioned(
              top: 1,
              left: 1,
              right: 1,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Difficulty Badge
            Positioned(
              top: 20,
              left: 20,
              child: _DifficultyBadge(result: lastResult),
            ),

            Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    strings
                        .either(german: 'Deutsch', english: 'German')
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    word.german,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      strings.either(
                          german: 'Tippen zum Umdrehen', english: 'Tap to flip'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      );
}

/// Widget representing the back side of a vocabulary flashcard.
///
/// Once the flashcard is flipped, this widget displays the translation
/// (English or Dari) along with additional context like an example sentence
/// and the category tag. It uses a different gradient (green shades) to
/// visually distinguish it from the front side.
class FlashcardBack extends StatelessWidget {
  const FlashcardBack({
    super.key,
    required this.word,
    required this.isDari,
    this.lastResult,
  });

  final VocabWord word;
  final bool isDari;
  final ReviewResult? lastResult;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF0D9488)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.35),
                blurRadius: 30,
                offset: const Offset(0, 12))
          ],
        ),
        child: Stack(
          children: [
            // Inner Highlight
            Positioned(
              top: 1,
              left: 1,
              right: 1,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Difficulty Badge
            Positioned(
              top: 20,
              left: 20,
              child: _DifficultyBadge(result: lastResult),
            ),

            Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    (isDari ? 'دری' : 'English').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    isDari ? word.dari : word.english,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                    textAlign: TextAlign.center,
                    textDirection:
                        isDari ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.format_quote_rounded,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        word.example,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.95),
                            height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (word.tag.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      word.tag,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ]),
            ),
          ],
        ),
      );
}

/// A reusable custom button for the flashcard difficulty options.
///
/// Features a large emoji representing the difficulty level ("Schwer", "Mittel", "Leicht")
/// and a text title below it. The background uses a slight opacity of the primary
/// color to visually group the buttons while keeping the UI airy.
class FlashcardDifficultyButton extends StatelessWidget {
  const FlashcardDifficultyButton({
    super.key,
    required this.emoji,
    required this.title,
    required this.bg,
    required this.fg,
    required this.onTap,
    this.border,
  });

  final String emoji;
  final String title;
  final Color bg, fg;
  final VoidCallback onTap;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: isDark ? fg.withValues(alpha: 0.1) : bg,
            borderRadius: BorderRadius.circular(20),
            border: border ??
                Border.all(
                  color: fg.withValues(alpha: isDark ? 0.2 : 0.1),
                  width: 1.5,
                ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 8),
              Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: fg,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A custom stylized back button used in the vocabulary flashcard session.
///
/// It leverages the theme's brightness (`isDark`) to ensure proper contrast
/// and drops a soft shadow for depth, providing an elegant way to exit out
/// of the full-screen flashcard experience.
class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    super.key,
    required this.isDark,
    required this.onTap,
  });

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
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              size: 16,
              color:
                  isDark ? const Color(0xFF94A3B8) : const Color(0xFF374151)),
        ),
      );
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.result});

  final ReviewResult? result;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (result) {
      ReviewResult.hard => ('HARD', const Color(0xFFEF4444)),
      ReviewResult.medium => ('MEDIUM', const Color(0xFFF59E0B)),
      ReviewResult.easy => ('EASY', const Color(0xFF22C55E)),
      null => ('NEW', Colors.white), // White for "New" to stand out on purple
    };

    final isNew = result == null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isNew ? 0.2 : 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: isNew ? 0.4 : 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: color.withValues(alpha: isNew ? 0.95 : 1.0),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
