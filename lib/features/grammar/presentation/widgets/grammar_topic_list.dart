import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/widgets/app_state_view.dart';
import 'package:deutschmate_mobile/features/grammar/domain/grammar_providers.dart';
import 'package:deutschmate_mobile/features/grammar/domain/grammar_view_providers.dart';
import 'grammar_widgets.dart'; // Provides GrammarTopicCard

/// Renders the list of grammar topics grouped by level.
///
/// Responsibilities:
/// - Displays an empty state message if no topics match the current filters.
/// - Iterates through the grouped topics Map from `groupedGrammarTopicsProvider`.
/// - Sorts the topics using `compareGrammarEntries`.
/// - Renders a `GrammarTopicCard` for each topic.
/// - Handles routing to the topic details page upon tapping a card.
/// - Handles the offline download dialog logic for individual topics.
class GrammarTopicList extends ConsumerWidget {
  const GrammarTopicList({
    super.key,
    required this.groupedTopics,
  });

  /// The pre-filtered and pre-grouped topics from `groupedGrammarTopicsProvider`.
  final Map<String, List<GrammarTopic>> groupedTopics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    final selectedLevel = ref.watch(selectedGrammarLevelProvider);
    final selectedCategory = ref.watch(selectedGrammarCategoryProvider);
    final showFilters = ref.watch(grammarShowFiltersProvider);

    if (groupedTopics.isEmpty) {
      return AppStateView.empty(
        title: strings.either(
            german: 'Keine Themen gefunden', english: 'No topics found'),
        message: strings.either(
          german:
              'Passe Level oder Kategorie an, um passende Grammatikthemen zu sehen.',
          english:
              'Adjust the level or category to see matching grammar topics.',
        ),
        icon: Icons.search_off_rounded,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedTopics.entries.map((entry) {
        final level = entry.key;
        final topics = entry.value..sort(compareGrammarEntries);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 16),
              child: Text(
                level,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark ? AppTokens.darkText : AppTokens.lightText),
              ),
            ),
            ...topics.map((topicEntry) => GrammarTopicCard(
                  entry: topicEntry,
                  onTap: () {
                    final uri = Uri(
                      path: '/grammar/${topicEntry.id}',
                      queryParameters: {
                        'level': selectedLevel,
                        'category': selectedCategory,
                        'showFilters': showFilters ? '1' : '0',
                      },
                    );
                    context.push(uri.toString());
                  },
                )),
          ],
        );
      }).toList(),
    );
  }
}
