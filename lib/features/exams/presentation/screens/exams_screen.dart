import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschmate_mobile/core/theme/app_tokens.dart';
import 'package:deutschmate_mobile/shared/widgets/app_icon_button.dart';
import 'package:deutschmate_mobile/shared/widgets/premium_card.dart';
import 'package:deutschmate_mobile/shared/localization/app_ui_text.dart';
import 'package:deutschmate_mobile/features/exams/data/exams_repository.dart';
import 'package:deutschmate_mobile/features/exams/domain/models/exam_models.dart';

class ExamsScreen extends ConsumerStatefulWidget {
  const ExamsScreen({super.key});

  @override
  ConsumerState<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends ConsumerState<ExamsScreen> {
  String _selectedProvider = 'All';
  String _selectedLevel = 'All';

  @override
  Widget build(BuildContext context) {
    final examsAsync = ref.watch(allExamsProvider);
    final strings = ref.watch(appUiTextProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: AppTokens.meshBackground(isDark)),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(context, isDark, strings),
                Expanded(
                  child: examsAsync.when(
                    data: (exams) {
                      var filteredExams = exams;

                      // Filter by Provider
                      if (_selectedProvider != 'All') {
                        filteredExams = filteredExams
                            .where((e) => e.provider
                                .toLowerCase()
                                .contains(_selectedProvider.toLowerCase()))
                            .toList();
                      }

                      // Filter by Level
                      if (_selectedLevel != 'All') {
                        filteredExams = filteredExams
                            .where((e) =>
                                e.level.toUpperCase() ==
                                _selectedLevel.toUpperCase())
                            .toList();
                      }

                      if (filteredExams.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: AppTokens.textMuted(isDark)
                                    .withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Keine Prüfungen gefunden',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTokens.textMuted(isDark),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Versuchen Sie einen anderen Filter',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTokens.textMuted(isDark)
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        itemCount: filteredExams.length,
                        itemBuilder: (context, index) {
                          return _ExamCard(
                              exam: filteredExams[index],
                              isDark: isDark,
                              strings: strings);
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                color: Colors.red, size: 48),
                            const SizedBox(height: 16),
                            Text('Ladefehler: $err',
                                textAlign: TextAlign.center),
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, AppUiText strings) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.examsSectionTitle(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: AppTokens.textPrimary(isDark),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.examsSubtitle(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTokens.textMuted(isDark),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFilterBar(
            items: ['All', 'Goethe', 'Telc', 'ÖSD'],
            labels: [strings.filterAll(), 'Goethe', 'Telc', 'ÖSD'],
            selected: _selectedProvider,
            onChanged: (val) => setState(() => _selectedProvider = val),
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildFilterBar(
            items: ['All', 'A1', 'A2', 'B1', 'B2'],
            labels: [strings.filterAll(), 'A1', 'A2', 'B1', 'B2'],
            selected: _selectedLevel,
            onChanged: (val) => setState(() => _selectedLevel = val),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar({
    required List<String> items,
    required List<String> labels,
    required String selected,
    required ValueChanged<String> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppTokens.outline(isDark).withValues(alpha: 0.1)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final label = labels[index];
          return Expanded(
            child: _FilterChip(
              label: label,
              isSelected: selected == item,
              onTap: () => onChanged(item),
              isDark: isDark,
            ),
          );
        }),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(colors: AppTokens.gradientBluePurple)
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTokens.gradientBluePurple.first
                          .withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTokens.textMuted(isDark),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final ExamInfo exam;
  final bool isDark;
  final AppUiText strings;

  const _ExamCard(
      {required this.exam, required this.isDark, required this.strings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: PremiumCard(
        onTap: () => context.push('/practice/exams/${exam.id}', extra: exam),
        padding: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildLevelIcon(exam.level, isDark),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.provider.toUpperCase(),
                        style: TextStyle(
                          color: AppTokens.primary(isDark),
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        exam.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppTokens.textPrimary(isDark),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTokens.textMuted(isDark),
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              exam.description,
              style: TextStyle(
                color: AppTokens.textMuted(isDark),
                fontSize: 14,
                height: 1.4,
              ).copyWith(fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoBadge(
                    Icons.timer_outlined,
                    strings.unitMinutes(exam.structure
                        .fold<int>(0, (sum, m) => sum + m.durationMinutes)),
                    isDark),
                const SizedBox(width: 12),
                _buildInfoBadge(
                    Icons.layers_outlined,
                    strings.unitModules(
                        exam.structure.where((m) => !m.isBreak).length),
                    isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelIcon(String level, bool isDark) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTokens.primary(isDark),
            AppTokens.primary(isDark).withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppTokens.primary(isDark).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        level,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppTokens.outline(isDark).withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTokens.textMuted(isDark)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTokens.textMuted(isDark),
            ),
          ),
        ],
      ),
    );
  }
}



