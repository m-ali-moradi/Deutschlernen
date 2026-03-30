import 'package:deutschmate_mobile/core/content/content_assets.dart';
import 'package:deutschmate_mobile/core/content/content_loader.dart';

/// This class represents a single grammar topic as a data object.
class GrammarTopicView {
  const GrammarTopicView({
    required this.id,
    required this.title,
    required this.level,
    required this.category,
    required this.icon,
    required this.rule,
    required this.explanation,
    required this.examples,
    required this.progress,
  });

  final String id;
  final String title;
  final String level;
  final String category;
  final String icon;
  final String rule;
  final String explanation;
  final List<String> examples;
  final int progress;

  factory GrammarTopicView.fromJson(Map<String, dynamic> json) {
    return GrammarTopicView(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      level: (json['level'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      icon: (json['icon'] ?? '').toString(),
      rule: (json['rule'] ?? '').toString(),
      explanation: (json['explanation'] ?? '').toString(),
      examples: (json['examples'] as List<dynamic>? ?? const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      progress: (json['progress'] as num?)?.toInt() ?? 0,
    );
  }
}

/// This service helps to load grammar topics from JSON files.
class GrammarContentService {
  static List<GrammarTopicView>? _cache;

  static Future<List<GrammarTopicView>> loadAllTopics() async {
    if (_cache != null) {
      return _cache!;
    }

    final data = await ContentLoader.loadMany(ContentAssets.grammar);
    final all = data.map(GrammarTopicView.fromJson).toList();
    _cache = all;
    return all;
  }
}

/// This list holds the initial grammar topics loaded from files.
List<GrammarTopicView> grammarTopicsSeed = const [];
Map<String, int> grammarTopicSortRanks = const {};

Future<void> preloadGrammarTopicsSeed() async {
  grammarTopicsSeed = await GrammarContentService.loadAllTopics();
  grammarTopicSortRanks = {
    for (var index = 0; index < grammarTopicsSeed.length; index++)
      grammarTopicsSeed[index].id: index,
  };
}

int grammarTopicSortRank(String topicId) =>
    grammarTopicSortRanks[topicId] ?? 1 << 30;

const grammarLevels = ['Alle', 'A1', 'A2', 'B1', 'B2', 'C1'];

const grammarCategories = [
  'Alle',
  'Artikel',
  'Satzbau',
  'Fälle',
  'Pronomen',
  'Zeiten',
  'Verben',
  'Präpositionen',
  'Adjektive',
  'Nebensätze',
  'Konjunktiv',
  'Partikeln',
];
