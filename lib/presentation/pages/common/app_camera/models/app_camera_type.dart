import 'package:camera/camera.dart';

enum AppCameraType {
  selfie,
  document,
  general;

  String get title {
    switch (this) {
      case AppCameraType.selfie:
        return 'Ambil Foto Selfie';
      case AppCameraType.document:
        return 'Foto Dokumen';
      case AppCameraType.general:
        return 'Ambil Foto';
    }
  }

  String get instruction {
    switch (this) {
      case AppCameraType.selfie:
        return 'Pastikan wajah anda terlihat jelas';
      case AppCameraType.document:
        return 'Posisikan dokumen dalam bingkai';
      case AppCameraType.general:
        return 'Ambil foto objek';
    }
  }

  CameraLensDirection get initialDirection {
    switch (this) {
      case AppCameraType.selfie:
        return CameraLensDirection.front;
      case AppCameraType.document:
      case AppCameraType.general:
        return CameraLensDirection.back;
    }
  }

  ResolutionPreset get resolutionPreset {
    switch (this) {
      case AppCameraType.selfie:
        return ResolutionPreset.medium;
      case AppCameraType.document:
      case AppCameraType.general:
        return ResolutionPreset.high;
    }
  }

  bool get onlyFront {
    return this == AppCameraType.selfie;
  }

  bool get enabledFaceDetection {
    return this == AppCameraType.selfie;
  }
}
