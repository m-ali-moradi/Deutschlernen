import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/shared/widgets/app_state_view.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/features/grammar/domain/grammar_providers.dart';
import '../widgets/grammar_header.dart';
import '../widgets/grammar_filters.dart';
import '../widgets/grammar_topic_list.dart';

/// The main entry point for the Grammar section.
///
/// Responsibilities:
/// - Acts as a coordinator, laying out the major visual components:
///   Header, Filters, and Topic List.
/// - Watches the `groupedGrammarTopicsProvider` to feed data into the list.
/// - Handles high-level loading and error states for the grammar data source.
class GrammarScreen extends ConsumerStatefulWidget {
  const GrammarScreen({
    super.key,
    this.initialLevel = 'Alle',
    this.initialCategory = 'Alle',
    this.initialShowFilters = false,
  });

  /// The level tab to select upon opening the screen.
  final String initialLevel;

  /// The category to select upon opening the screen.
  final String initialCategory;

  /// Whether the filter categories section should start expanded outward.
  final bool initialShowFilters;

  @override
  ConsumerState<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends ConsumerState<GrammarScreen> {
  @override
  void initState() {
    super.initState();
    // Use microtask to set initial provider states after widget initialization
    Future.microtask(() {
      // NOTE: We do not reset the view providers on init if they are already active
      // so if they click "Back" from a topic detail, they don't lose their place.
      // But if we have specific routing arguments, we apply them.
      ref.read(selectedGrammarLevelProvider.notifier).state =
          widget.initialLevel;
      ref.read(selectedGrammarCategoryProvider.notifier).state =
          widget.initialCategory;
      // We don't overwrite showFilters here globally, but we could if required.
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final groupedAsync = ref.watch(groupedGrammarTopicsProvider);

    return Scaffold(
      backgroundColor: AppTokens.background(isDark),
      body: Stack(
        children: [
          // Premium background
          Positioned.fill(child: AppTokens.meshBackground(isDark)),
          
          SafeArea(
            child: groupedAsync.when(
              data: (grouped) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GrammarHeader(),
                      const SizedBox(height: 16),
                      const GrammarFilters(),
                      const SizedBox(height: 16),
                      GrammarTopicList(groupedTopics: grouped),
                    ],
                  ),
                );
              },
              loading: () => const AppStateView.loading(
                title: 'Loading grammar',
                message: 'The topics are being synchronized.',
              ),
              error: (e, s) => AppStateView.error(
                message: 'The grammar could not be loaded.\n$e',
                onAction: () => ref.invalidate(groupedGrammarTopicsProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



