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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/content/sync/connectivity_service.dart';
import '../../../../core/content/sync/firebase_content_repository.dart';
import '../../../../core/content/sync/sync_service.dart';
import '../../../../core/learning/review_logic.dart';
import '../../../../core/learning/vocabulary_review.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/localization/app_ui_text.dart';
import '../../../../shared/widgets/app_state_view.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_providers.dart';
import '../../data/models/vocabulary_category.dart';
import '../../domain/vocabulary_category_metrics.dart';
import '../../domain/vocabulary_flashcard_session.dart';
import '../../domain/vocabulary_providers.dart';
import '../../domain/vocabulary_view_providers.dart';
import 'vocabulary_category_card.dart';

/// A widget that displays a vertically scrollable list of expandable vocabulary groups.
/// Each group contains a grid of categories relevant to that group.
class VocabularyCategoryGrid extends ConsumerStatefulWidget {
  const VocabularyCategoryGrid({super.key});

  @override
  ConsumerState<VocabularyCategoryGrid> createState() => _VocabularyCategoryGridState();
}

class _VocabularyCategoryGridState extends ConsumerState<VocabularyCategoryGrid> {
  // Local state to track which groups the user has expanded in the grid.
  final Map<String, bool> _groupExpanded = <String, bool>{};

  /// Shows the standard offline message if the user attempts to download without connection.
  void _showOfflineMessage(BuildContext context, AppUiText strings) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.offlineMessage()),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Removes a group from the active filter.
  void _unpinGroup(WidgetRef ref, String groupId, List<VocabularyCategoryEntity> categories) {
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
    List<SyncEntry<VocabularyWord>> rawCatEntries, 
    Map<String, VocabularyReviewInfo> reviewById,
    Map<String, ReviewResult> optimisticReviews
  ) {
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
            .whereType<SyncEntry<VocabularyWord>>()
            .toList(growable: false);

    ref
        .read(vocabularyFlashcardSessionProvider.notifier)
        .start(flashcardEntries.isEmpty ? rawCatEntries : flashcardEntries);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    
    // Read all required global state
    final groupsAsync = ref.watch(vocabularyGroupsStreamProvider);
    final categoriesAsync = ref.watch(vocabularyCategoriesStreamProvider);
    final pendingCategoriesAsync = ref.watch(vocabularyPendingCategoriesStreamProvider);
    final pinnedGroupIds = ref.watch(vocabularyPinnedGroupProvider);
    final allWordsAsync = ref.watch(hybridVocabularyProvider);
    final reviewState = ref.watch(vocabularyReviewStateProvider);
    final optimisticReviews = ref.watch(vocabularyOptimisticReviewsProvider);
    
    // Fallbacks while loading
    final groups = groupsAsync.valueOrNull ?? [];
    final categories = categoriesAsync.valueOrNull ?? [];
    final pendingCategories = pendingCategoriesAsync.valueOrNull ?? [];
    final allEntries = allWordsAsync.valueOrNull ?? [];
    final reviewById = reviewState.valueOrNull?.byWordId ?? {};

    // Filter visible groups
    final visibleGroups = pinnedGroupIds.isEmpty
        ? groups
        : groups.where((group) => pinnedGroupIds.contains(group.id)).toList();

    if (visibleGroups.isEmpty) {
      return AppStateView.empty(
        title: strings.either(german: 'Keine Gruppen', english: 'No groups'),
        message: strings.either(
          german: 'Die gewählte Filtergruppe ist nicht verfügbar.',
          english: 'The selected filter group is not available.',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: visibleGroups.length,
      itemBuilder: (context, groupIndex) {
        final group = visibleGroups[groupIndex];
        final groupCategories = categories.where((category) => category.groupId == group.id).toList();
        
        if (groupCategories.isEmpty) return const SizedBox();
        
        final pendingCount = pendingCategories.where((category) => category.groupId == group.id).length;
        final isExpanded = _groupExpanded[group.id] ?? (groupIndex == 0);

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) => setState(() => _groupExpanded[group.id] = expanded),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    strings.vocabularyGroup(group.name),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTokens.textPrimary(isDark),
                    ),
                  ),
                ),
                if (pinnedGroupIds.contains(group.id))
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 18,
                      tooltip: strings.either(german: 'Filter lösen', english: 'Unpin filter'),
                      onPressed: () => _unpinGroup(ref, group.id, categories),
                      icon: Icon(
                        Icons.push_pin_rounded,
                        size: 18,
                        color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                if (pendingCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 18,
                      tooltip: strings.either(german: 'Neue Kategorien laden', english: 'Load new categories'),
                      onPressed: () async {
                        final isOnline = ref.read(connectivityProvider).valueOrNull ?? false;
                        if (!isOnline) {
                          _showOfflineMessage(context, strings);
                          return;
                        }
                        await ref.read(syncServiceProvider).downloadVocabularyCategoryGroup(group.id);
                      },
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.download_rounded,
                            size: 18,
                            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                          ),
                          if (pendingCount > 1)
                            Positioned(
                              right: -6,
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '$pendingCount',
                                  style: const TextStyle(
                                    fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groupCategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 108,
                ),
                itemBuilder: (context, index) {
                  final categoryData = groupCategories[index];
                  final category = VocabularyCategory.fromData(categoryData, group.name, strings);
                  
                  final categoryEntries = categoryData.isCached
                      ? entriesForCategory(allEntries, category.id)
                      : ref.watch(vocabularyCategoryRemoteEntriesProvider(category.id)).valueOrNull 
                          ?? entriesForCategory(allEntries, category.id);
                          
                  final easy = vocabularyCategoryEasyCount(categoryEntries, reviewById, category.id, optimisticReviews);
                  final medium = vocabularyCategoryResultCount(categoryEntries, reviewById, category.id, ReviewResult.medium, optimisticReviews);
                  final hard = vocabularyCategoryResultCount(categoryEntries, reviewById, category.id, ReviewResult.hard, optimisticReviews);
                  
                  final total = categoryData.isCached
                      ? vocabularyCategoryTotalCount(categoryEntries, category.id)
                      : (categoryEntries.isNotEmpty ? categoryEntries.length : categoryData.wordCount);
                  
                  final progress = total > 0 ? easy / total : 0.0;

                  return VocabularyCategoryCard(
                    category: category,
                    title: category.displayName,
                    isCached: categoryData.isCached,
                    countLabel: vocabularyCategoryCountLabel(
                      strings: strings, easy: easy, total: total, medium: medium, hard: hard,
                    ),
                    progress: progress,
                    onDownload: categoryData.isCached
                        ? null
                        : () async {
                            final isOnline = ref.read(connectivityProvider).valueOrNull ?? false;
                            if (!isOnline) {
                              _showOfflineMessage(context, strings);
                              return;
                            }
                            await ref.read(syncServiceProvider).downloadVocabularyCategory(category.id);
                          },
                    onTap: () async {
                      List<SyncEntry<VocabularyWord>> catEntries = categoryEntries;

                      if (!categoryData.isCached) {
                        final isOnline = ref.read(connectivityProvider).valueOrNull ?? false;
                        if (!isOnline) {
                          _showOfflineMessage(context, strings);
                          return;
                        }

                        final remoteWords = await ref
                            .read(firebaseContentRepositoryProvider)
                            .getVocabularyWordsByCategoryMetadata(category.id);
                        catEntries = vocabularyEntriesFromRemoteCategoryData(remoteWords, category.id);
                      }

                      if (!mounted) return;

                      _startFlashcardsForCategory(context, catEntries, reviewById, optimisticReviews);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
