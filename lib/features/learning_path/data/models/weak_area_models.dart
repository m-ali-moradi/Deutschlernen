/// A suggested route for improving a weak grammar area.
class WeakAreaRoute {
  const WeakAreaRoute({
    required this.area,
    required this.route,
  });

  final String area;
  final String route;
}

/// Resolves a grammar topic title to a screen path.
WeakAreaRoute resolveWeakAreaRoute(String area) {
  final vocabularyCategory = _vocabularyCategoryForArea(area);
  if (vocabularyCategory != null) {
    return WeakAreaRoute(
      area: area,
      route:
          '/vocabulary?category=${Uri.encodeComponent(vocabularyCategory)}&tab=words',
    );
  }

  final trimmed = area.trim();
  if (trimmed.isEmpty) {
    return const WeakAreaRoute(area: '', route: '/grammar');
  }

  if (!_looksLikeGrammarArea(trimmed)) {
    return WeakAreaRoute(area: area, route: '/grammar');
  }

  final encoded = Uri.encodeComponent(trimmed);
  return WeakAreaRoute(
    area: area,
    route: '/grammar?category=$encoded&showFilters=1',
  );
}

bool _looksLikeGrammarArea(String area) {
  final normalized = area
      .toLowerCase()
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('ß', 'ss');

  const grammarKeywords = <String>{
    'artikel',
    'plural',
    'satzbau',
    'negation',
    'pronomen',
    'possessiv',
    'praesens',
    'praeteritum',
    'perfekt',
    'plusquamperfekt',
    'futur',
    'modalverben',
    'trennbar',
    'imperativ',
    'adjektiv',
    'akkusativ',
    'dativ',
    'genitiv',
    'praeposition',
    'wechselpraeposition',
    'relativ',
    'nebensatz',
    'konjunktiv',
    'passiv',
    'adverb',
    'konnektor',
    'wortbildung',
    'n deklination',
    'indirekte rede',
  };

  return grammarKeywords.any(normalized.contains);
}

String? _vocabularyCategoryForArea(String area) {
  final normalized = area
      .toLowerCase()
      .trim()
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('ß', 'ss')
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ');

  return switch (normalized) {
    'buro kommunikation' => 'email_communication',
    'buero kommunikation' => 'email_communication',
    'email kommunikation' => 'email_communication',
    'business' => 'application',
    'bewerbung' => 'application',
    'application career' => 'application',
    'meetings' => 'meetings',
    'meeting' => 'meetings',
    'human resources' => 'hr',
    'marketing sales' => 'marketing',
    _ => null,
  };
}



