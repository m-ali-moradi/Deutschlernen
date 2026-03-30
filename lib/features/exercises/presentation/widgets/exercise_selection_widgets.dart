import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import 'package:deutschmate_mobile/features/learning_path/data/models/weak_area_models.dart';
import 'package:deutschmate_mobile/features/exercises/data/models/exercise_type.dart';
import 'package:deutschmate_mobile/features/exercises/domain/exercise_providers.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/shared/widgets/app_icon_button.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';

/// widget to display the exercise selection view
class ExerciseSelectionView extends ConsumerWidget {
  const ExerciseSelectionView({
    super.key,
    required this.onStartExercise,
    required this.autoStart,
    this.initialTopic,
    this.initialCategory,
  });

  final Future<void> Function(String type) onStartExercise;
  final bool autoStart;
  final String? initialTopic;
  final String? initialCategory;

  /// widget to build the exercise selection view
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = AppTokens.textPrimary(isDark);
    final textMuted = AppTokens.textMuted(isDark);
    final cardColor = AppTokens.surface(isDark);

    final selectedLevel = ref.watch(exerciseLevelProvider);
    final filteredExercises = ref.watch(filteredExercisesProvider);
    final typeProgressMap = ref.watch(exerciseTypeProgressProvider);
    final weakAreas = ref.watch(exerciseWeakAreasProvider);
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: AppTokens.meshBackground(isDark)),
          SafeArea(
            bottom: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(
                      context, isDark, textPrimary, textMuted, strings, ref),
                  const SizedBox(height: 18),
                  // Level filter chips
                  _LevelChips(
                    selectedLevel: selectedLevel,
                    onLevelSelected: (lvl) =>
                        ref.read(exerciseLevelProvider.notifier).state = lvl,
                    isDark: isDark,
                    cardColor: cardColor,
                    textMuted: textMuted,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    strings.exerciseTypesTitle(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: textPrimary),
                  ),
                  const SizedBox(height: 12),
                  // Exercise type cards
                  ...exerciseTypes.map((et) {
                    final count = et.type == 'all'
                        ? filteredExercises.length
                        : filteredExercises
                            .where((e) => e.type == et.type)
                            .length;

                    return ExerciseTypeCard(
                      typeInfo: et,
                      count: count,
                      completedCount: typeProgressMap[et.type]?.completed ?? 0,
                      onTap: () => onStartExercise(et.type),
                      strings: strings,
                    );
                  }),
                  if (weakAreas.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    WeakAreasCard(
                      weakAreas: weakAreas,
                      isDark: isDark,
                      cardColor: cardColor,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                      strings: strings,
                      onTopicTap: (topic) {
                        final route = resolveWeakAreaRoute(topic).route;
                        context.push(route);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// widget to build the header
  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textMuted,
    AppUiText strings,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          _SelectionBackButton(onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          }),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.either(german: 'Übungen', english: 'Exercises'),
                  style: AppTokens.headingStyle(context, isDark),
                ),
                Text(
                  strings.either(
                    german: 'Wähle einen Übungstyp',
                    english: 'Choose an exercise type',
                  ),
                  style: AppTokens.subheadingStyle(context, isDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// widget to display the exercise type card
class ExerciseTypeCard extends StatelessWidget {
  const ExerciseTypeCard({
    super.key,
    required this.typeInfo,
    required this.count,
    required this.completedCount,
    required this.onTap,
    required this.strings,
  });

  /// widget to hold the exercise type info
  final ExerciseTypeInfo typeInfo;

  /// widget to hold the count
  final int count;

  /// widget to hold the completed count
  final int completedCount;

  /// widget to hold the tap callback
  final VoidCallback onTap;

  /// widget to hold the strings
  final AppUiText strings;

  /// widget to build the exercise type card
  @override
  Widget build(BuildContext context) {
    final progress =
        count == 0 ? 0.0 : (completedCount / count).clamp(0.0, 1.0);
    final progressPercent = (progress * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: PremiumCard(
        onTap: onTap,
        gradient: LinearGradient(
          colors: typeInfo.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        padding: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(typeInfo.icon, size: 28, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getExerciseTypeLabel(strings, typeInfo.type),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        strings.exerciseCompletedCount(completedCount, count),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$progressPercent%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

/// This widget displays the level chips to the user.
class _LevelChips extends StatelessWidget {
  const _LevelChips({
    required this.selectedLevel,
    required this.onLevelSelected,
    required this.isDark,
    required this.cardColor,
    required this.textMuted,
  });

  final String selectedLevel;
  final ValueChanged<String> onLevelSelected;
  final bool isDark;
  final Color cardColor;
  final Color textMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: exerciseLevels.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final lvl = exerciseLevels[index];
          final sel = lvl == selectedLevel;
          return PremiumCard(
            onTap: () => onLevelSelected(lvl),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            borderRadius: BorderRadius.circular(22),
            useGlass: !sel,
            gradient: sel
                ? const LinearGradient(
                    colors: AppTokens.gradientBluePurple,
                  )
                : null,
            child: Center(
              child: Text(
                lvl,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: sel ? Colors.white : textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// This widget displays the weak areas to the user.
class WeakAreasCard extends StatelessWidget {
  const WeakAreasCard({
    super.key,
    required this.weakAreas,
    required this.isDark,
    required this.cardColor,
    required this.textPrimary,
    required this.textMuted,
    required this.strings,
    required this.onTopicTap,
  });

  final List<String> weakAreas;
  final bool isDark;
  final Color cardColor;
  final Color textPrimary;
  final Color textMuted;
  final AppUiText strings;
  final ValueChanged<String> onTopicTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_graph_rounded,
                  color: isDark
                      ? const Color(0xFF10B981)
                      : const Color(0xFF059669),
                  size: 20),
              const SizedBox(width: 10),
              Text(
                strings.exerciseWeakAreasTitle(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            strings.exerciseWeakAreasHint(),
            style: TextStyle(
              fontSize: 13,
              color: textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: weakAreas.map((topic) {
              return InkWell(
                onTap: () => onTopicTap(topic),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    topic,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// This widget displays the back button to the user.
class _SelectionBackButton extends StatelessWidget {
  const _SelectionBackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: Icons.arrow_back_ios_new_rounded,
      iconSize: 16,
      onPressed: onTap,
    );
  }
}
