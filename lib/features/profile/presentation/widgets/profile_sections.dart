import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
import './profile_widgets.dart';

/// The header section of the profile page.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.strings,
    required this.textPrimary,
    required this.textMuted,
    required this.isDark,
    this.onLoginTap,
  });

  final AppUiText strings;
  final Color textPrimary;
  final Color textMuted;
  final bool isDark;
  final VoidCallback? onLoginTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.either(german: 'Profil', english: 'Profile'),
                style: AppTokens.headingStyle(context, isDark),
              ),
              const SizedBox(height: 1),
              Text(
                strings.either(
                  german: 'Deine Lernübersicht',
                  english: 'Your learning overview',
                ),
                style: AppTokens.subheadingStyle(context, isDark),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF334155), const Color(0xFF1E293B)]
                    : [Colors.white, const Color(0xFFF1F5F9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              size: 20,
              color: textPrimary.withValues(alpha: 0.9),
            ),
          ),
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onSelected: (value) {
            if (value == 'login') {
              onLoginTap?.call();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'login',
              child: Row(
                children: [
                  const Icon(Icons.login_rounded,
                      size: 20, color: Color(0xFF10B981)),
                  const SizedBox(width: 12),
                  Text(
                    strings.either(german: 'Anmelden', english: 'Login'),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The hero card showing level, XP, and progress.
class ProfileHeroCard extends StatelessWidget {
  const ProfileHeroCard({
    super.key,
    required this.strings,
    required this.level,
    required this.xp,
    required this.grammarDone,
    required this.weeklyProgress,
  });

  final AppUiText strings;
  final String level;
  final int xp;
  final int grammarDone;
  final int weeklyProgress;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(22),
      gradient: LinearGradient(
        colors: AppTokens.gradientIndigoPurplePink,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(30),
      shadowOpacity: 0.15,
      child: Column(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Premium Progress Ring
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ShaderMask(
                    shaderCallback: (rect) => const SweepGradient(
                      colors: [Colors.white, Colors.white70],
                      stops: [0.0, 1.0],
                    ).createShader(rect),
                    child: CircularProgressIndicator(
                      value: weeklyProgress / 100,
                      strokeWidth: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          level,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          strings.either(german: 'Level', english: 'Level'),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.9),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            strings.either(german: 'Dein Profil', english: 'Your Profile'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            strings.either(
              german: '$weeklyProgress% Wochenfortschritt',
              english: '$weeklyProgress% weekly progress',
            ),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassStat(
                label: 'XP',
                value: '$xp',
                icon: Icons.auto_awesome_rounded,
              ),
              const SizedBox(width: 14),
              GlassStat(
                label: strings.either(german: 'Grammatik', english: 'Grammar'),
                value: '$grammarDone',
                icon: Icons.menu_book_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The grid of overall statistics.
class StatisticsGrid extends StatelessWidget {
  const StatisticsGrid({
    super.key,
    required this.strings,
    required this.textPrimary,
    required this.isDark,
    required this.wordsLearned,
    required this.exercisesDone,
    required this.weakAreasCount,
  });

  final AppUiText strings;
  final Color textPrimary;
  final bool isDark;
  final int wordsLearned;
  final int exercisesDone;
  final int weakAreasCount;

  @override
  Widget build(BuildContext context) {
    final statCards = [
      (
        label: strings.either(german: 'Wörter', english: 'Words'),
        value: '$wordsLearned',
        icon: Icons.auto_awesome_rounded,
        bg: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
        fg: isDark ? const Color(0xFF818CF8) : const Color(0xFF4338CA),
      ),
      (
        label: strings.either(german: 'Übungen', english: 'Exercises'),
        value: '$exercisesDone',
        icon: Icons.rocket_launch_rounded,
        bg: isDark ? const Color(0xFF1C1917) : const Color(0xFFFFF7ED),
        fg: isDark ? const Color(0xFFFB923C) : const Color(0xFFC2410C),
      ),
      (
        label: strings.either(german: 'Schwächen', english: 'Weak areas'),
        value: '$weakAreasCount',
        icon: Icons.bolt_rounded,
        bg: isDark ? const Color(0xFF1C1917) : const Color(0xFFFEFCE8),
        fg: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.either(german: 'Statistiken', english: 'Statistics'),
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
                child: CompactStatCard(
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
      ],
    );
  }
}

/// The list of weak areas.
class WeakAreasList extends StatelessWidget {
  const WeakAreasList({
    super.key,
    required this.strings,
    required this.textPrimary,
    required this.textMuted,
    required this.cardColor,
    required this.isDark,
    required this.weakAreas,
    required this.onAreaTap,
  });

  final AppUiText strings;
  final Color textPrimary;
  final Color textMuted;
  final Color cardColor;
  final bool isDark;
  final List<String> weakAreas;
  final Function(String) onAreaTap;

  @override
  Widget build(BuildContext context) {
    if (weakAreas.isEmpty) return const SizedBox.shrink();

    return ProfileSectionCard(
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 18, color: textPrimary),
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
                onTap: () => onAreaTap(area),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: AppTokens.surface(isDark).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTokens.stateWarningForeground(isDark)
                          .withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTokens.stateWarningSurface(isDark),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.bolt_rounded,
                            size: 18,
                            color: AppTokens.stateWarningForeground(isDark),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              area,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              strings.either(
                                  german: 'Fokus benötigt',
                                  english: 'Focus needed'),
                              style: TextStyle(
                                fontSize: 11,
                                color: textMuted,
                              ),
                            ),
                          ],
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The settings section with toggles and dropdowns.
class SettingsSection extends ConsumerWidget {
  const SettingsSection({
    super.key,
    required this.strings,
    required this.textPrimary,
    required this.textMuted,
    required this.cardColor,
    required this.isDark,
    required this.darkMode,
    required this.displayLanguage,
    required this.nativeLanguage,
    required this.onReset,
  });

  final AppUiText strings;
  final Color textPrimary;
  final Color textMuted;
  final Color cardColor;
  final bool isDark;
  final bool darkMode;
  final String displayLanguage;
  final String nativeLanguage;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(appSettingsActionsProvider);

    return ProfileSectionCard(
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.either(german: 'Einstellungen', english: 'Settings'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _SettingToggle(
            icon: darkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            iconColor:
                darkMode ? const Color(0xFF818CF8) : const Color(0xFFF59E0B),
            label: darkMode
                ? strings.either(german: 'Dunkelmodus', english: 'Dark mode')
                : strings.either(german: 'Hellmodus', english: 'Light mode'),
            value: darkMode,
            onChanged: (val) => actions.setDarkMode(val),
            textPrimary: textPrimary,
          ),
          _Divider(isDark: isDark),
          _SettingDropdown(
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF3B82F6),
            label: strings.either(
              german: 'Anzeigesprache',
              english: 'Display language',
            ),
            value: displayLanguage,
            items: const {'en': 'English', 'de': 'Deutsch'},
            isDark: isDark,
            onChanged: (val) => actions.setDisplayLanguage(val),
            textPrimary: textPrimary,
          ),
          _Divider(isDark: isDark),
          _SettingDropdown(
            icon: Icons.translate_rounded,
            iconColor: const Color(0xFFA855F7),
            label: strings.either(
              german: 'Muttersprache',
              english: 'Native language',
            ),
            value: nativeLanguage,
            items: const {'en': 'English', 'dari': 'دری (Dari)'},
            isDark: isDark,
            onChanged: (val) => actions.setNativeLanguage(val),
            textPrimary: textPrimary,
          ),
          _Divider(isDark: isDark),
          _SettingAction(
            icon: Icons.refresh_rounded,
            iconColor: AppTokens.stateDangerForeground(isDark),
            label: strings.either(
              german: 'Fortschritt zurücksetzen',
              english: 'Reset Progress',
            ),
            onTap: onReset,
            textPrimary: textPrimary,
          ),
        ],
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  const _SettingToggle({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.textPrimary,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final bool value;
  final Function(bool) onChanged;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 14, color: textPrimary),
                  ),
                ],
              ),
            ),
            ProfileCustomSwitch(value: value, activeColor: iconColor),
          ],
        ),
      ),
    );
  }
}

class _SettingAction extends StatelessWidget {
  const _SettingAction({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    required this.textPrimary,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: iconColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: iconColor.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingDropdown extends StatelessWidget {
  const _SettingDropdown({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.items,
    required this.isDark,
    required this.onChanged,
    required this.textPrimary,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Map<String, String> items;
  final bool isDark;
  final Function(String) onChanged;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child:
                Text(label, style: TextStyle(fontSize: 14, color: textPrimary)),
          ),
          ProfileDropdownSelect(
            value: value,
            items: items,
            isDark: isDark,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: AppTokens.outline(isDark),
    );
  }
}

/// The support section with contact links.
class SupportSection extends StatelessWidget {
  const SupportSection({
    super.key,
    required this.strings,
    required this.textPrimary,
    required this.textMuted,
    required this.cardColor,
    required this.isDark,
    required this.onSupport,
  });

  final AppUiText strings;
  final Color textPrimary;
  final Color textMuted;
  final Color cardColor;
  final bool isDark;
  final Function(String) onSupport;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.either(german: 'Support', english: 'Support'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          SupportTile(
            icon: Icons.mail_outline_rounded,
            title: strings.either(german: 'Kontakt', english: 'Contact Us'),
            textPrimary: textPrimary,
            textMuted: textMuted,
            onTap: () => onSupport('Contact'),
          ),
          _Divider(isDark: isDark),
          SupportTile(
            icon: Icons.bug_report_outlined,
            title: strings.either(
              german: 'Problem melden',
              english: 'Report a Problem',
            ),
            textPrimary: textPrimary,
            textMuted: textMuted,
            onTap: () => onSupport('Problem Report'),
          ),
          _Divider(isDark: isDark),
          SupportTile(
            icon: Icons.help_outline_rounded,
            title: strings.either(german: 'FAQ', english: 'FAQ'),
            textPrimary: textPrimary,
            textMuted: textMuted,
            onTap: () => onSupport('FAQ Question'),
          ),
        ],
      ),
    );
  }
}

/// The footer section with version info and reset button.
class ProfileFooter extends StatelessWidget {
  const ProfileFooter({
    super.key,
    required this.strings,
    required this.textMuted,
  });

  final AppUiText strings;
  final Color textMuted;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/icon.png'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            strings.either(
              german: 'DeutschMate v1.0',
              english: 'DeutschMate v1.0',
            ),
            style: TextStyle(fontSize: 12, color: textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            strings.either(
              german: 'Dein smarter DeutschMate',
              english: 'Your smart DeutschMate',
            ),
            style: TextStyle(
              fontSize: 11,
              color: textMuted.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
