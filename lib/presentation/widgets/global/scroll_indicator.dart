import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class ScrollIndicator extends StatelessWidget {
  const ScrollIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppDimens.size4S),
      height: AppDimens.size3S,
      width: AppDimens.size3XL,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(AppDimens.size4XL),
        color: AppColors.grey.shade100,
      ),
    );
  }
}
