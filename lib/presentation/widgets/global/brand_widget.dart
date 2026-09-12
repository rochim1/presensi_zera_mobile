import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class BrandWidget extends StatelessWidget {
  const BrandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingMediumX),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
      ),
      child: Image.asset(AppImages.zeraLogo, height: AppDimens.maxWidthLogo),
    );
  }
}
