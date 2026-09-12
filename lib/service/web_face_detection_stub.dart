import 'package:camera/camera.dart';

class WebFaceDetectionResult {
  final bool available;
  final int faceCount;

  const WebFaceDetectionResult({required this.available, this.faceCount = 0});
}

class WebFaceDetectionService {
  static Future<WebFaceDetectionResult> detect(XFile file) async {
    return const WebFaceDetectionResult(available: false);
  }
}
