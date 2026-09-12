import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:presensi_mobile/core/_core.dart';

class SpinIndicatorText extends StatelessWidget {
  final Color? color;
  final double? size;

  const SpinIndicatorText({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SpinKitThreeBounce(
        color: color ?? AppColors.primary,
        size: size ?? 10,
      ),
    );
  }
}
