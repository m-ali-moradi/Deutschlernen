import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deutschmate_mobile/app/deutschmate_app.dart';

void main() {
  testWidgets('app renders shell smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DeutschMateApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(DeutschMateApp), findsOneWidget);
  });
}
