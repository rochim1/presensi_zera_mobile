import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/presentation/pages/common/app_camera/bloc/app_camera_cubit.dart';
import 'package:presensi_mobile/presentation/pages/common/app_camera/bloc/app_camera_state.dart';
import 'package:presensi_mobile/presentation/pages/common/app_camera/models/app_camera_type.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const permissions = MethodChannel('flutter.baseflow.com/permissions/methods');
  const mlkit = MethodChannel('google_mlkit_face_detector');

  test('Repeated camera actions cannot start another initialization', () async {
    final pendingPermission = Completer<Map<int, int>>();
    var permissionRequests = 0;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(permissions, (call) async {
      permissionRequests++;
      return pendingPermission.future;
    });
    messenger.setMockMethodCallHandler(mlkit, (_) async => null);
    final cubit = AppCameraCubit();
    try {
      final first = cubit.initialize(type: AppCameraType.selfie);
      // Let initialization reach the pending native permission request.
      await Future<void>.delayed(Duration.zero);
      expect(cubit.isBusy, isTrue);
      expect(cubit.state.status, AppCameraStatus.loading);
      await cubit.initialize(type: AppCameraType.selfie);
      await cubit.switchCamera();
      await cubit.retake();
      await cubit.takePicture();
      expect(permissionRequests, 1);
      pendingPermission.complete({1: 0});
      await first;
      expect(cubit.isBusy, isFalse);
      expect(cubit.state.status, AppCameraStatus.failure);
      // A failed operation releases the lock and allows retry.
      await cubit.initialize(type: AppCameraType.selfie);
      expect(permissionRequests, 2);
    } finally {
      await cubit.close();
      messenger.setMockMethodCallHandler(permissions, null);
      messenger.setMockMethodCallHandler(mlkit, null);
    }
  });
}
