import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import 'dashboard_logic.dart';
import '../data/models/learning_path_models.dart';

/// Provider for the overall learning path and dashboard state.
final learningPathProvider = Provider<AsyncValue<LearningPathState>>((ref) {
  // We need the raw data for buildDashboardSummary
  // In a real app we might use specialized providers for these
  // Using the dashboardSummaryProvider as a source of aggregate data for now
  final summaryAsync = ref.watch(dashboardSummaryProvider);

  return summaryAsync.when(
    data: (summary) {
      final nextAction = buildDashboardNextAction(summary);
      return AsyncValue.data(LearningPathState(
        summary: summary,
        nextAction: nextAction,
      ));
    },
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );
});
