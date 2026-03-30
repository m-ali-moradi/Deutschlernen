import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:deutschmate_mobile/core/content/content_assets.dart';
import 'package:deutschmate_mobile/core/database/app_database.dart';
import 'package:deutschmate_mobile/core/database/database_providers.dart';
import '../content_loader.dart';
import 'package:deutschmate_mobile/features/grammar/data/models/grammar_detail_models.dart';

/// A repository responsible for handling the localization strategy of Grammar content.
/// It merges the base English representation with translations originating from
/// the local database (cloud extensions).
class GrammarLocalizationRepository {
  final Ref _ref;

  GrammarLocalizationRepository(this._ref);

  /// Mixes the base English Grammar Topics with translations based on active language.
  Future<List<GrammarTopic>> getLocalizedTopics(
      List<GrammarTopic> baseTopics, String languageCode) async {
    if (languageCode == 'en') return baseTopics;

    final db = _ref.read(appDatabaseProvider);
    final dbTranslations = await (db.select(db.grammarDetails)
          ..where((t) => t.languageCode.equals(languageCode)))
        .get();

    final dbTransMap = {for (var t in dbTranslations) t.topicId: t};

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
      }
      return base;
    }).toList();
  }

  /// Fetches the detail payload for a specific grammar topic.
  /// Falls back to the modular grammar asset files.
  Future<GrammarDetailData?> getDetailTopic(
      String topicId, String baseLevel, String languageCode) async {
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

    // 2. Fall back to modular grammar assets
    try {
      final allGrammar = await ContentLoader.loadMany(ContentAssets.grammar);
      for (final entry in allGrammar) {
        final id = (entry['id'] ?? '').toString();
        if (id == topicId && entry.containsKey('detail')) {
          final rawDetail = Map<String, dynamic>.from(entry['detail'] as Map);
          return GrammarDetailData.fromJson(rawDetail);
        }
      }
    } catch (e) {
      // Nothing left
    }

    return null;
  }
}

final grammarLocalizationRepositoryProvider = Provider((ref) {
  return GrammarLocalizationRepository(ref);
});
