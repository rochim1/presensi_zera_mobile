import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/presentation/attendance_navigation.dart';
import 'package:presensi_mobile/presentation/interaction_gate.dart';

void main() {
  for (final replace in [false, true]) {
    testWidgets('Attendance unlocks after cancel (replace: $replace)', (
      tester,
    ) async {
      final router = RootStackRouter.build(
        routes: [
          NamedRouteDef(
            name: 'Home',
            path: '/',
            builder: (_, __) => const Scaffold(body: Text('Home')),
          ),
          NamedRouteDef(
            name: 'Attendance',
            path: '/attendance',
            builder: (_, __) => const Scaffold(body: Text('Attendance')),
          ),
        ],
      );
      final gate = InteractionGate();
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router.config()),
      );
      await tester.pumpAndSettle();
      expect(gate.tryAcquire(), isTrue);
      final navigation = pushAttendanceWithGate(
        router,
        const PageRouteInfo('Attendance'),
        gate,
      );
      expect(gate.value, isTrue);
      expect(gate.tryAcquire(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text('Attendance'), findsOneWidget);
      expect(gate.value, isFalse);
      if (replace) {
        router.replace(const PageRouteInfo('Attendance'));
        await tester.pumpAndSettle();
      }
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(gate.tryAcquire(), isTrue);
      final retry = pushAttendanceWithGate(
        router,
        const PageRouteInfo('Attendance'),
        gate,
      );
      await tester.pumpAndSettle();
      expect(find.text('Attendance'), findsOneWidget);
      expect(gate.value, isFalse);
      router.pop();
      await tester.pumpAndSettle();
      await retry;
      if (!replace) await navigation;
      await tester.pumpWidget(const SizedBox());
      router.dispose();
      gate.dispose();
    });
  }
}
