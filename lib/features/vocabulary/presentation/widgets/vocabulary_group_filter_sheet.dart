/// A bottom sheet widget that allows users to filter vocabulary by groups.
///
/// Responsibilities:
/// - Displays a list of available `VocabularyGroupEntity`s.
/// - Shows the count of categories and words within each group.
/// - Allows the user to toggle pinning a group to persist their selection.
/// - Indicates if a group contains pending categories that need downloading.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_category_metrics.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_providers.dart';

class VocabularyGroupFilterSheet extends ConsumerWidget {
  const VocabularyGroupFilterSheet({
    super.key,
    required this.groups,
    required this.categories,
    required this.pendingCategories,
    required this.allEntries,
    required this.onTogglePinnedGroup,
  });

  final List<VocabularyGroupEntity> groups;
  final List<VocabularyCategoryEntity> categories;
  final List<VocabularyPendingCategoryEntity> pendingCategories;
  final List<VocabularyWord> allEntries;
  final ValueChanged<String?> onTogglePinnedGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final pinnedGroupIds = ref.watch(vocabularyPinnedGroupProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String groupLabel(String groupId) {
      final match = groups.where((group) => group.id == groupId).toList();
      return match.isEmpty ? groupId : match.first.name;
    }

    final activeGroups = pinnedGroupIds.map(groupLabel).join(', ');

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      shrinkWrap: true,
      children: [
        Text(
          strings.either(german: 'Gruppen filtern', english: 'Filter groups'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          strings.either(
            german: 'Pinne eine oder mehrere Gruppen, bis du sie wieder löst.',
            english: 'Pin one or more groups until you unpin them.',
          ),
          style: TextStyle(
            fontSize: 13,
            color: AppTokens.textMuted(isDark),
          ),
        ),
        const SizedBox(height: 16),
        if (pinnedGroupIds.isNotEmpty)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.push_pin_outlined),
            title: Text(
              strings.either(german: 'Filter lösen', english: 'Unpin filter'),
            ),
            subtitle: Text(
              strings.either(
                german: 'Aktiv: $activeGroups',
                english: 'Active: $activeGroups',
              ),
            ),
            onTap: () {
              onTogglePinnedGroup(null);
              Navigator.of(context).pop();
            },
          ),
        for (final group in groups)
          ListTile(
            contentPadding: EdgeInsets.zero,
            trailing: pendingCategories
                    .any((category) => category.groupId == group.id)
                ? const Icon(Icons.download_rounded)
                : null,
            leading: Icon(
              pinnedGroupIds.contains(group.id)
                  ? Icons.push_pin_rounded
                  : Icons.push_pin_outlined,
            ),
            title: Text(strings.vocabularyGroup(group.name)),
            subtitle: Text(
              '${categories.where((category) => category.groupId == group.id).length} ${strings.either(german: 'Kategorien', english: 'categories')} · ${vocabularyCountForGroup(allEntries, categories, group.id)} ${strings.either(german: 'Wörter', english: 'words')}',
            ),
            onTap: () {
              onTogglePinnedGroup(group.id);
            },
          ),
      ],
    );
  }
}
