import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/features/learning_path/data/models/weak_area_models.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/widgets/app_state_view.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'widgets/profile_sections.dart';

/// This page shows the user's statistics and settings.
///
/// It displays earned achievements, XP progress, and allows resetting the app.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  void _openWeakArea(String area) {
    final route = resolveWeakAreaRoute(area).route;
    context.push(route);
  }

  void _handleSupport(String subject) {
    // Logic for handling support links (e.g., mailto)
    // Note: In a real app, this would use url_launcher
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Support for $subject requested.')),
    );
  }

  Future<void> _handleResetProgress(AppUiText strings) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.either(
            german: 'Fortschritt zurücksetzen?', english: 'Reset progress?')),
        content: Text(strings.either(
          german:
              'Dies löscht all deine XP, Grammatik-Fortschritte und Vokabel-Statistiken. Dies kann nicht rückgängig gemacht werden.',
          english:
              'This will erase all your XP, grammar progress, and vocabulary stats. This cannot be undone.',
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.either(german: 'Abbrechen', english: 'Cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child:
                Text(strings.either(german: 'Zurücksetzen', english: 'Reset')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(appSettingsActionsProvider).resetAllUserProgress();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(strings.either(
                  german: 'Fortschritt zurückgesetzt.',
                  english: 'Progress reset.'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = AppTokens.textPrimary(isDark);
    final textMuted = AppTokens.textMuted(isDark);
    final cardColor = AppTokens.surface(isDark);
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    final statsAsync = ref.watch(userStatsStreamProvider);
    final prefsAsync = ref.watch(userPreferencesStreamProvider);
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return statsAsync.when(
      data: (stats) => summaryAsync.when(
        data: (summary) => prefsAsync.when(
          data: (prefs) {
            return Scaffold(
              backgroundColor: AppTokens.background(isDark),
              body: Stack(
                children: [
                  // Premium Mesh Background
                  AppTokens.meshBackground(isDark),

                  SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileHeader(
                            strings: strings,
                            textPrimary: textPrimary,
                            textMuted: textMuted,
                            isDark: isDark,
                            onLoginTap: () => _handleSupport('Login Feature'),
                          ),
                          const SizedBox(height: 24),
                          ProfileHeroCard(
                            strings: strings,
                            level: stats.level,
                            xp: stats.xp,
                            grammarDone: summary.grammarCompletedCount,
                            weeklyProgress: summary.weeklyProgress,
                          ),
                          const SizedBox(height: 24),
                          StatisticsGrid(
                            strings: strings,
                            textPrimary: textPrimary,
                            isDark: isDark,
                            wordsLearned: summary.wordsLearned,
                            exercisesDone: summary.exerciseAttemptCount,
                            weakAreasCount: summary.weakAreas.length,
                          ),
                          const SizedBox(height: 24),
                          WeakAreasList(
                            strings: strings,
                            textPrimary: textPrimary,
                            textMuted: textMuted,
                            cardColor: cardColor,
                            isDark: isDark,
                            weakAreas: summary.weakAreas,
                            onAreaTap: _openWeakArea,
                          ),
                          const SizedBox(height: 20),
                          SettingsSection(
                            strings: strings,
                            textPrimary: textPrimary,
                            textMuted: textMuted,
                            cardColor: cardColor,
                            isDark: isDark,
                            darkMode: prefs.darkMode,
                            displayLanguage: prefs.displayLanguage,
                            nativeLanguage: prefs.nativeLanguage,
                            onReset: () => _handleResetProgress(strings),
                          ),
                          const SizedBox(height: 20),
                          SupportSection(
                            strings: strings,
                            textPrimary: textPrimary,
                            textMuted: textMuted,
                            cardColor: cardColor,
                            isDark: isDark,
                            onSupport: _handleSupport,
                          ),
                          const SizedBox(height: 24),
                          ProfileFooter(
                            strings: strings,
                            textMuted: textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Scaffold(
            body: SafeArea(
              child: AppStateView.loading(
                title: 'Loading settings',
                message: 'Please wait a moment.',
              ),
            ),
          ),
          error: (e, s) => Scaffold(
            body: SafeArea(
              child: AppStateView.error(
                message: 'The settings could not be loaded.\n$e',
                onAction: () => ref.invalidate(userPreferencesStreamProvider),
              ),
            ),
          ),
        ),
        loading: () => const Scaffold(
          body: SafeArea(
            child: AppStateView.loading(
              title: 'Loading overview',
              message: 'Learning statistics are being prepared.',
            ),
          ),
        ),
        error: (e, s) => Scaffold(
          body: SafeArea(
            child: AppStateView.error(
              message: 'The learning overview could not be loaded.\n$e',
              onAction: () => ref.invalidate(dashboardSummaryProvider),
            ),
          ),
        ),
      ),
      loading: () => const Scaffold(
        body: SafeArea(
          child: AppStateView.loading(
            title: 'Loading profile',
            message: 'Current learning values are being retrieved.',
          ),
        ),
      ),
      error: (e, s) => Scaffold(
        body: SafeArea(
          child: AppStateView.error(
            message: 'The profile could not be loaded.\n$e',
            onAction: () => ref.invalidate(userStatsStreamProvider),
          ),
        ),
      ),
    );
  }
}
