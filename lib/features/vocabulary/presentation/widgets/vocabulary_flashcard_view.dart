/// Standalone widget for the active flashcard session.
///
/// Responsibilities:
/// - Renders the 3D flip animation for flashcards.
/// - Handles horizontal swipe gestures for navigating cards.
/// - Provides buttons for marking a card (hard, medium, easy).
/// - Plays pronunciation audio using the device text-to-speech engine.
///
/// Moving this out of the main screen isolates the complex animation state
/// and gesture recognizers, drastically improving readability.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/core/learning/review_logic.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/shared/widgets/app_state_view.dart';
import 'package:deutschmate_mobile/features/vocabulary/data/models/vocabulary_category.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_flashcard_session.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_providers.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_view_providers.dart';
import './vocabulary_flashcard_widgets.dart'; // FlashcardFront, FlashcardBack

/// The main view for the interactive flashcard learning session.
/// orchestrates the flipping animation, gesture handling, and state reporting.
class VocabularyFlashcardView extends ConsumerStatefulWidget {
  const VocabularyFlashcardView({super.key});

  @override
  ConsumerState<VocabularyFlashcardView> createState() =>
      _VocabularyFlashcardViewState();
}

class _VocabularyFlashcardViewState
    extends ConsumerState<VocabularyFlashcardView>
    with TickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  late final AnimationController _speakerPulseController;
  late final FlutterTts _flutterTts;
  final Map<String, bool> _favoriteOverrides = {};
  bool _isSpeaking = false;

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
    _speakerPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _flutterTts = FlutterTts();

    _flutterTts.setStartHandler(() {
      if (!mounted) return;
      setState(() {
        _isSpeaking = true;
      });
      _speakerPulseController.repeat(reverse: true);
    });
    _flutterTts.setCompletionHandler(() {
      _stopSpeakingEffect();
    });
    _flutterTts.setCancelHandler(() {
      _stopSpeakingEffect();
    });
    _flutterTts.setErrorHandler((_) {
      _stopSpeakingEffect();
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _speakerPulseController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _stopSpeakingEffect() {
    if (!mounted) return;
    _speakerPulseController.stop();
    _speakerPulseController.value = 0;
    if (_isSpeaking) {
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  void _exitFlashcards() {
    setState(() {
      _flipController.value = 0;
    });
    ref.read(vocabularyFlashcardSessionProvider.notifier).exit();
    ref.invalidate(vocabularyReviewStateProvider);
  }

  Future<void> _toggleFavorite(VocabularyWord word, bool isFavorite) async {
    setState(() {
      _favoriteOverrides[word.id] = !isFavorite;
    });

    await ref.read(appSettingsActionsProvider).toggleFavorite(word.id);
  }

  Future<void> _playPronunciation(String word) async {
    try {
      await _flutterTts.stop();
      if (mounted) {
        setState(() {
          _isSpeaking = true;
        });
        _speakerPulseController.repeat(reverse: true);
      }
      await _flutterTts.setLanguage('de-DE');
      await _flutterTts.setSpeechRate(0.45);
      await _flutterTts.setPitch(1.0);
      final result = await _flutterTts.speak(word);
      if (result != 1 && mounted) {
        _stopSpeakingEffect();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not play pronunciation.')),
        );
      }
    } catch (_) {
      _stopSpeakingEffect();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not play pronunciation.')),
        );
      }
    }
  }

  Future<void> _nextFlashcard(
      ReviewResult result, List<VocabularyWord> words) async {
    final session = ref.read(vocabularyFlashcardSessionProvider);
    if (session.entries.isEmpty) {
      return;
    }

    final currentWord = words[session.index % words.length];

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
    final nativeLanguage = ref.watch(nativeLanguageProvider);
    final isDari = nativeLanguage == 'fa' || nativeLanguage == 'dari';
    final strings = AppUiText(displayLanguage);

    final flashcardSession = ref.watch(vocabularyFlashcardSessionProvider);
    final filtered = ref.watch(visibleVocabularyEntriesProvider);
    final allEntries = ref.watch(localVocabularyEntriesProvider);
    final groups = ref.watch(vocabularyGroupsStreamProvider).valueOrNull ?? [];
    final categories =
        ref.watch(vocabularyCategoriesStreamProvider).valueOrNull ?? [];

    final sourceEntries = flashcardSession.entries.isNotEmpty
        ? flashcardSession.entries
        : filtered.isNotEmpty
            ? filtered
            : allEntries;
    final words = sourceEntries.toList(growable: false);

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

    final currentIndex = flashcardSession.index % words.length;
    final currentWord = words[currentIndex];
    final isFavorite =
        _favoriteOverrides[currentWord.id] ?? currentWord.isFavorite;

    // Determine the current difficulty result (preferring optimistic updates)
    final optimisticResults = ref.watch(vocabularyOptimisticReviewsProvider);
    final reviewState = ref.watch(vocabularyReviewStateProvider).valueOrNull;
    final reviewInfo = reviewState?.byWordId[currentWord.id];

    // If a word has never been reviewed, we show it as "New" regardless of the
    // default "easy" or "medium" value stored in the JSON metadata.
    final lastResult = optimisticResults[currentWord.id] ??
        (reviewInfo != null && reviewInfo.reviewCount > 0
            ? reviewInfo.lastResult
            : null);

    final progress = (currentIndex + 1) / words.length;

    final categoryMatch = categories
        .where((category) => category.id == currentWord.category)
        .toList();
    final flashcardCategory = categoryMatch.isNotEmpty
        ? VocabularyCategory.fromData(
            categoryMatch.first,
            groups
                .where((group) => group.id == categoryMatch.first.groupId)
                .map((group) => group.name)
                .first,
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        flashcardCategory?.displayName ??
                            strings.either(
                                german: 'Wortkarten', english: 'Flashcards'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTokens.textPrimary(isDark),
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (flashcardCategory != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          flashcardCategory.groupDisplayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTokens.textMuted(isDark),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTokens.surfaceMuted(isDark),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${currentIndex + 1} / ${words.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color:
                          AppTokens.textPrimary(isDark).withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTokens.surfaceMuted(isDark),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  height: 6,
                  width: MediaQuery.of(context).size.width *
                      0.9 *
                      progress, // Approximation
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTokens.primary(isDark),
                        AppTokens.primary(isDark).withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTokens.primary(isDark).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _FlashcardActionButton(
                  icon: Icons.volume_up_rounded,
                  onTap: () => _playPronunciation(currentWord.german),
                  isDark: isDark,
                  isLive: _isSpeaking,
                  pulse: _speakerPulseController,
                  tooltip: strings.either(
                      german: 'Aussprache', english: 'Pronunciation'),
                ),
                const Spacer(),
                _FlashcardActionButton(
                  icon: isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  onTap: () => _toggleFavorite(currentWord, isFavorite),
                  isDark: isDark,
                  active: isFavorite,
                  activeBgColor: AppTokens.stateDangerSurface(isDark),
                  activeFgColor: AppTokens.stateDangerForeground(isDark),
                  tooltip:
                      strings.either(german: 'Favorit', english: 'Favorite'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  final notifier =
                      ref.read(vocabularyFlashcardSessionProvider.notifier);
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
                      ref
                          .read(vocabularyFlashcardSessionProvider.notifier)
                          .next();
                      setState(() {
                        _flipController.value = 0;
                      });
                    } else {
                      _exitFlashcards();
                    }
                  } else if (velocity > 300 && flashcardSession.index > 0) {
                    ref
                        .read(vocabularyFlashcardSessionProvider.notifier)
                        .previous();
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
                              child: FlashcardBack(
                                word: currentWord,
                                isDari: isDari,
                                lastResult: lastResult,
                              ),
                            )
                          : FlashcardFront(
                              word: currentWord,
                              strings: strings,
                              lastResult: lastResult,
                            ),
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
                    border: lastResult == ReviewResult.hard
                        ? Border.all(color: Colors.red, width: 3)
                        : null,
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
                    border: lastResult == ReviewResult.medium
                        ? Border.all(color: Colors.orange, width: 3)
                        : null,
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
                    border: lastResult == ReviewResult.easy
                        ? Border.all(color: Colors.green, width: 3)
                        : null,
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
    this.isLive = false,
    this.pulse,
    this.active = false,
    this.activeBgColor,
    this.activeFgColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final String tooltip;
  final bool isLive;
  final AnimationController? pulse;
  final bool active;
  final Color? activeBgColor;
  final Color? activeFgColor;

  @override
  Widget build(BuildContext context) {
    final defaultActiveBg =
        isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE);
    final defaultActiveFg = isDark ? Colors.white : const Color(0xFF1D4ED8);

    final background = active
        ? (activeBgColor ?? defaultActiveBg)
        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC));
    final foreground = active
        ? (activeFgColor ?? defaultActiveFg)
        : AppTokens.textPrimary(isDark);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedBuilder(
            animation: pulse ?? const AlwaysStoppedAnimation<double>(0),
            builder: (context, child) {
              final pulseValue = isLive && pulse != null ? pulse!.value : 0.0;
              final scale = isLive ? 1.0 + (pulseValue * 0.06) : 1.0;
              final glowOpacity = isLive ? 0.08 + (pulseValue * 0.14) : 0.0;

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 56,
                  height: 42,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      if (isLive)
                        BoxShadow(
                          color: AppTokens.primary(isDark)
                              .withValues(alpha: glowOpacity),
                          blurRadius: 18,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isLive)
                        Container(
                          width: 30 + (pulseValue * 8),
                          height: 30 + (pulseValue * 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTokens.primary(isDark)
                                .withValues(alpha: 0.08),
                          ),
                        ),
                      Icon(icon, size: 22, color: foreground),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
