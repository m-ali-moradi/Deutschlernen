/// Standalone widget for the active flashcard session.
/// 
/// Responsibilities:
/// - Renders the 3D flip animation for flashcards.
/// - Handles horizontal swipe gestures for navigating cards.
/// - Provides buttons for marking a card (hard, medium, easy).
/// - Plays pronunciation audio using external URL launcher.
/// 
/// Moving this out of the main screen isolates the complex animation state
/// and gesture recognizers, drastically improving readability.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/content/sync/sync_service.dart';
import '../../../../core/learning/review_logic.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/localization/app_ui_text.dart';
import '../../../../shared/widgets/app_state_view.dart';
import '../../data/models/vocabulary_category.dart';
import '../../domain/vocabulary_flashcard_session.dart';
import '../../domain/vocabulary_view_providers.dart';
import 'vocabulary_flashcard_widgets.dart'; // FlashcardFront, FlashcardBack

/// The main view for the interactive flashcard learning session.
/// orchestrates the flipping animation, gesture handling, and state reporting.
class VocabularyFlashcardView extends ConsumerStatefulWidget {
  const VocabularyFlashcardView({super.key});

  @override
  ConsumerState<VocabularyFlashcardView> createState() => _VocabularyFlashcardViewState();
}

class _VocabularyFlashcardViewState extends ConsumerState<VocabularyFlashcardView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _exitFlashcards() {
    setState(() {
      _flipController.value = 0;
    });
    ref.read(vocabularyFlashcardSessionProvider.notifier).exit();
    ref.invalidate(vocabularyReviewStateProvider);
  }

  Future<void> _playPronunciation(String word) async {
    final uri = Uri.parse(
      'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=de&q=${Uri.encodeComponent(word)}',
    );

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not play pronunciation.')),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not play pronunciation.')),
        );
      }
    }
  }

  Future<void> _nextFlashcard(ReviewResult result, List<VocabularyWord> words) async {
    final session = ref.read(vocabularyFlashcardSessionProvider);
    if (session.entries.isEmpty) {
      return;
    }

    final currentWord = session.currentEntry?.localData ?? words[session.index % words.length];
    
    final currentOptimistic = ref.read(vocabularyOptimisticReviewsProvider);
    ref.read(vocabularyOptimisticReviewsProvider.notifier).state = {
      ...currentOptimistic,
      currentWord.id: result,
    };

    await ref.read(appSettingsActionsProvider).recordVocabularyReview(
          wordId: currentWord.id,
          result: result,
        );

    if (session.index >= words.length - 1) {
      _exitFlashcards();
    } else {
      ref.read(vocabularyFlashcardSessionProvider.notifier).next();
      setState(() {
        _flipController.value = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final displayLanguage = ref.watch(displayLanguageProvider);
    final isDari = displayLanguage == 'fa' || displayLanguage == 'dari';
    final strings = AppUiText(displayLanguage);
    
    final flashcardSession = ref.watch(vocabularyFlashcardSessionProvider);
    final filtered = ref.watch(visibleVocabularyEntriesProvider);
    final allEntries = ref.watch(hybridVocabularyProvider).valueOrNull ?? [];
    final groups = ref.watch(vocabularyGroupsStreamProvider).valueOrNull ?? [];
    final categories = ref.watch(vocabularyCategoriesStreamProvider).valueOrNull ?? [];

    final sourceEntries = flashcardSession.entries.isNotEmpty
        ? flashcardSession.entries
        : filtered.isNotEmpty
            ? filtered
            : allEntries;
    final words = sourceEntries.map(extractWordFromEntry).toList(growable: false);

    if (words.isEmpty) {
      return AppStateView.empty(
        title: strings.either(german: 'Keine Wörter verfügbar', english: 'No words available'),
        message: strings.either(
          german: 'Passe Filter oder Kategorie an, um Karten zu sehen.',
          english: 'Adjust the filters or category to see cards.',
        ),
        icon: Icons.inbox_rounded,
      );
    }

    final currentIndex = flashcardSession.index % words.length;
    final currentWord = words[currentIndex];
    final progress = (currentIndex + 1) / words.length;
    
    final categoryMatch = categories.where((category) => category.id == currentWord.category).toList();
    final flashcardCategory = categoryMatch.isNotEmpty
        ? VocabularyCategory.fromData(
            categoryMatch.first,
            groups.where((group) => group.id == categoryMatch.first.groupId).map((group) => group.name).first,
            strings,
          )
        : null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                BackButtonWidget(isDark: isDark, onTap: _exitFlashcards),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        flashcardCategory?.displayName ??
                            strings.either(german: 'Wortkarten', english: 'Flashcards'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTokens.textPrimary(isDark),
                        ),
                      ),
                      if (flashcardCategory != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          flashcardCategory.groupDisplayName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTokens.textMuted(isDark),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('${currentIndex + 1} / ${words.length}'),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Row(
              children: [
                _FlashcardActionButton(
                  icon: Icons.volume_up_rounded,
                  onTap: () => _playPronunciation(currentWord.german),
                  isDark: isDark,
                  tooltip: strings.either(german: 'Aussprache', english: 'Pronunciation'),
                ),
                const Spacer(),
                _FlashcardActionButton(
                  icon: currentWord.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  onTap: () {
                    ref.read(appSettingsActionsProvider).toggleFavorite(currentWord.id);
                  },
                  isDark: isDark,
                  active: currentWord.isFavorite,
                  tooltip: strings.either(german: 'Favorit', english: 'Favorite'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  final notifier = ref.read(vocabularyFlashcardSessionProvider.notifier);
                  final wasFlipped = flashcardSession.isFlipped;
                  notifier.toggleFlip();
                  setState(() {
                    if (wasFlipped) {
                      _flipController.reverse();
                    } else {
                      _flipController.forward();
                    }
                  });
                },
                onHorizontalDragEnd: (details) {
                  final velocity = details.primaryVelocity;
                  if (velocity == null) return;

                  if (velocity < -300) {
                    if (flashcardSession.index < words.length - 1) {
                      ref.read(vocabularyFlashcardSessionProvider.notifier).next();
                      setState(() {
                        _flipController.value = 0;
                      });
                    } else {
                      _exitFlashcards();
                    }
                  } else if (velocity > 300 && flashcardSession.index > 0) {
                    ref.read(vocabularyFlashcardSessionProvider.notifier).previous();
                    setState(() {
                      _flipController.value = 0;
                    });
                  }
                },
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, _) {
                    final angle = _flipAnimation.value * 3.14159;
                    final showBack = angle > 1.57;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: showBack
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(3.14159),
                              child: FlashcardBack(word: currentWord, isDari: isDari),
                            )
                          : FlashcardFront(word: currentWord, strings: strings),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FlashcardDifficultyButton(
                    emoji: '😞',
                    title: strings.either(german: 'Schwer', english: 'Hard'),
                    bg: Colors.red.withValues(alpha: 0.1),
                    fg: Colors.red,
                    onTap: () => _nextFlashcard(ReviewResult.hard, words),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FlashcardDifficultyButton(
                    emoji: '😐',
                    title: strings.either(german: 'Mittel', english: 'Medium'),
                    bg: Colors.orange.withValues(alpha: 0.1),
                    fg: Colors.orange,
                    onTap: () => _nextFlashcard(ReviewResult.medium, words),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FlashcardDifficultyButton(
                    emoji: '😊',
                    title: strings.either(german: 'Leicht', english: 'Easy'),
                    bg: Colors.green.withValues(alpha: 0.1),
                    fg: Colors.green,
                    onTap: () => _nextFlashcard(ReviewResult.easy, words),
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

/// A small semantic button for actions on the flashcard view (audio, favorite).
class _FlashcardActionButton extends StatelessWidget {
  const _FlashcardActionButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
    required this.tooltip,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final String tooltip;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final background = active
        ? (isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE))
        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC));
    final foreground = active
        ? (isDark ? Colors.white : const Color(0xFF1D4ED8))
        : AppTokens.textPrimary(isDark);

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 42,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 22, color: foreground),
        ),
      ),
    );
  }
}
