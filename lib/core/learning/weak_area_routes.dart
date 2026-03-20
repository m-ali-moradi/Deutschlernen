/// Represents a navigation path to help the user with a specific topic.
class WeakAreaRoute {
  const WeakAreaRoute({required this.route});

  /// The URL or route name.
  final String route;
}

/// Finds the best page to help the user improve in a topic where they made mistakes.
///
/// It can redirect to the Grammar list, Vocabulary list, or a specific Exercise.
WeakAreaRoute resolveWeakAreaRoute(String topic) {
  final normalized = _normalize(topic);

  if (_containsAny(normalized, const [
    'grammar',
    'grammatik',
    'artikel',
    'satzbau',
    'satzarten',
    'substantive',
    'pronomen',
    'adjektive',
    'adverbien',
    'konjugation',
    'konjunktiv',
    'passiv',
    'indirekte rede',
    'nebensätze',
    'nebensaetze',
    'präpositionen',
    'praepositionen',
    'partikeln',
  ])) {
    return const WeakAreaRoute(route: '/grammar');
  }

  if (_containsAny(normalized, const [
    'vocabulary',
    'wortschatz',
    'vokabel',
    'vokabeln',
    'alltag',
    'beruf',
    'business',
    'büro',
    'buero',
    'kommunikation',
    'essen',
    'reisen',
    'gesundheit',
    'technik',
    'freizeit',
    'wohnung',
  ])) {
    return const WeakAreaRoute(route: '/vocabulary?tab=words');
  }

  // Assuming the topic is an exact Grammar Title (since we filtered the dashboard)
  return WeakAreaRoute(
    route: '/exercises?topic=${Uri.encodeComponent(topic)}',
  );
}

String _normalize(String value) =>
    value.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

bool _containsAny(String value, List<String> needles) {
  for (final needle in needles) {
    if (value.contains(needle)) {
      return true;
    }
  }
  return false;
}
