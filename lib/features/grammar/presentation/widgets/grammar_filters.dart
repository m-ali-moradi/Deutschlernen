import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/localization/app_ui_text.dart';
import '../../../../core/database/database_providers.dart';
import '../../data/models/grammar_topic_type.dart';
import '../../domain/grammar_providers.dart';
import '../../domain/grammar_view_providers.dart';
import 'grammar_widgets.dart'; // Provides GrammarLevelChip

/// Renders the level and category filters for grammar topics.
///
/// Responsibilities:
/// - Displays a horizontal scrolling list of Level chips (e.g., A1, B2).
/// - Displays a wrapping list of Category pills (e.g., Verbs, Nouns).
/// - Connects user taps directly to the Riverpod filter states.
/// - Controls the visibility of the categories section via an AnimatedCrossFade.
class GrammarFilters extends ConsumerWidget {
  const GrammarFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    final selectedLevel = ref.watch(selectedGrammarLevelProvider);
    final selectedCategory = ref.watch(selectedGrammarCategoryProvider);
    final showFilters = ref.watch(grammarShowFiltersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- Level Filter ---
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: grammarLevels.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final lvl = grammarLevels[i];
              final selected = selectedLevel == lvl;
              return GrammarLevelChip(
                label: getGrammarCategoryLabel(strings, lvl),
                selected: selected,
                onTap: () =>
                    ref.read(selectedGrammarLevelProvider.notifier).state = lvl,
                isDark: isDark,
              );
            },
          ),
        ),

        // --- Category Filter ---
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState: showFilters
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: grammarCategories.map((cat) {
                final selected = selectedCategory == cat;
                return GestureDetector(
                  onTap: () => ref
                      .read(selectedGrammarCategoryProvider.notifier)
                      .state = cat,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFA855F7)
                          : (isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9)),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      getGrammarCategoryLabel(strings, cat),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? Colors.white
                            : (isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF64748B)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
