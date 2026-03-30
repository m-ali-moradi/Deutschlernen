/// Standalone widget for displaying common business/learning phrases.
/// 
/// Responsibilities:
/// - Retrieves phrases from the `PhraseContentService`.
/// - Renders each phrase using the `PhraseCard` component.
/// 
/// Separating this from the main `VocabularyScreen` isolates the purely static 
/// list UI and makes the "Phrases" tab behavior cleaner.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/content/phrase_content_service.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../shared/localization/app_ui_text.dart';
import '../../../../shared/widgets/app_state_view.dart';
import 'vocabulary_list_items.dart';

/// A simple list view that displays the business phrases static content.
class VocabularyPhraseList extends ConsumerWidget {
  const VocabularyPhraseList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    
    // Currently, phrases are statically delivered from the service
    final phrases = PhraseContentService.businessPhrases;
    
    if (phrases.isEmpty) {
      return AppStateView.empty(
        title: strings.either(german: 'Keine Phrasen', english: 'No phrases'),
        message: strings.either(
          german: 'Es sind gerade keine Phrasen verfügbar.',
          english: 'There are no phrases available right now.',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: phrases.length,
      itemBuilder: (context, index) {
        final phrase = phrases[index];
        return PhraseCard(
          phrase: phrase.german,
          english: phrase.english,
          isDark: isDark,
        );
      },
    );
  }
}
