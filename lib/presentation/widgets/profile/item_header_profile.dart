import 'package:flutter/material.dart';

import 'package:presensi_mobile/core/_core.dart';

class ItemHeaderProfile extends StatelessWidget {
  final String title;

  const ItemHeaderProfile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.paddingMediumX,
        right: AppDimens.paddingMediumX,
        top: AppDimens.paddingLargeX,
        bottom: AppDimens.paddingSmallX,
      ),
      child: Text(
        title,
        style: context.textStyle.titleMedium!.copyWith(
          color: AppColors.labelPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
