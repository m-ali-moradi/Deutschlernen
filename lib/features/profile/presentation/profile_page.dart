import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/content/sync/connectivity_service.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/content/sync/sync_state.dart';
import '../../learning_path/data/models/weak_area_models.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_state_view.dart';
import '../../../shared/localization/app_ui_text.dart';

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
    context.go(resolveWeakAreaRoute(area).route);
  }

  Future<void> _handleSupport(String subject) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'alimoradi20252@gmail.com',
      query: 'subject=${Uri.encodeComponent("Deutschlernen App - $subject")}',
    );

    try {
      if (!await launchUrl(emailLaunchUri)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open email app.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app.')),
        );
      }
    }
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
            final xp = stats.xp;
            final wordsLearned = summary.wordsLearned;
            final exercisesDone = summary.exerciseAttemptCount;
            final grammarDone = summary.grammarCompletedCount;
            final weeklyProgress = summary.weeklyProgress;
            final level = stats.level;
            final weakAreas = summary.weakAreas;
            final displayLanguageValue =
                prefs.displayLanguage == 'de' ? 'de' : 'en';

            final statCards = [
              (
                label: strings.either(german: 'Wörter', english: 'Words'),
                value: '$wordsLearned',
                icon: '📚',
                bg: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF),
                fg: const Color(0xFF2563EB)
              ),
              (
                label: strings.either(german: 'Übungen', english: 'Exercises'),
                value: '$exercisesDone',
                icon: '🎯',
                bg: isDark ? const Color(0xFF052E16) : const Color(0xFFF0FDF4),
                fg: const Color(0xFF16A34A)
              ),
              (
                label:
                    strings.either(german: 'Schwächen', english: 'Weak areas'),
                value: '${weakAreas.length}',
                icon: '⚠️',
                bg: isDark ? const Color(0xFF1C1A09) : const Color(0xFFFEFCE8),
                fg: const Color(0xFFD97706)
              ),
            ];

            return Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _BackButton(
                          isDark: isDark,
                          onTap: () => context.go('/'),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.either(
                                  german: 'Profil', english: 'Profile'),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              strings.either(
                                german: 'Deine Lernübersicht',
                                english: 'Your learning overview',
                              ),
                              style: TextStyle(fontSize: 12, color: textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3B82F6),
                            Color(0xFFA855F7),
                            Color(0xFFEC4899),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFFA855F7).withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: CircularProgressIndicator(
                                    value: weeklyProgress / 100,
                                    strokeWidth: 8,
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.25),
                                    valueColor: const AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      level,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      strings.either(
                                          german: 'Level', english: 'Level'),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color:
                                            Colors.white.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            strings.either(
                                german: 'Lernprofil',
                                english: 'Learning profile'),
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            strings.either(
                              german: '$weeklyProgress% Wochenfortschritt',
                              english: '$weeklyProgress% weekly progress',
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _GlassStat(label: 'XP', value: '$xp'),
                              const SizedBox(width: 12),
                              _GlassStat(
                                label: strings.either(
                                    german: 'Grammatik', english: 'Grammar'),
                                value: '$grammarDone',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      strings.either(
                          german: 'Statistiken', english: 'Statistics'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: statCards.map((stat) {
                        final isLast = statCards.last == stat;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: isLast ? 0 : 12),
                            child: _CompactStatCard(
                              label: stat.label,
                              value: stat.value,
                              icon: stat.icon,
                              bg: stat.bg,
                              fg: stat.fg,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (weakAreas.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _SectionCard(
                        cardColor: cardColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '⚠️',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  strings.either(
                                    german: 'Schwache Bereiche',
                                    english: 'Weak areas',
                                  ),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...weakAreas.map(
                              (area) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: GestureDetector(
                                  onTap: () => _openWeakArea(area),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 11,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1C1A09)
                                          : const Color(0xFFFEFCE8),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? const Color(0xFF422006)
                                                : const Color(0xFFFEF3C7),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '📘',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            area,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isDark
                                                  ? const Color(0xFFFCD34D)
                                                  : const Color(0xFF92400E),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 16,
                                          color: isDark
                                              ? const Color(0xFFFCD34D)
                                              : const Color(0xFFD97706),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _SectionCard(
                      cardColor: cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.either(
                                german: 'Einstellungen', english: 'Settings'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => ref
                                .read(appSettingsActionsProvider)
                                .setDarkMode(!prefs.darkMode),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    prefs.darkMode
                                        ? Icons.dark_mode_rounded
                                        : Icons.light_mode_rounded,
                                    size: 20,
                                    color: prefs.darkMode
                                        ? const Color(0xFF818CF8)
                                        : const Color(0xFFF59E0B),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      prefs.darkMode
                                          ? strings.either(
                                              german: 'Dunkelmodus',
                                              english: 'Dark mode')
                                          : strings.either(
                                              german: 'Hellmodus',
                                              english: 'Light mode'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: textPrimary,
                                      ),
                                    ),
                                  ),
                                  _CustomSwitch(
                                    value: prefs.darkMode,
                                    activeColor: const Color(0xFF6366F1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                          ),
                          GestureDetector(
                            onTap: () => ref
                                .read(appSettingsActionsProvider)
                                .setAutoSync(!prefs.autoSync),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.sync_rounded,
                                    size: 20,
                                    color: Color(0xFF10B981),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          strings.either(
                                            german: 'Auto-Synchronisierung',
                                            english: 'Auto-Sync Content',
                                          ),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: textPrimary,
                                          ),
                                        ),
                                        Text(
                                          strings.either(
                                            german: 'Inhalte automatisch laden',
                                            english:
                                                'Fetch updates automatically',
                                          ),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _CustomSwitch(
                                    value: prefs.autoSync,
                                    activeColor: const Color(0xFF10B981),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!prefs.autoSync) ...[
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 32),
                              child: TextButton.icon(
                                onPressed: () {
                                  final isOnline = ref
                                          .read(connectivityProvider)
                                          .valueOrNull ??
                                      false;
                                  if (!isOnline) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(strings.offlineMessage()),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                    return;
                                  }

                                  ref
                                      .read(syncStateProvider.notifier)
                                      .triggerManualSync();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(strings.either(
                                        german: 'Synchronisierung gestartet...',
                                        english: 'Syncing started...',
                                      )),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon:
                                    const Icon(Icons.refresh_rounded, size: 16),
                                label: Text(strings.either(
                                  german: 'Jetzt synchronisieren',
                                  english: 'Sync Now',
                                )),
                                style: TextButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  foregroundColor: const Color(0xFF10B981),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                ),
                              ),
                            ),
                          ],
                          Divider(
                            height: 1,
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.language_rounded,
                                  size: 20,
                                  color: Color(0xFF3B82F6),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    strings.either(
                                      german: 'Anzeigesprache',
                                      english: 'Display language',
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                                _DropdownSelect(
                                  value: displayLanguageValue,
                                  items: const {
                                    'en': 'English',
                                    'de': 'Deutsch',
                                  },
                                  isDark: isDark,
                                  onChanged: (value) => ref
                                      .read(appSettingsActionsProvider)
                                      .setDisplayLanguage(value),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.translate_rounded,
                                  size: 20,
                                  color: Color(0xFFA855F7),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    strings.either(
                                      german: 'Muttersprache',
                                      english: 'Native language',
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                                _DropdownSelect(
                                  value: prefs.nativeLanguage,
                                  items: const {
                                    'en': 'English',
                                    'dari': 'دری (Dari)',
                                  },
                                  isDark: isDark,
                                  onChanged: (value) => ref
                                      .read(appSettingsActionsProvider)
                                      .setNativeLanguage(value),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      cardColor: cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.either(
                                german: 'Support', english: 'Support'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _SupportTile(
                            icon: Icons.mail_outline_rounded,
                            title: strings.either(
                                german: 'Kontakt', english: 'Contact Us'),
                            textPrimary: textPrimary,
                            textMuted: textMuted,
                            onTap: () => _handleSupport('Contact'),
                          ),
                          Divider(
                            height: 1,
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                          ),
                          _SupportTile(
                            icon: Icons.bug_report_outlined,
                            title: strings.either(
                                german: 'Problem melden',
                                english: 'Report a Problem'),
                            textPrimary: textPrimary,
                            textMuted: textMuted,
                            onTap: () => _handleSupport('Problem Report'),
                          ),
                          Divider(
                            height: 1,
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                          ),
                          _SupportTile(
                            icon: Icons.help_outline_rounded,
                            title:
                                strings.either(german: 'FAQ', english: 'FAQ'),
                            textPrimary: textPrimary,
                            textMuted: textMuted,
                            onTap: () => _handleSupport('FAQ Question'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          TextButton.icon(
                            onPressed: () => _handleResetProgress(strings),
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: Text(strings.either(
                                german: 'Fortschritt zurücksetzen',
                                english: 'Reset Progress')),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Colors.red.withValues(alpha: 0.8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            strings.either(
                              german: 'Deutsch Lernen App v1.0',
                              english: 'Deutsch Lernen App v1.0',
                            ),
                            style: TextStyle(fontSize: 12, color: textMuted),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            strings.either(
                              german: 'Für fokussiertes Deutschlernen gemacht',
                              english: 'Made for focused German learning',
                            ),
                            style: TextStyle(
                              fontSize: 11,
                              color: textMuted.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
          loading: () => const Scaffold(
            body: AppStateView.loading(
              title: 'Loading settings',
              message: 'Please wait a moment.',
            ),
          ),
          error: (e, s) => Scaffold(
            body: AppStateView.error(
              message: 'The settings could not be loaded.\n$e',
              onAction: () => ref.invalidate(userPreferencesStreamProvider),
            ),
          ),
        ),
        loading: () => const Scaffold(
          body: AppStateView.loading(
            title: 'Loading overview',
            message: 'Learning statistics are being prepared.',
          ),
        ),
        error: (e, s) => Scaffold(
          body: AppStateView.error(
            message: 'The learning overview could not be loaded.\n$e',
            onAction: () => ref.invalidate(dashboardSummaryProvider),
          ),
        ),
      ),
      loading: () => const Scaffold(
        body: AppStateView.loading(
          title: 'Loading profile',
          message: 'Current learning values are being retrieved.',
        ),
      ),
      error: (e, s) => Scaffold(
        body: AppStateView.error(
          message: 'The profile could not be loaded.\n$e',
          onAction: () => ref.invalidate(userStatsStreamProvider),
        ),
      ),
    );
  }
}

/// This button allows users to go back to the previous page.
class _BackButton extends StatelessWidget {
  const _BackButton({required this.isDark, required this.onTap});

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF374151),
          ),
        ),
      );
}

/// This widget shows a single statistic with a semi-transparent "glass" look.
class _GlassStat extends StatelessWidget {
  const _GlassStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: 10, color: Colors.white.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
}

/// This card is used to group related settings or information.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.cardColor, required this.child});

  final Color cardColor;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );
}

/// This card shows a summary of a specific learning metric.
class _CompactStatCard extends StatelessWidget {
  const _CompactStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.bg,
    required this.fg,
  });

  final String label;
  final String value;
  final String icon;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: fg.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ],
        ),
      );
}

/// This tile shows a support option with an icon and label.
class _SupportTile extends StatelessWidget {
  const _SupportTile({
    required this.icon,
    required this.title,
    required this.textPrimary,
    required this.textMuted,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color textPrimary;
  final Color textMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF3B82F6)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14, color: textPrimary),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: textMuted,
              ),
            ],
          ),
        ),
      );
}

/// This widget allows users to select an option from a list.
class _DropdownSelect extends StatelessWidget {
  const _DropdownSelect({
    required this.value,
    required this.items,
    required this.isDark,
    required this.onChanged,
  });

  final String value;
  final Map<String, String> items;
  final bool isDark;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final fg = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF374151);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.containsKey(value) ? value : items.keys.first,
          isDense: true,
          style: TextStyle(fontSize: 13, color: fg),
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          items: items.entries
              .map(
                (entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                ),
              )
              .toList(),
          onChanged: (nextValue) {
            if (nextValue != null) {
              onChanged(nextValue);
            }
          },
        ),
      ),
    );
  }
}

/// A custom switch widget that matches the app's design system.
class _CustomSwitch extends StatelessWidget {
  const _CustomSwitch({required this.value, required this.activeColor});

  final bool value;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 28,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: value ? activeColor : const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
