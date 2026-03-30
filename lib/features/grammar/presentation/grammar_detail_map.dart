import 'package:deutschmate_mobile/core/content/content_assets.dart';
import 'package:deutschmate_mobile/core/content/content_loader.dart';
import '../data/models/grammar_detail_models.dart';

/// This map holds the grammar data for the rich detail views.
final Map<String, GrammarDetailData> grammarDetailMap = {};

/// This service loads detailed grammar information from the modular JSON files.
///
/// Each grammar file now contains both topic metadata and its detail in one
/// combined JSON object: `{ id, title, level, ..., "detail": { ... } }`.
class GrammarDetailService {
  static final Map<String, GrammarDetailData> _cache = {};

  static Future<GrammarDetailData?> loadDetail(
      String topicId, String level) async {
    if (_cache.containsKey(topicId)) {
      return _cache[topicId];
    }

    // Search through grammar assets to find the matching topic
    final allGrammar = await ContentLoader.loadMany(ContentAssets.grammar);
    for (final entry in allGrammar) {
      final id = (entry['id'] ?? '').toString();
      if (id == topicId && entry.containsKey('detail')) {
        final rawDetail = Map<String, dynamic>.from(entry['detail'] as Map);
        final data = GrammarDetailData.fromJson(rawDetail);
        _cache[topicId] = data;
        return data;
      }
    }

    return null;
  }
}

Future<void> preloadGrammarDetailMap() async {
  final allGrammar = await ContentLoader.loadMany(ContentAssets.grammar);

  for (final entry in allGrammar) {
    final id = (entry['id'] ?? '').toString();
    if (id.isEmpty || !entry.containsKey('detail')) continue;

    try {
      final rawDetail = Map<String, dynamic>.from(entry['detail'] as Map);
      grammarDetailMap[id] = GrammarDetailData.fromJson(rawDetail);
    } catch (e) {
      // Skip topics whose details cannot be parsed
    }
  }
}
