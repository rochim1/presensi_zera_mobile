import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/service/startup_gate.dart';

void main() {
  testWidgets('native work waits for the actual first rasterized frame', (
    tester,
  ) async {
    final firstFrame = Completer<void>();
    var calls = 0;
    await tester.pumpWidget(
      StartupGate(
        firstFrame: firstFrame.future,
        initialize: () async {
          calls++;
          return const MaterialApp(home: Text('Ready'));
        },
      ),
    );
    await tester.pump(const Duration(seconds: 5));
    expect(calls, 0);
    expect(find.text('Menyiapkan Zera…'), findsOneWidget);
    firstFrame.complete();
    await tester.pump();
    await tester.pump();
    expect(calls, 1);
    expect(find.text('Ready'), findsOneWidget);
  });
  testWidgets('renders before initialization and initializes only once', (
    tester,
  ) async {
    final ready = Completer<Widget>();
    var calls = 0;
    await tester.pumpWidget(
      StartupGate(
        firstFrame: Future<void>.value(),
        initialize: () {
          calls++;
          return ready.future;
        },
      ),
    );
    expect(find.text('Menyiapkan Zera…'), findsOneWidget);
    await tester.pump();
    expect(calls, 1);
    await tester.pump(const Duration(seconds: 10));
    expect(find.text('Menyiapkan Zera…'), findsOneWidget);
    expect(find.byType(MaterialApp), findsNothing);
    expect(find.byType(Navigator), findsNothing);
    ready.complete(const MaterialApp(home: Text('Ready')));
    await tester.pump();
    await tester.pump();
    expect(find.text('Ready'), findsOneWidget);
    expect(calls, 1);
  });

  testWidgets('does not update a disposed startup gate', (tester) async {
    final ready = Completer<Widget>();
    await tester.pumpWidget(
      StartupGate(
        firstFrame: Future<void>.value(),
        initialize: () => ready.future,
      ),
    );
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    ready.complete(const Text('Late'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Late'), findsNothing);
  });

  testWidgets('initialization failure gives recovery instructions', (
    tester,
  ) async {
    await tester.pumpWidget(
      StartupGate(
        firstFrame: Future<void>.value(),
        initialize: () async => throw StateError('test'),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('Tutup lalu buka kembali'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
