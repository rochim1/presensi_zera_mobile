import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppCameraOverlay extends CustomPainter {
  final bool isFaceDetected;

  AppCameraOverlay({this.isFaceDetected = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isFaceDetected ? Colors.green : AppColors.primary
      ..strokeWidth = AppDimens.r6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double cornerSize = AppDimens.r40;
    final double padding = AppDimens.r60;
    final rect = Rect.fromLTWH(
      padding,
      size.height * 0.2,
      size.width - (padding * 2),
      size.height * 0.5,
    );

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.top + cornerSize)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.left + cornerSize, rect.top),
      paint,
    );

    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - cornerSize, rect.top)
        ..lineTo(rect.right, rect.top)
        ..lineTo(rect.right, rect.top + cornerSize),
      paint,
    );

    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.bottom - cornerSize)
        ..lineTo(rect.left, rect.bottom)
        ..lineTo(rect.left + cornerSize, rect.bottom),
      paint,
    );

    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - cornerSize, rect.bottom)
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.right, rect.bottom - cornerSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant AppCameraOverlay oldDelegate) {
    return oldDelegate.isFaceDetected != isFaceDetected;
  }
}
