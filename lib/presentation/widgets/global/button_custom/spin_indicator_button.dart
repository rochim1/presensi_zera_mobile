import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:presensi_mobile/core/_core.dart';

class SpinIndicatorButton extends StatelessWidget {
  const SpinIndicatorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppDimens.sizeL,
      height: AppDimens.sizeL,
      child: Center(
        child: SpinKitCircle(size: AppDimens.sizeL, color: AppColors.white),
      ),
    );
  }
}
