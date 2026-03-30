/// Main screen for vocabulary management, listing categories and words, and starting flashcard sessions.
/// This screen acts as a coordinator for the various vocabulary views.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_flashcard_session.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_providers.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_view_providers.dart';
import '../widgets/vocabulary_category_grid.dart';
import '../widgets/vocabulary_common_widgets.dart'; // FloatingFlashcardsButton
import '../widgets/vocabulary_flashcard_view.dart';
import '../widgets/vocabulary_header.dart';
import '../widgets/vocabulary_word_list.dart';

class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({
    super.key,
    this.initialCategory,
    this.initialTab = 'words',
    this.initialWordId,
  });

  final String? initialCategory;
  final String initialTab;
  final String? initialWordId;

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialCategory != null) {
        ref.read(vocabularySelectedCategoryProvider.notifier).state =
            widget.initialCategory;
      }
      ref.read(vocabularyTabProvider.notifier).state = widget.initialTab;
    });
  }

  void _startFlashcardsAllVisible() {
    final visibleEntries = ref.read(visibleVocabularyEntriesProvider);
    if (visibleEntries.isNotEmpty) {
      ref
          .read(vocabularyFlashcardSessionProvider.notifier)
          .start(visibleEntries);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final flashcardSession = ref.watch(vocabularyFlashcardSessionProvider);
    final visibleEntries = ref.watch(visibleVocabularyEntriesProvider);
    final tab = ref.watch(vocabularyTabProvider);
    final selectedCategory = ref.watch(vocabularySelectedCategoryProvider);

    return PopScope(
      canPop: !flashcardSession.isActive,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (flashcardSession.isActive) {
          ref.read(vocabularyFlashcardSessionProvider.notifier).exit();
        }
      },
      child: Scaffold(
        backgroundColor: AppTokens.background(isDark),
        body: Stack(
          children: [
            // Premium background
            Positioned.fill(child: AppTokens.meshBackground(isDark)),

            flashcardSession.isActive
                ? const VocabularyFlashcardView()
                : SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        const VocabularyHeader(),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 240),
                            reverseDuration: const Duration(milliseconds: 180),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, animation) {
                              final offset = Tween<Offset>(
                                begin: const Offset(0, 0.03),
                                end: Offset.zero,
                              ).animate(animation);

                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: offset,
                                  child: child,
                                ),
                              );
                            },
                            child: KeyedSubtree(
                              key: ValueKey<String>(
                                '$tab:${selectedCategory ?? 'all'}',
                              ),
                              child: Builder(
                                builder: (context) {
                                  if (tab == 'hard_words') {
                                    return const VocabularyWordList();
                                  }
                                  if (selectedCategory != null ||
                                      tab == 'favorites') {
                                    return const VocabularyWordList();
                                  }
                                  return const VocabularyCategoryGrid();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
        floatingActionButton: (!flashcardSession.isActive &&
                visibleEntries.isNotEmpty)
            ? FloatingFlashcardsButton(
                onTap: _startFlashcardsAllVisible,
              )
            : null,
      ),
    );
  }
}



