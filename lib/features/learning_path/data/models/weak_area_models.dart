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
  final encoded = Uri.encodeComponent(area);
  return WeakAreaRoute(
    area: area,
    route: '/exercises?topic=$encoded',
  );
}
