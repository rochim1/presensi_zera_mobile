import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_mobile/service/camera_access.dart';
import 'package:presensi_mobile/presentation/pages/common/app_camera/bloc/app_camera_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Web camera can proceed to browser permission without native permission gate',
    () async {
      expect(cameraEnvironmentError(), isNull);
      expect(await requestNativeCameraAccess(), isTrue);
      final cubit = AppCameraCubit();
      expect(cubit.isBusy, isFalse);
      await cubit.close();
    },
    skip: !kIsWeb,
  );
}
