import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profil', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text('Deine Lernstatistik',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3B82F6),
                    Color(0xFFA855F7),
                    Color(0xFFEC4899)
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(userStats.level,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w700)),
                  const Text('Level', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('${userStats.weeklyProgress}% Wochenfortschritt',
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child:
                            _MetricBox(label: 'XP', value: '${userStats.xp}'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MetricBox(
                            label: 'Streak', value: '${userStats.streak} 🔥'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MetricBox(
                            label: 'Grammatik',
                            value: '${userStats.grammarTopicsCompleted}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Statistiken', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.7,
              children: [
                _StatTile(label: 'XP Punkte', value: '${userStats.xp}'),
                _StatTile(label: 'Streak', value: '${userStats.streak} Tage'),
                _StatTile(label: 'Worter', value: '${userStats.wordsLearned}'),
                _StatTile(
                    label: 'Ubungen', value: '${userStats.exercisesCompleted}'),
              ],
            ),
            const SizedBox(height: 16),
            if (userStats.weakAreasJson != '[]')
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Schwache Bereiche',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(userStats.weakAreasJson),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Erfolge',
                            style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        Text('$unlocked/${achievementList.length}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final achievement in achievementList)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: achievement.unlocked
                                ? const Color(0xFFFEF9C3)
                                : const Color(0xFFF3F4F6),
                          ),
                          child: Row(
                            children: [
                              Text(achievement.icon,
                                  style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(achievement.title),
                                    Text(achievement.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant)),
                                  ],
                                ),
                              ),
                              if (achievement.unlocked)
                                const Text('Fertig',
                                    style: TextStyle(color: Colors.green)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Einstellungen',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Dark Mode'),
                      value: userPrefs.darkMode,
                      onChanged: (value) async {
                        await ref
                            .read(appSettingsActionsProvider)
                            .setDarkMode(value);
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(child: Text('Muttersprache')),
                        DropdownButton<String>(
                          value: userPrefs.nativeLanguage,
                          items: const [
                            DropdownMenuItem(
                                value: 'en', child: Text('English')),
                            DropdownMenuItem(
                                value: 'dari', child: Text('Dari')),
                          ],
                          onChanged: (value) async {
                            if (value == null) return;
                            await ref
                                .read(appSettingsActionsProvider)
                                .setNativeLanguage(value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
