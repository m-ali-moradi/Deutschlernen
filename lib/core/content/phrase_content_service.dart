import 'package:flutter/foundation.dart';

import 'content_loader.dart';

/// This record stores a single phrase with its translations and a tag.
typedef PhraseRecord = ({
  String german,
  String english,
  String dari,
  String tag
});

/// This service handles the loading and caching of useful German phrases.
class PhraseContentService {
  static List<PhraseRecord> _cache = const [];

  /// This getter returns the list of loaded business phrases.
  static List<PhraseRecord> get businessPhrases => _cache;

  /// This function loads the phrases from the assets folder into memory.
  static Future<void> preload() async {
    if (_cache.isNotEmpty) {
      return;
    }

    final data =
        await ContentLoader.loadList('assets/content/phrases/business.json');
    _cache = data
        .map(
          (row) => (
            german: (row['german'] ?? '').toString(),
            english: (row['english'] ?? '').toString(),
            dari: (row['dari'] ?? '').toString(),
            tag: (row['tag'] ?? '').toString(),
          ),
        )
        .toList(growable: false);

    if (kDebugMode && _cache.isEmpty) {
      throw StateError(
          'No phrases loaded from assets/content/phrases/business.json');
    }
  }
}
