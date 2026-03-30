import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/features/grammar/domain/grammar_view_providers.dart';
import 'grammar_widgets.dart'; // Provides GrammarIconButton

/// The top navigation bar for the Grammar section.
///
/// Responsibilities:
/// - Provides a back button to exit the grammar section.
/// - Displays the section title and subtitle.
/// - Hosts the filter toggle, updating the Riverpod state.
class GrammarHeader extends ConsumerWidget {
  const GrammarHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final showFilters = ref.watch(grammarShowFiltersProvider);

    return Row(
      children: [
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.translate(
                  de: 'Grammatik',
                  en: 'Grammar',
                  fa: 'دستور زبان',
                ),
                style: AppTokens.headingStyle(context, isDark),
              ),
              const SizedBox(height: 1),
              Text(
                strings.translate(
                  de: 'Regeln & Struktur',
                  en: 'Rules & structure',
                  fa: 'قواعد و ساختار',
                ),
                style: AppTokens.subheadingStyle(context, isDark),
              ),
            ],
          ),
        ),

        // Filter toggle
        GrammarIconButton(
          icon: Icons.filter_list_rounded,
          onPressed: () {
            ref.read(grammarShowFiltersProvider.notifier).state = !showFilters;
          },
          active: showFilters,
        ),
      ],
    );
  }
}



