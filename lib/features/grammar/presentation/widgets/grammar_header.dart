import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/localization/app_ui_text.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/content/sync/sync_state.dart';
import '../../../../core/content/sync/connectivity_service.dart';
import '../../../../core/database/database_providers.dart';
import '../../domain/grammar_view_providers.dart';
import 'grammar_widgets.dart'; // Provides GrammarIconButton
import '../../../../shared/widgets/sync_app_bar_widget.dart';

/// The top navigation bar for the Grammar section.
///
/// Responsibilities:
/// - Provides a back button to exit the grammar section.
/// - Displays the section title and subtitle.
/// - Hosts the Sync button.
/// - Hosts the filter toggle, updating the Riverpod state.
class GrammarHeader extends ConsumerWidget {
  const GrammarHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppUiText(ref.watch(displayLanguageProvider));
    final syncState = ref.watch(syncStateProvider);

    final showFilters = ref.watch(grammarShowFiltersProvider);

    return Row(
      children: [
        GrammarIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: () => context.go('/'),
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.translate(
                  de: 'Grammatik 📘',
                  en: 'Grammar 📘',
                  fa: 'دستور زبان 📘',
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: isDark ? AppTokens.darkText : AppTokens.lightText),
              ),
              const SizedBox(height: 2),
              Text(
                strings.translate(
                  de: 'Regeln & Struktur',
                  en: 'Rules & structure',
                  fa: 'قواعد و ساختار',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppTokens.darkTextMuted
                        : AppTokens.lightTextMuted),
              ),
            ],
          ),
        ),

        // Sync action
        SyncAppBarWidget(
          state: syncState,
          onSyncPressed: () {
            final isOnline =
                ref.read(connectivityProvider).valueOrNull ?? false;
            if (!isOnline) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(strings.offlineMessage()),
                  duration: const Duration(seconds: 2),
                ),
              );
              return;
            }
            ref.read(syncStateProvider.notifier).triggerManualSync();
          },
        ),

        // Filter toggle
        GrammarIconButton(
          icon: Icons.filter_alt_rounded,
          onPressed: () {
            ref.read(grammarShowFiltersProvider.notifier).state = !showFilters;
          },
          isDark: isDark,
          active: showFilters,
        ),
      ],
    );
  }
}
