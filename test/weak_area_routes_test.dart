import 'package:deutschlernen_mobile/features/learning_path/data/models/weak_area_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolveWeakAreaRoute sends exact topics to the right study area', () {
    expect(
      resolveWeakAreaRoute('Konjunktiv').route,
      '/grammar?category=Konjunktiv&showFilters=1',
    );

    expect(
      resolveWeakAreaRoute('Büro Kommunikation').route,
      '/vocabulary?category=B%C3%BCro%20Kommunikation&tab=words',
    );

    expect(
      resolveWeakAreaRoute('business').route,
      '/vocabulary?category=Bewerbung%20%26%20Karriere&tab=words',
    );

    expect(resolveWeakAreaRoute('unknown topic').route, '/grammar');
  });
}
