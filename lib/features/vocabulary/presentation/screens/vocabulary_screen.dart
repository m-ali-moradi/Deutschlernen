/// Main screen for vocabulary management, listing categories and words, and starting flashcard sessions.
/// This screen acts as a coordinator for the various vocabulary views.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/vocabulary_flashcard_session.dart';
import '../../domain/vocabulary_providers.dart';
import '../../domain/vocabulary_view_providers.dart';
import '../widgets/vocabulary_category_grid.dart';
import '../widgets/vocabulary_common_widgets.dart'; // FloatingFlashcardsButton
import '../widgets/vocabulary_flashcard_view.dart';
import '../widgets/vocabulary_header.dart';
import '../widgets/vocabulary_phrase_list.dart';
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
      ref.read(vocabularyFlashcardSessionProvider.notifier).start(visibleEntries);
    }
  }

  @override
  Widget build(BuildContext context) {
    final flashcardSession = ref.watch(vocabularyFlashcardSessionProvider);
    final visibleEntries = ref.watch(visibleVocabularyEntriesProvider);
    final tab = ref.watch(vocabularyTabProvider);
    final selectedCategory = ref.watch(vocabularySelectedCategoryProvider);

    return Scaffold(
      body: flashcardSession.isActive
          ? const VocabularyFlashcardView()
          : Column(
              children: [
                const VocabularyHeader(),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (tab == 'phrases') {
                        return const VocabularyPhraseList();
                      }
                      if (selectedCategory != null || tab == 'favorites') {
                        return const VocabularyWordList();
                      }
                      return const VocabularyCategoryGrid();
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: (!flashcardSession.isActive &&
              tab != 'phrases' &&
              visibleEntries.isNotEmpty)
          ? FloatingFlashcardsButton(
              onTap: _startFlashcardsAllVisible,
            )
          : null,
    );
  }
}
