import 'dart:convert';
import 'dart:js_interop';

import 'package:camera/camera.dart';

@JS('pantooDetectFaces')
external JSPromise<JSNumber> _pantooDetectFaces(JSString imageDataUrl);

class WebFaceDetectionResult {
  final bool available;
  final int faceCount;

  const WebFaceDetectionResult({required this.available, this.faceCount = 0});
}

class WebFaceDetectionService {
  static Future<WebFaceDetectionResult> detect(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final mimeType = file.mimeType ?? _mimeTypeFromName(file.name);
      final dataUrl = 'data:$mimeType;base64,${base64Encode(bytes)}';
      final result = await _pantooDetectFaces(dataUrl.toJS).toDart;
      return WebFaceDetectionResult(
        available: true,
        faceCount: result.toDartInt,
      );
    } catch (_) {
      return const WebFaceDetectionResult(available: false);
    }
  }

  static String _mimeTypeFromName(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
