import '../../../core/content/content_loader.dart';
import '../data/models/grammar_detail_models.dart';
import 'grammar_seed.dart';

/// This map holds the grammar data for the rich detail views.
final Map<String, GrammarDetailData> grammarDetailMap = {};

/// This service loads detailed grammar information from JSON files.
class GrammarDetailService {
  static final Map<String, GrammarDetailData> _cache = {};

  static Future<GrammarDetailData?> loadDetail(
      String topicId, String level) async {
    if (_cache.containsKey(topicId)) {
      return _cache[topicId];
    }

    final map = await ContentLoader.loadMap(
      'assets/content/grammar/en/detail_${level.toLowerCase()}.json',
    );

    if (!map.containsKey(topicId)) {
      return null;
    }

    final raw = (map[topicId] as Map).map(
      (key, value) => MapEntry(key.toString(), value),
    );
    final data = GrammarDetailData.fromJson(raw);
    _cache[topicId] = data;
    return data;
  }
}

Future<void> preloadGrammarDetailMap() async {
  final levelByTopic = <String, String>{
    for (final t in grammarTopicsSeed) t.id: t.level,
  };

  for (final entry in levelByTopic.entries) {
    final level = entry.value.toLowerCase();
    if (level != 'a1' &&
        level != 'a2' &&
        level != 'b1' &&
        level != 'b2' &&
        level != 'c1') {
      continue;
    }

    try {
      final detail =
          await GrammarDetailService.loadDetail(entry.key, entry.value);
      if (detail != null) {
        grammarDetailMap[entry.key] = detail;
      }
    } catch (e) {
      // Skip topics whose details cannot be loaded
    }
  }
}
