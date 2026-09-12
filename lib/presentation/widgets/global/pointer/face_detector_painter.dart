import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'coordinates_translator.dart';

class FaceDetectorPainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection? cameraLensDirection;

  FaceDetectorPainter(
    this.faces,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColors.green;

    for (final Face face in faces) {
      final left = translateX(
        face.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection!,
      );
      final top = translateY(
        face.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection!,
      );
      final right = translateX(
        face.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection!,
      );
      final bottom = translateY(
        face.boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection!,
      );

      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);

      const textStyle = TextStyle(
        color: AppColors.green,
        fontSize: AppDimens.size3M,
      );
      const textSpan = TextSpan(text: kFaceDetected, style: textStyle);

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: 0, maxWidth: size.width);

      final offset = Offset(
        ((size.width - face.boundingBox.center.dx) / 2) + (textPainter.width),
        top - AppDimens.size2L,
      );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}
