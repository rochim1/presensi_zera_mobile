import 'package:flutter/material.dart';

class AppWaveContainer extends StatelessWidget {
  final double height;
  final Widget child;

  const AppWaveContainer({super.key, this.height = 250, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: SizedBox(height: height, width: double.infinity, child: child),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 60);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 40,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 80,
      size.width,
      size.height - 40,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(_) => false;
}
