import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/content/sync/connectivity_service.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/widgets/sync_app_bar_widget.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/content/sync/sync_state.dart';
import '../../../learning_path/data/models/weak_area_models.dart';
import '../../data/models/exercise_type.dart';
import '../../domain/exercise_providers.dart';
import '../../../../shared/localization/app_ui_text.dart';

class ExerciseSelectionView extends ConsumerWidget {
  const ExerciseSelectionView({
    super.key,
    required this.onStartExercise,
    required this.autoStart,
    this.initialTopic,
    this.initialCategory,
  });

  final Function(String type) onStartExercise;
  final bool autoStart;
  final String? initialTopic;
  final String? initialCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = AppTokens.textPrimary(isDark);
    final textMuted = AppTokens.textMuted(isDark);
    final cardColor = AppTokens.surface(isDark);

    final selectedLevel = ref.watch(exerciseLevelProvider);
    final filteredExercises = ref.watch(filteredExercisesProvider);
    final weakAreas = ref.watch(exerciseWeakAreasProvider);
    final syncState = ref.watch(syncStateProvider);
    final strings = AppUiText(ref.watch(displayLanguageProvider));

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, isDark, textPrimary, textMuted, strings,
                  syncState, ref),
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
                strings.either(
                    german: 'Übungstypen', english: 'Exercise types'),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textPrimary),
              ),
              const SizedBox(height: 12),
              // Exercise type cards
              ...exerciseTypes.map((et) {
                final count = et.type == 'all'
                    ? filteredExercises.length
                    : filteredExercises
                        .where((e) =>
                            (e.localData?.type ??
                                e.cloudMetadata?['type'] ??
                                '') ==
                            et.type)
                        .length;

                return ExerciseTypeCard(
                  typeInfo: et,
                  count: count,
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
                  onTopicTap: (topic) =>
                      context.go(resolveWeakAreaRoute(topic).route),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textMuted,
    AppUiText strings,
    SyncState syncState,
    WidgetRef ref,
  ) {
    return Row(children: [
      _SelectionBackButton(onTap: () => context.go('/')),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          strings.either(german: 'Übungen ✏️', english: 'Exercises ✏️'),
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary),
        ),
        Text(
          strings.either(german: 'Tests & Quiz', english: 'Tests & quizzes'),
          style: TextStyle(fontSize: 12, color: textMuted),
        ),
      ]),
      SyncAppBarWidget(
        state: syncState,
        onSyncPressed: () {
          final isOnline = ref.read(connectivityProvider).valueOrNull ?? false;
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
    ]);
  }
}

class ExerciseTypeCard extends StatelessWidget {
  const ExerciseTypeCard({
    super.key,
    required this.typeInfo,
    required this.count,
    required this.onTap,
    required this.strings,
  });

  final ExerciseTypeInfo typeInfo;
  final int count;
  final VoidCallback onTap;
  final AppUiText strings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: typeInfo.gradient),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: typeInfo.gradient.first.withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Row(children: [
            Text(typeInfo.icon, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    typeInfo.label,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    strings.either(
                      german: '$count Fragen verfügbar',
                      english: '$count questions available',
                    ),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.6), size: 22),
          ]),
        ),
      ),
    );
  }
}

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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: exerciseLevels.map((lvl) {
          final sel = lvl == selectedLevel;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onLevelSelected(lvl),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: sel
                      ? const LinearGradient(
                          colors: [Color(0xFFFB923C), Color(0xFFEA580C)])
                      : null,
                  color: sel ? null : cardColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: sel ? 0.15 : 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  lvl,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: sel ? Colors.white : textMuted,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

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
    return Container(
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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.either(
                german: 'Deine Schwachstellen', english: 'Your weak areas'),
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            strings.either(
              german: 'Tippe auf ein Thema, um direkt dort zu üben.',
              english: 'Tap a topic to practice it directly.',
            ),
            style: TextStyle(fontSize: 12, color: textMuted),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: weakAreas.map((topic) {
              return InkWell(
                onTap: () => onTopicTap(topic),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    topic,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimary),
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

class _SelectionBackButton extends StatelessWidget {
  const _SelectionBackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }
}
