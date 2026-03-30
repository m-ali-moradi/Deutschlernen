import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SelectionArea is present and works in a simple app', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SelectionArea(
          child: Scaffold(
            body: Text('Selectable Text'),
          ),
        ),
      ),
    );

    expect(find.byType(SelectionArea), findsOneWidget);
    expect(find.text('Selectable Text'), findsOneWidget);
    
    // Check if the text is indeed inside the SelectionArea
    final selectionArea = tester.widget<SelectionArea>(find.byType(SelectionArea));
    expect(selectionArea.child, isNotNull);
  });
}
