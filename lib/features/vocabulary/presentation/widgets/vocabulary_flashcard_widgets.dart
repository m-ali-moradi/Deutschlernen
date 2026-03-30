import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/localization/app_ui_text.dart';

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
  });

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
                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 10))
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(strings.either(german: 'Deutsch', english: 'German'),
              style: TextStyle(
                  fontSize: 14, color: Colors.white.withValues(alpha: 0.6))),
          const SizedBox(height: 12),
          Text(word.german,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const SizedBox(height: 24),
          Text(
              strings.either(
                  german: 'Tippen zum Umdrehen', english: 'Tap to flip'),
              style: TextStyle(
                  fontSize: 12, color: Colors.white.withValues(alpha: 0.4))),
        ]),
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
  });

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
                color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 10))
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(isDari ? 'دری' : 'English',
              style: TextStyle(
                  fontSize: 14, color: Colors.white.withValues(alpha: 0.6))),
          const SizedBox(height: 12),
          Text(isDari ? word.dari : word.english,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              textAlign: TextAlign.center,
              textDirection: isDari ? TextDirection.rtl : TextDirection.ltr),
          const SizedBox(height: 14),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16)),
            child: Text(word.example,
                style: TextStyle(
                    fontSize: 13, color: Colors.white.withValues(alpha: 0.9)),
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(100)),
            child: Text(word.tag,
                style: const TextStyle(fontSize: 11, color: Colors.white)),
          ),
        ]),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 4),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: fg.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
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
