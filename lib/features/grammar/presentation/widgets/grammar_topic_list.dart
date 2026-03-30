import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/localization/app_ui_text.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/content/sync/sync_service.dart';
import '../../../../core/content/sync/connectivity_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../shared/widgets/app_state_view.dart';
import '../../domain/grammar_providers.dart';
import '../../domain/grammar_view_providers.dart';
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
  final Map<String, List<SyncEntry<GrammarTopic>>> groupedTopics;

  void _showDownloadDialog(
      BuildContext context, WidgetRef ref, SyncEntry<GrammarTopic> entry) {
    final strings = AppUiText(ref.read(displayLanguageProvider));
    if (!(ref.read(connectivityProvider).valueOrNull ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.offlineMessage()),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(entry.displayTitle),
        content: Text(strings.grammarLabel('download_prompt')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(strings.grammarLabel('cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final lang = ref.read(displayLanguageProvider);
              await ref
                  .read(syncServiceProvider)
                  .downloadGrammarTopic(entry.id, languageCode: lang);
            },
            child: Text(strings.grammarLabel('download')),
          ),
        ],
      ),
    );
  }

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
                    context.go(uri.toString());
                  },
                  onDownload: () =>
                      _showDownloadDialog(context, ref, topicEntry),
                )),
          ],
        );
      }).toList(),
    );
  }
}
