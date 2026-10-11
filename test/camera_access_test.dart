import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/service/camera_access.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const permissions = MethodChannel('flutter.baseflow.com/permissions/methods');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  tearDown(() => messenger.setMockMethodCallHandler(permissions, null));

  test(
    'Web delegates permission to camera without a native permission request',
    () async {
      var requests = 0;
      messenger.setMockMethodCallHandler(permissions, (_) async {
        requests++;
        return {1: 0};
      });
      expect(await requestNativeCameraAccess(isWeb: true), isTrue);
      expect(requests, 0);
      expect(await requestNativeCameraAccess(isWeb: false), isFalse);
      expect(requests, 1);
    },
  );

  test('Native camera still requires granted permission', () async {
    messenger.setMockMethodCallHandler(permissions, (_) async => {1: 1});
    expect(await requestNativeCameraAccess(isWeb: false), isTrue);
  });

  test('Missing or busy cameras are not reported as permission denial', () {
    expect(
      cameraAccessError(CameraException('NotFoundError', '')),
      contains('tidak ditemukan'),
    );
    expect(
      cameraAccessError(CameraException('NotReadableError', '')),
      contains('aplikasi lain'),
    );
    expect(
      cameraAccessError(CameraException('NotAllowedError', '')),
      contains('izin kamera'),
    );
  });
}
