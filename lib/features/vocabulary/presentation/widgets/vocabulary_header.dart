/// A standalone header widget for the vocabulary screen.
///
/// Responsibilities:
/// - Displays the screen title and subtitle.
/// - Provides a back navigation button.
/// - Provides a filter button to open the groups/categories filter sheet.
/// - Displays and manages a horizontal tab selector (Words, Phrases, Favorites).
///
/// This widget uses Riverpod to watch its required state (like active tabs and
/// filter groups) so the parent screen doesn't need to pass many arguments.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/features/grammar/presentation/widgets/grammar_widgets.dart'; // For GrammarIconButton
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_providers.dart';
import './vocabulary_group_filter_sheet.dart';

/// A widget that displays the header section of the vocabulary screen.
/// Includes the title, a back button, tab navigation, and a filter button.
class VocabularyHeader extends ConsumerWidget {
  const VocabularyHeader({super.key});

  static const List<String> _tabs = ['words', 'hard_words', 'favorites'];

  /// Helper method to toggle a pinned group.
  /// Moved from the main screen to keep filter logic self-contained.
  void _togglePinnedGroup(WidgetRef ref, String? groupId) {
    final categories =
        ref.read(vocabularyCategoriesStreamProvider).valueOrNull ?? [];
    final selectedCategory = ref.read(vocabularySelectedCategoryProvider);
    String? selectedCategoryGroup;

    if (selectedCategory != null) {
      final match = categories
          .where((category) => category.id == selectedCategory)
          .toList();
      if (match.isNotEmpty) {
        selectedCategoryGroup = match.first.groupId;
      }
    }

    final currentPinnedGroupIds = ref.read(vocabularyPinnedGroupProvider);
    final nextPinnedGroupIds = Set<String>.from(currentPinnedGroupIds);

    if (groupId == null) {
      nextPinnedGroupIds.clear();
    } else if (nextPinnedGroupIds.contains(groupId)) {
      nextPinnedGroupIds.remove(groupId);
    } else {
      nextPinnedGroupIds.add(groupId);
    }

    ref.read(vocabularyPinnedGroupProvider.notifier).state = nextPinnedGroupIds;

    if (nextPinnedGroupIds.isNotEmpty &&
        selectedCategory != null &&
        (selectedCategoryGroup == null ||
            !nextPinnedGroupIds.contains(selectedCategoryGroup))) {
      ref.read(vocabularySelectedCategoryProvider.notifier).state = null;
    }
  }

  /// Displays the modal bottom sheet for filtering groups and categories.
  void _showGroupFilterSheet(BuildContext context, WidgetRef ref) {
    final groups = ref.read(vocabularyGroupsStreamProvider).valueOrNull ?? [];
    final categories =
        ref.read(vocabularyCategoriesStreamProvider).valueOrNull ?? [];
    final pendingCategories =
        ref.read(vocabularyPendingCategoriesStreamProvider).valueOrNull ?? [];
    final allEntries = ref.read(localVocabularyEntriesProvider);

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => VocabularyGroupFilterSheet(
        groups: groups,
        categories: categories,
        pendingCategories: pendingCategories,
        allEntries: allEntries,
        onTogglePinnedGroup: (groupId) => _togglePinnedGroup(ref, groupId),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final tab = ref.watch(vocabularyTabProvider);
    final pinnedGroupIds = ref.watch(vocabularyPinnedGroupProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.either(
                          german: 'Wortschatz', english: 'Vocabulary'),
                      style: AppTokens.headingStyle(context, isDark),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.either(
                          german: 'Wörter & Phrasen',
                          english: 'Words & phrases'),
                      style: AppTokens.subheadingStyle(context, isDark),
                    ),
                  ],
                ),
              ),

              // Filter Button
              GrammarIconButton(
                icon: Icons.filter_list_rounded,
                active: pinnedGroupIds.isNotEmpty,
                onPressed: () => _showGroupFilterSheet(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tab Selector (Modernized with Premium Styling)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.white.withValues(alpha: 0.03) 
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark 
                    ? Colors.white.withValues(alpha: 0.05) 
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: _tabs.map((tabKey) {
                final isSelected = tab == tabKey;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => ref
                        .read(vocabularyTabProvider.notifier)
                        .state = tabKey,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: AppTokens.gradientBluePurple,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTokens.gradientBluePurple.first
                                      .withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        strings.vocabularyTab(tabKey),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : AppTokens.textMuted(isDark),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}



