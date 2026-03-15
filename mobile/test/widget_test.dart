import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deutschlernen_mobile/app/deutschlernen_app.dart';

void main() {
  testWidgets('app renders shell smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DeutschLernenApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.textContaining('Lerne Deutsch'), findsOneWidget);
  });
}
