import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../database/app_database.dart';
import '../../database/database_providers.dart';
import '../content_loader.dart';
import '../../../features/grammar/data/models/grammar_detail_models.dart';

/// A repository responsible for handling the localization strategy of Grammar content.
/// It merges the base English representation with translations originating from
/// either offline Assets (e.g. Dari) or the local database (cloud extensions).
class GrammarLocalizationRepository {
  final Ref _ref;

  GrammarLocalizationRepository(this._ref);

  /// Fetches a map of translations for all topics from standard offline assets.
  Future<Map<String, dynamic>> _getAssetTopicTranslations(String languageCode) async {
    final Map<String, dynamic> assetTransMap = {};
    if (!['en', 'fa'].contains(languageCode)) return assetTransMap;

    try {
      final raw = await ContentLoader.loadAllLevels(
        'grammar/$languageCode',
        ['topics_a1', 'topics_a2', 'topics_b1', 'topics_b2', 'topics_c1'],
      );
      for (var item in raw) {
        if (item['id'] != null) {
          assetTransMap[item['id']] = item;
        }
      }
    } catch (e) {
      // Ignored if file doesn't exist
    }
    return assetTransMap;
  }

  /// Mixes the base English Grammar Topics with translations based on active language.
  Future<List<GrammarTopic>> getLocalizedTopics(
      List<GrammarTopic> baseTopics, String languageCode) async {
    if (languageCode == 'en') return baseTopics;

    final db = _ref.read(appDatabaseProvider);
    final dbTranslations = await (db.select(db.grammarDetails)
          ..where((t) => t.languageCode.equals(languageCode)))
        .get();
    
    final dbTransMap = {for (var t in dbTranslations) t.topicId: t};
    final assetTransMap = await _getAssetTopicTranslations(languageCode);

    return baseTopics.map((base) {
      if (dbTransMap.containsKey(base.id)) {
        final trans = dbTransMap[base.id]!;
        return base.copyWith(
          title: trans.title ?? base.title,
          rule: trans.rule ?? base.rule,
          explanation: trans.explanation ?? base.explanation,
          examplesJson: trans.examplesJson ?? base.examplesJson,
          category: trans.category ?? base.category,
        );
      } else if (assetTransMap.containsKey(base.id)) {
        final trans = assetTransMap[base.id]!;
        return base.copyWith(
          title: trans['title'] as String? ?? base.title,
          rule: trans['rule'] as String? ?? base.rule,
          explanation: trans['explanation'] as String? ?? base.explanation,
          examplesJson: trans['examples_json'] as String? ?? base.examplesJson,
          category: trans['category'] as String? ?? base.category,
        );
      }
      return base;
    }).toList();
  }

  /// Fetches the detail payload for a specific grammar topic.
  /// Falls back to English if the translation does not exist.
  Future<GrammarDetailData?> getDetailTopic(String topicId, String baseLevel, String languageCode) async {
    final db = _ref.read(appDatabaseProvider);
    
    // 1. Check local database for cached translations/extensions
    final dbEntry = await (db.select(db.grammarDetails)
          ..where((t) =>
              t.topicId.equals(topicId) & t.languageCode.equals(languageCode)))
        .getSingleOrNull();

    if (dbEntry != null && dbEntry.detailJson != null) {
      try {
         final Map<String, dynamic> jsonMap = jsonDecode(dbEntry.detailJson!);
         return GrammarDetailData.fromJson(jsonMap);
      } catch (e) {
         // Silently fall through on JSON parse error
      }
    }

    final levelLower = baseLevel.toLowerCase();

    // 2. Fall back to offline assets for the requested language
    if (['en', 'fa'].contains(languageCode)) {
      try {
        final map = await ContentLoader.loadMap('assets/content/grammar/$languageCode/detail_$levelLower.json');
        if (map.containsKey(topicId)) {
          final rawItem = Map<String, dynamic>.from(map[topicId]);
          return GrammarDetailData.fromJson(rawItem);
        }
      } catch (e) {
        // If native asset is missing or corrupted, continue to English fallback
      }
    }

    // 3. Last resort fallback strictly to English Assets (as base)
    // This step is only needed if the requested language is not English
    // and the topic was not found in the localized assets or DB.
    if (languageCode != 'en') {
      try {
        final map = await ContentLoader.loadMap('assets/content/grammar/en/detail_$levelLower.json');
        if (map.containsKey(topicId)) {
          final rawItem = Map<String, dynamic>.from(map[topicId]);
          return GrammarDetailData.fromJson(rawItem);
        }
      } catch (e) {
        // Nothing left
      }
    }

    return null;
  }
}

final grammarLocalizationRepositoryProvider = Provider((ref) {
  return GrammarLocalizationRepository(ref);
});
