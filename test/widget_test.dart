import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Flutter widget tree can be rendered', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Presensi Mobile'))),
    );

    expect(find.text('Presensi Mobile'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
