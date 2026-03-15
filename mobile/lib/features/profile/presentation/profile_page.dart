import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/progress_ring.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String _language = 'en';

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(userStatsStreamProvider);
    final prefs = ref.watch(userPreferencesStreamProvider);
    final achievements = ref.watch(achievementsStreamProvider);

    if (stats.isLoading || prefs.isLoading || achievements.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (stats.hasError || prefs.hasError || achievements.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 44),
              const SizedBox(height: 10),
              const Text('Failed to load profile data'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  ref.invalidate(userStatsStreamProvider);
                  ref.invalidate(userPreferencesStreamProvider);
                  ref.invalidate(achievementsStreamProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final userStats = stats.value!;
    final userPrefs = prefs.value!;
    final achievementList = achievements.value!;
    final unlocked = achievementList.where((a) => a.unlocked).length;
    final weakAreas = (jsonDecode(userStats.weakAreasJson) as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.go('/'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profil',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: isDark
                                      ? AppTokens.darkText
                                      : AppTokens.lightText,
                                ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Deine Lernstatistik',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppTokens.darkTextMuted
                                  : AppTokens.lightTextMuted,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _LevelCard(stats: userStats),
            const SizedBox(height: 18),
            Text(
              'Statistiken',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark ? AppTokens.darkText : AppTokens.lightText,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              children: [
                _StatTile(
                  label: 'XP Punkte',
                  value: '${userStats.xp}',
                  icon: Icons.bolt_rounded,
                  color: const Color(0xFFF59E0B),
                ),
                _StatTile(
                  label: 'Streak',
                  value: '${userStats.streak} Tage',
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFF97316),
                ),
                _StatTile(
                  label: 'Wörter',
                  value: '${userStats.wordsLearned}',
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFF3B82F6),
                ),
                _StatTile(
                  label: 'Übungen',
                  value: '${userStats.exercisesCompleted}',
                  icon: Icons.track_changes_rounded,
                  color: const Color(0xFF22C55E),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (weakAreas.isNotEmpty)
              _WeakAreasCard(
                areas: weakAreas,
                onOpen: () => context.go('/grammar'),
              ),
            const SizedBox(height: 18),
            _AchievementsCard(
              achievements: achievementList,
              unlockedCount: unlocked,
            ),
            const SizedBox(height: 18),
            _SettingsCard(
              darkMode: userPrefs.darkMode,
              onToggleDarkMode: (value) => ref
                  .read(appSettingsActionsProvider)
                  .setDarkMode(value),
              language: _language,
              onLanguageChanged: (value) =>
                  setState(() => _language = value),
              nativeLanguage: userPrefs.nativeLanguage,
              onNativeLanguageChanged: (value) => ref
                  .read(appSettingsActionsProvider)
                  .setNativeLanguage(value),
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Text(
                    'Deutsch Lernen App v1.0',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppTokens.darkTextMuted
                              : AppTokens.lightTextMuted,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Made with ❤️ for German learners',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? const Color(0xFF475569)
                              : const Color(0xFFCBD5F5),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.stats});

  final UserStat stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppTokens.radius30,
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFFA855F7), Color(0xFFEC4899)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA855F7).withValues(alpha: 0.3),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ProgressRing(
            progress: stats.weeklyProgress.toDouble(),
            size: 110,
            strokeWidth: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stats.level,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Level',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Deutsch Lerner',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${stats.weeklyProgress}% Wochenfortschritt',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MiniStat(label: 'XP', value: '${stats.xp}'),
              const SizedBox(width: 8),
              _MiniStat(label: 'Streak', value: '${stats.streak} 🔥'),
              const SizedBox(width: 8),
              _MiniStat(
                  label: 'Grammatik',
                  value: '${stats.grammarTopicsCompleted}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: AppTokens.radius20,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? color.withValues(alpha: 0.2) : color.withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppTokens.radius24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isDark
                      ? AppTokens.darkTextMuted
                      : AppTokens.lightTextMuted,
                ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark ? AppTokens.darkText : AppTokens.lightText,
                ),
          ),
        ],
      ),
    );
  }
}

class _WeakAreasCard extends StatelessWidget {
  const _WeakAreasCard({required this.areas, required this.onOpen});

  final List<String> areas;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTokens.darkCard : AppTokens.lightCard,
        borderRadius: AppTokens.radius30,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 18, color: Color(0xFFF59E0B)),
              const SizedBox(width: 6),
              Text(
                'Schwache Bereiche',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? AppTokens.darkText
                          : AppTokens.lightText,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final area in areas)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: onOpen,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF3F2D0C)
                        : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE68A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text('📘', style: TextStyle(fontSize: 14)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          area,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? const Color(0xFFFCD34D)
                                    : const Color(0xFFB45309),
                              ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          size: 16, color: Color(0xFFF59E0B)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AchievementsCard extends StatelessWidget {
  const _AchievementsCard({
    required this.achievements,
    required this.unlockedCount,
  });

  final List<Achievement> achievements;
  final int unlockedCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTokens.darkCard : AppTokens.lightCard,
        borderRadius: AppTokens.radius30,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events_rounded,
                  size: 18, color: Color(0xFFF59E0B)),
              const SizedBox(width: 6),
              Text(
                'Erfolge',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? AppTokens.darkText
                          : AppTokens.lightText,
                    ),
              ),
              const Spacer(),
              Text(
                '$unlockedCount/${achievements.length}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppTokens.darkTextMuted
                          : AppTokens.lightTextMuted,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final achievement in achievements)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: achievement.unlocked
                      ? const Color(0xFFFFFBEB)
                      : (isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9)),
                  borderRadius: AppTokens.radius24,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: achievement.unlocked
                            ? const Color(0xFFFDE68A)
                            : (isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0)),
                      ),
                      alignment: Alignment.center,
                      child: Text(achievement.icon,
                          style: const TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? AppTokens.darkText
                                      : AppTokens.lightText,
                                ),
                          ),
                          Text(
                            achievement.description,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: isDark
                                      ? AppTokens.darkTextMuted
                                      : AppTokens.lightTextMuted,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (achievement.unlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Fertig',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.darkMode,
    required this.onToggleDarkMode,
    required this.language,
    required this.onLanguageChanged,
    required this.nativeLanguage,
    required this.onNativeLanguageChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onToggleDarkMode;
  final String language;
  final ValueChanged<String> onLanguageChanged;
  final String nativeLanguage;
  final ValueChanged<String> onNativeLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTokens.darkCard : AppTokens.lightCard,
        borderRadius: AppTokens.radius30,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Einstellungen',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark ? AppTokens.darkText : AppTokens.lightText,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                darkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: darkMode ? const Color(0xFF818CF8) : const Color(0xFFF59E0B),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  darkMode ? 'Dark Mode' : 'Light Mode',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              _ToggleSwitch(
                enabled: darkMode,
                onChanged: onToggleDarkMode,
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.language_rounded, color: Color(0xFF3B82F6)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sprache',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              _DropdownPill(
                value: language,
                onChanged: onLanguageChanged,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                  DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
                  DropdownMenuItem(value: 'ar', child: Text('العربية')),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.translate_rounded, color: Color(0xFFA855F7)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Muttersprache',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              _DropdownPill(
                value: nativeLanguage,
                onChanged: onNativeLanguageChanged,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'dari', child: Text('دری (Dari)')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DropdownPill extends StatelessWidget {
  const _DropdownPill({
    required this.value,
    required this.onChanged,
    required this.items,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final List<DropdownMenuItem<String>> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items,
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppTokens.darkText : AppTokens.lightText,
              ),
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        ),
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!enabled),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF6366F1) : const Color(0xFFCBD5F5),
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      borderRadius: AppTokens.radius16,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppTokens.radius16,
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: AppTokens.radius16,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
