import 'package:deutschmate_mobile/features/learning_path/domain/dashboard_logic.dart';
import 'package:deutschmate_mobile/features/learning_path/domain/dashboard_logic.dart'
    show DashboardSummary, DashboardNextAction;

class LearningPathState {
  const LearningPathState({
    required this.summary,
    required this.nextAction,
  });

  final DashboardSummary summary;
  final DashboardNextAction nextAction;
}



