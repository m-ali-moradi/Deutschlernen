/// Standalone widget for displaying a flat list of vocabulary words.
/// 
/// Responsibilities:
/// - Displays the list of currently filtered vocabulary entries.
/// - Connects each word to the `appSettingsActionsProvider` to allow toggling favorites.
/// - Determines if Dari (Farsi) mode is active.
/// 
/// Note: This widget reads the visible entries directly from providers, meaning 
/// the parent doesn't need to manually filter or pass the list down.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../shared/localization/app_ui_text.dart';
import '../../../../shared/widgets/app_state_view.dart';
import '../../domain/vocabulary_view_providers.dart';
import 'vocabulary_list_items.dart';

/// A list view widget that simply renders the currently visible vocabulary words
/// based on the `visibleVocabularyEntriesProvider` state.
class VocabularyWordList extends ConsumerWidget {
  const VocabularyWordList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    
    // Check if the current language mode includes Dari
    final displayLanguage = ref.watch(displayLanguageProvider);
    final isDari = displayLanguage == 'fa' || displayLanguage == 'dari';

    // Retrieve dynamically filtered entries from our clean provider
    final entries = ref.watch(visibleVocabularyEntriesProvider);
    final reviewState = ref.watch(vocabularyReviewStateProvider).valueOrNull?.byWordId ?? {};

    if (entries.isEmpty) {
      return AppStateView.empty(
        title: strings.either(
            german: 'Keine Wörter verfügbar', english: 'No words available'),
        message: strings.either(
          german: 'Passe Gruppe, Kategorie oder Favoriten an.',
          english: 'Adjust the group, category, or favorites filter.',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return WordCard(
          entry: entry,
          reviewStatus: reviewState[entry.id]?.status.name ?? 'newWord',
          isDark: isDark,
          isDari: isDari,
          onTap: () {
            // Future enhancement: Add tap functionality, like navigating to word details
          },
          onFavoriteToggle: () {
            final word = entry.localData;
            if (word != null) {
              ref.read(appSettingsActionsProvider).toggleFavorite(word.id);
            }
          },
        );
      },
    );
  }
}
