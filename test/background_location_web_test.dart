@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/service/background_location_service.dart';
import 'package:presensi_mobile/service/startup_gate.dart';

void main() {
  testWidgets('web bootstrap does not wait for native raster feedback', (
    tester,
  ) async {
    await tester.pumpWidget(
      StartupGate(
        initialize: () async => const MaterialApp(home: Text('Web ready')),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Web ready'), findsOneWidget);
  });
  test(
    'web checkout/logout never invokes unsupported native background service',
    () async {
      await BackgroundLocationService.initialize();
      await BackgroundLocationService.start(
        baseUrl: 'http://localhost:8086/graphql',
        token: 'qa-test-token',
      );
      await BackgroundLocationService.stop();
      expect(await BackgroundLocationService.ensureTrackingPermission(), false);
    },
  );
}
