/// A comprehensive grid view displays vocabulary groups and their respective categories.
///
/// Responsibilities:
/// - Displays expansion tiles for each Vocabulary Group.
/// - Calculates and displays progress bars/counts for each category inside a group.
/// - Handles downloading missing (remote) categories.
/// - Allows the user to unpin a group or initiate a flashcard session on a category.
///
/// This component is self-sufficient and pulls its required lists and state
/// directly from Riverpod providers.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/core/learning/review_logic.dart';
import 'package:deutschmate_mobile/core/learning/vocabulary_review.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/shared/widgets/app_state_view.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/features/vocabulary/data/models/vocabulary_category.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_category_metrics.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_flashcard_session.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_providers.dart';
import 'package:deutschmate_mobile/features/vocabulary/domain/vocabulary_view_providers.dart';
import './vocabulary_category_card.dart';

/// A widget that displays a vertically scrollable list of expandable vocabulary groups.
/// Each group contains a grid of categories relevant to that group.
class VocabularyCategoryGrid extends ConsumerStatefulWidget {
  const VocabularyCategoryGrid({super.key});

  @override
  ConsumerState<VocabularyCategoryGrid> createState() =>
      _VocabularyCategoryGridState();
}

class _VocabularyCategoryGridState
    extends ConsumerState<VocabularyCategoryGrid> {
  // Local state to track which groups the user has expanded in the grid.
  final Map<String, bool> _groupExpanded = <String, bool>{};

  static const Map<String, String> _groupLabels = {
    'personal_information': 'Personal Information',
    'authorities_visa': 'Authorities & Visa',
    'work_business': 'Work & Business',
    'travel_transport': 'Travel & Transport',
    'home_housing': 'Home & Housing',
    'health_body': 'Health & Body',
    'education': 'Education',
    'daily_life_basics': 'Daily Life Basics',
    'technology_it': 'Technology & IT',
    'abstract_formal_language': 'Abstract & Formal Language',
  };

  /// Removes a group from the active filter.
  void _unpinGroup(WidgetRef ref, String groupId,
      List<VocabularyCategoryEntity> categories) {
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

    nextPinnedGroupIds.remove(groupId);
    ref.read(vocabularyPinnedGroupProvider.notifier).state = nextPinnedGroupIds;

    setState(() {
      _groupExpanded.remove(groupId); // Reset expansion state when unpinned
    });

    if (nextPinnedGroupIds.isNotEmpty &&
        selectedCategory != null &&
        (selectedCategoryGroup == null ||
            !nextPinnedGroupIds.contains(selectedCategoryGroup))) {
      ref.read(vocabularySelectedCategoryProvider.notifier).state = null;
    } else if (nextPinnedGroupIds.isEmpty) {
      ref.read(vocabularySelectedCategoryProvider.notifier).state = null;
    }
  }

  /// Begins a flashcard session specifically for the selected category.
  void _startFlashcardsForCategory(
      BuildContext context,
      List<VocabularyWord> rawCatEntries,
      Map<String, VocabularyReviewInfo> reviewById,
      Map<String, ReviewResult> optimisticReviews) {
    if (rawCatEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No words in this category')),
      );
      return;
    }

    // Determine priority sort order based on previous review performance.
    final orderedIds = vocabularyPriorityFlashcardQueue(
      rawCatEntries,
      reviewById,
      optimisticReviews,
    );

    final entryById = {for (final e in rawCatEntries) e.id: e};
    final flashcardEntries = orderedIds.isEmpty
        ? rawCatEntries
        : orderedIds
            .map((id) => entryById[id])
            .whereType<VocabularyWord>()
            .toList(growable: false);

    ref
        .read(vocabularyFlashcardSessionProvider.notifier)
        .start(flashcardEntries.isEmpty ? rawCatEntries : flashcardEntries);
  }

  IconData _getGroupIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('basics') || lowerName.contains('alltag')) {
      return Icons.chat_bubble_outline_rounded;
    }
    if (lowerName.contains('personal') || lowerName.contains('information')) {
      return Icons.person_outline_rounded;
    }
    if (lowerName.contains('authorities') ||
        lowerName.contains('visa') ||
        lowerName.contains('behörden')) {
      return Icons.assignment_ind_rounded;
    }
    if (lowerName.contains('travel') ||
        lowerName.contains('transport') ||
        lowerName.contains('reise')) {
      return Icons.directions_bus_rounded;
    }
    if (lowerName.contains('home') ||
        lowerName.contains('housing') ||
        lowerName.contains('wohnen')) {
      return Icons.home_outlined;
    }
    if (lowerName.contains('health') ||
        lowerName.contains('body') ||
        lowerName.contains('gesundheit')) {
      return Icons.favorite_border_rounded;
    }
    if (lowerName.contains('education') ||
        lowerName.contains('bildung') ||
        lowerName.contains('schule')) {
      return Icons.school_outlined;
    }
    if (lowerName.contains('work') ||
        lowerName.contains('career') ||
        lowerName.contains('arbeit')) {
      return Icons.work_outline_rounded;
    }
    if (lowerName.contains('shopping') || lowerName.contains('einkaufen')) {
      return Icons.shopping_bag_outlined;
    }
    return Icons.folder_outlined;
  }

  List<VocabularyGroupEntity> _buildFallbackGroups(
    List<VocabularyCategoryEntity> categories,
  ) {
    final groupIds = <String>{
      for (final category in categories) category.groupId,
    }.toList();

    groupIds.sort((left, right) {
      final leftOrder = _groupLabels.keys.toList().indexOf(left);
      final rightOrder = _groupLabels.keys.toList().indexOf(right);
      return leftOrder.compareTo(rightOrder);
    });

    return groupIds
        .map(
          (groupId) => VocabularyGroupEntity(
            id: groupId,
            name: _groupLabels[groupId] ?? groupId,
            levelRange: '',
            sortOrder: _groupLabels.keys.toList().indexOf(groupId),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    // Read all required global state
    final groupsAsync = ref.watch(vocabularyGroupsStreamProvider);
    final categoriesAsync = ref.watch(vocabularyCategoriesStreamProvider);
    final pinnedGroupIds = ref.watch(vocabularyPinnedGroupProvider);
    final allEntries = ref.watch(localVocabularyEntriesProvider);
    final reviewState = ref.watch(vocabularyReviewStateProvider);
    final optimisticReviews = ref.watch(vocabularyOptimisticReviewsProvider);

    // Initial state error handling/loading
    if (groupsAsync.hasError || categoriesAsync.hasError) {
      debugPrint('Vocabulary groups error: ${groupsAsync.error}');
      debugPrint('Vocabulary categories error: ${categoriesAsync.error}');
      return AppStateView.error(
        message: 'Failed to load vocabulary categories',
        onAction: () {
          ref.invalidate(vocabularyGroupsStreamProvider);
          ref.invalidate(vocabularyCategoriesStreamProvider);
          ref.invalidate(vocabularyPendingCategoriesStreamProvider);
          ref.invalidate(vocabularyReviewStateProvider);
        },
      );
    }

    if (!groupsAsync.hasValue || !categoriesAsync.hasValue) {
      return const AppStateView.loading();
    }

    final groups = groupsAsync.valueOrNull ?? [];
    final categories = categoriesAsync.valueOrNull ?? [];
    final reviewById = reviewState.valueOrNull?.byWordId ?? {};

    // Show all groups by default. If the database groups table is empty, build
    // a fallback group list from the loaded categories so the screen still renders.
    final fallbackGroups =
        groups.isEmpty ? _buildFallbackGroups(categories) : groups;
    final displayedGroups = pinnedGroupIds.isEmpty
        ? fallbackGroups
        : fallbackGroups.where((g) => pinnedGroupIds.contains(g.id)).toList();
    final groupsToRender = displayedGroups.isEmpty
        ? (groups.isEmpty ? fallbackGroups : groups)
        : displayedGroups;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: groupsToRender.length,
      itemBuilder: (context, groupIndex) {
        final group = groupsToRender[groupIndex];
        final isExpanded = _groupExpanded[group.id] ?? true;

        // Collect all categories belonging to this group
        final groupCategories =
            categories.where((c) => c.groupId == group.id).toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PremiumCard(
            padding: EdgeInsets.zero,
            useGlass: true,
            blur: 10,
            borderOpacity: isDark ? 0.08 : 0.05,
            shadowOpacity: isDark ? 0.1 : 0.04,
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: isExpanded,
                onExpansionChanged: (val) {
                  setState(() => _groupExpanded[group.id] = val);
                },
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF6366F1), const Color(0xFF4F46E5)]
                          : [const Color(0xFF4F46E5), const Color(0xFF4338CA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getGroupIcon(group.name),
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                title: Text(
                  group.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                    color: AppTokens.textPrimary(isDark),
                  ),
                ),
                subtitle: Text(
                  '${groupCategories.length} categories',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.textMuted(isDark),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (pinnedGroupIds.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.push_pin_rounded,
                          size: 20,
                          color:
                              AppTokens.primary(isDark).withValues(alpha: 0.6),
                        ),
                        onPressed: () => _unpinGroup(ref, group.id, categories),
                        tooltip: 'Unpin group',
                      ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppTokens.textMuted(isDark),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    child: Column(
                      children: groupCategories.map((categoryData) {
                        final category = VocabularyCategory.fromData(
                            categoryData, group.name, strings);

                        final categoryEntries =
                            entriesForCategory(allEntries, category.id);

                        final learned = vocabularyCategoryLearnedCount(
                            categoryEntries,
                            reviewById,
                            category.id,
                            optimisticReviews);

                        final total = vocabularyCategoryTotalCount(
                            categoryEntries, category.id);

                        final progress = total > 0 ? learned / total : 0.0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: VocabularyCategoryCard(
                            category: category,
                            title: category.displayName,
                            isCached: true,
                            countLabel: vocabularyCategoryCountLabel(
                              strings: strings,
                              learned: learned,
                              total: total,
                            ),
                            progress: progress,
                            onTap: () {
                              _startFlashcardsForCategory(
                                  context,
                                  categoryEntries,
                                  reviewById,
                                  optimisticReviews);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
