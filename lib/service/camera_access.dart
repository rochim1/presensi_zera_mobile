import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

export 'camera_environment_stub.dart'
    if (dart.library.js_interop) 'camera_environment_web.dart';

/// On web, camera_web requests access through getUserMedia. A separate
/// permission_handler request can hide the actual browser failure reason.
Future<bool> requestNativeCameraAccess({bool isWeb = kIsWeb}) async {
  if (isWeb) return true;
  return (await Permission.camera.request()).isGranted;
}

String cameraAccessError(Object error) {
  if (error is CameraException) {
    switch (error.code) {
      case 'NotAllowedError':
      case 'permissionDenied':
      case 'CameraAccessDenied':
      case 'CameraAccessDeniedWithoutPrompt':
      case 'CameraAccessRestricted':
        return 'Browser atau perangkat belum memberi akses kamera. Periksa izin kamera untuk situs/aplikasi ini lalu coba lagi.';
      case 'NotFoundError':
      case 'DevicesNotFoundError':
      case 'cameraNotFound':
        return 'Browser tidak menemukan kamera yang bisa digunakan. Pastikan perangkat memiliki kamera, izin kamera untuk situs ini aktif, dan coba buka halaman langsung di browser melalui HTTPS.';
      case 'NotReadableError':
      case 'TrackStartError':
        return 'Kamera tidak dapat dibuka. Tutup aplikasi lain yang menggunakan kamera lalu coba lagi.';
    }
  }
  return error.toString();
}
