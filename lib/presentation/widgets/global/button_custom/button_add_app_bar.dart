import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class ButtonAddAppBar extends StatelessWidget {
  final Widget? icon;
  final Function() onTap;
  final bool? isDark;

  const ButtonAddAppBar({
    super.key,
    this.icon = const Icon(Icons.add, size: 24),
    required this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppDimens.paddingMedium,
        horizontal: AppDimens.paddingMediumX,
      ),
      width: AppDimens.size4L,
      height: AppDimens.size4L,
      decoration: BoxDecoration(
        color: isDark! ? AppColors.labelSecondary : AppColors.labelTertiaryDark,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsetsDirectional.all(6.0),
          width: AppDimens.sizeL,
          height: AppDimens.sizeL,
          child: icon,
        ),
      ),
    );
  }
}
