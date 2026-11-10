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

  for (final code in [
    'NotFoundError',
    'DevicesNotFoundError',
    'cameraNotFound',
  ]) {
    test('$code explains a missing camera separately from denied access', () {
      final message = cameraAccessError(CameraException(code, ''));
      expect(message, contains('tidak menemukan kamera'));
      expect(
        message,
        isNot(cameraAccessError(CameraException('NotAllowedError', ''))),
      );
    });
  }

  for (final code in ['NotReadableError', 'TrackStartError']) {
    test('$code suggests closing other applications', () {
      final message = cameraAccessError(CameraException(code, ''));
      expect(message, contains('Tutup aplikasi lain'));
      expect(
        message,
        isNot(cameraAccessError(CameraException('NotAllowedError', ''))),
      );
    });
  }

  for (final code in [
    'NotAllowedError',
    'permissionDenied',
    'CameraAccessDenied',
    'CameraAccessDeniedWithoutPrompt',
    'CameraAccessRestricted',
  ]) {
    test('$code explains camera permission', () {
      expect(
        cameraAccessError(CameraException(code, '')),
        contains('Periksa izin kamera'),
      );
    });
  }

  test('Unknown camera errors preserve their diagnostic information', () {
    final error = CameraException('UnknownCameraError', 'diagnostic detail');
    expect(cameraAccessError(error), error.toString());
  });

  test('Other errors preserve their diagnostic information', () {
    final error = StateError('camera initialization failed');
    expect(cameraAccessError(error), error.toString());
  });
}
