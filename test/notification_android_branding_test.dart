import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/service/local_notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  final calls = <MethodCall>[];
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return null;
        });
  });
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test(
    'foreground and local notifications send the Pantoo icon to Android',
    () async {
      final service = LocalNotificationServiceImpl(
        FlutterLocalNotificationsPlugin(),
      );
      await service.showNotification(
        const RemoteMessage(
          notification: RemoteNotification(title: 'Pantoo HR', body: 'Test'),
        ),
      );
      await service.showLocalNotification(
        id: 2,
        title: 'Pantoo HR',
        body: 'Test',
      );
      final shown = calls.where((call) => call.method == 'show').toList();
      expect(shown, hasLength(2));
      for (final call in shown) {
        final settings = (call.arguments as Map)['platformSpecifics'] as Map;
        expect(settings['icon'], 'ic_notif');
        expect(settings['channelId'], 'pantoo');
        expect(settings['colorRed'], 0x08);
        expect(settings['colorGreen'], 0x7F);
        expect(settings['colorBlue'], 0x75);
      }
    },
  );

  test('FCM background defaults resolve to the same vector icon and channel', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    expect(
      manifest,
      matches(
        RegExp(
          r'default_notification_icon"\s+android:resource="@drawable/ic_notif"',
        ),
      ),
    );
    expect(
      manifest,
      matches(
        RegExp(r'default_notification_channel_id"\s+android:value="pantoo"'),
      ),
    );
    final icon = File(
      'android/app/src/main/res/drawable/ic_notif.xml',
    ).readAsStringSync();
    expect(icon, contains('android:fillColor="#FFFFFFFF"'));
    expect(icon, isNot(contains('<bitmap')));
    final keep = File(
      'android/app/src/main/res/raw/keep.xml',
    ).readAsStringSync();
    expect(keep, contains('@drawable/ic_notif'));
    for (final density in ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi']) {
      expect(
        File(
          'android/app/src/main/res/drawable-$density/ic_notif.png',
        ).existsSync(),
        isFalse,
      );
    }
  });
}
