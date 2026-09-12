import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class ButtonAddCustom extends StatelessWidget {
  final Widget? icon;
  final Function() onTap;
  final bool? isDark;
  final Color? background;
  final Color? color;
  final String? tooltip;

  const ButtonAddCustom({
    super.key,
    this.icon,
    required this.onTap,
    this.isDark = false,
    this.background,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.size3XL,
      height: AppDimens.size3XL,
      decoration: BoxDecoration(
        color: background ?? AppColors.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsetsDirectional.all(6.0),
          width: AppDimens.sizeL,
          height: AppDimens.sizeL,
          child:
              icon ??
              Icon(
                Icons.add,
                size: AppDimens.sizeL,
                color: color ?? AppColors.secondary,
              ),
        ),
      ),
    );
  }
}
