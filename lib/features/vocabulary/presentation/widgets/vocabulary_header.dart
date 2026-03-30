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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/content/sync/sync_service.dart';
import '../../../../shared/localization/app_ui_text.dart';
import '../../../grammar/presentation/widgets/grammar_widgets.dart'; // For GrammarIconButton
import '../../domain/vocabulary_providers.dart';
import 'vocabulary_group_filter_sheet.dart';

/// A widget that displays the header section of the vocabulary screen.
/// Includes the title, a back button, tab navigation, and a filter button.
class VocabularyHeader extends ConsumerWidget {
  const VocabularyHeader({super.key});

  static const List<String> _tabs = ['words', 'phrases', 'favorites'];

  /// Helper method to toggle a pinned group.
  /// Moved from the main screen to keep filter logic self-contained.
  void _togglePinnedGroup(WidgetRef ref, String? groupId) {
    final categories = ref.read(vocabularyCategoriesStreamProvider).valueOrNull ?? [];
    final selectedCategory = ref.read(vocabularySelectedCategoryProvider);
    String? selectedCategoryGroup;
    
    if (selectedCategory != null) {
      final match = categories.where((category) => category.id == selectedCategory).toList();
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
    final categories = ref.read(vocabularyCategoriesStreamProvider).valueOrNull ?? [];
    final pendingCategories = ref.read(vocabularyPendingCategoriesStreamProvider).valueOrNull ?? [];
    final allEntries = ref.read(hybridVocabularyProvider).valueOrNull ?? [];

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
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Back Button
              GrammarIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                isDark: isDark,
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
              const SizedBox(width: 10),
              
              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.either(german: 'Wortschatz', english: 'Vocabulary'),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: isDark ? AppTokens.darkText : AppTokens.lightText,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.either(german: 'Wörter & Phrasen', english: 'Words & phrases'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted,
                          ),
                    ),
                  ],
                ),
              ),
              
              // Filter Button
              GrammarIconButton(
                icon: Icons.filter_alt_rounded,
                isDark: isDark,
                active: pinnedGroupIds.isNotEmpty,
                onPressed: () => _showGroupFilterSheet(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Tab Selector
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: _tabs.map((tabKey) {
                final isSelected = tab == tabKey;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => ref.read(vocabularyTabProvider.notifier).state = tabKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? const Color(0xFF334155) : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected && !isDark
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        strings.vocabularyTab(tabKey),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? AppTokens.textPrimary(isDark)
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
