import 'dashboard_logic.dart';
import '../../../core/database/app_database.dart';

class ContinueLearningItem {
  const ContinueLearningItem({
    required this.sectionKey,
    required this.sectionLabel,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final String sectionKey;
  final String sectionLabel;
  final String title;
  final String subtitle;
  final String route;
}

List<ContinueLearningItem> buildContinueLearningItems({
  required List<GrammarTopic>? grammarTopics,
  required List<VocabularyWord>? vocabularyWords,
  required dynamic vocabularyReviewState,
  required List<Exercise>? exercises,
  required DashboardSummary? dashboardSummary,
}) {
  final items = <ContinueLearningItem>[];

  // Logic to build suggestions based on state...
  
  if (dashboardSummary != null && dashboardSummary.vocabularyDueCount > 0) {
    items.add(const ContinueLearningItem(
      sectionKey: 'vocabulary',
      sectionLabel: 'Vokabeln',
      title: 'Wiederholen',
      subtitle: 'Zeit für eine Review-Session',
      route: '/vocabulary?tab=words',
    ));
  }

  if (items.isEmpty) {
    items.add(const ContinueLearningItem(
      sectionKey: 'grammar',
      sectionLabel: 'Grammatik',
      title: 'Erste Schritte',
      subtitle: 'Lerne die Grundlagen der Grammatik',
      route: '/grammar',
    ));
  }

  return items;
}
