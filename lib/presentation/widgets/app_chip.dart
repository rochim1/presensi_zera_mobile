import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppChip extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? backgroundColor;
  final IconData? icon;
  final bool hasBorder;
  final double? fontSize;
  final EdgeInsets? padding;
  final double? borderRadius;

  const AppChip({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
    this.icon,
    this.hasBorder = false,
    this.fontSize,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? AppColors.neutral;
    final themeBackgroundColor =
        backgroundColor ?? _semanticBackground(themeColor);
    final themeBorderColor = _semanticBorder(themeColor);

    return Container(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: AppDimens.w12,
            vertical: AppDimens.h6,
          ),
      decoration: BoxDecoration(
        color: themeBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? AppDimens.r6),
        border: Border.all(
          color: hasBorder ? themeColor : themeBorderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.textTheme.labelMedium!.copyWith(
              color: themeColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
          if (icon != null) ...[
            AppDimens.w4.wSpace,
            Icon(icon, size: (fontSize ?? 12) + 2, color: themeColor),
          ],
        ],
      ),
    );
  }

  Color _semanticBackground(Color value) {
    if (_sameColor(value, AppColors.warning) ||
        _sameColor(value, AppColors.orange) ||
        _sameColor(value, AppColors.yellow)) {
      return AppColors.warningBackground;
    }
    if (_sameColor(value, AppColors.danger) ||
        _sameColor(value, AppColors.red)) {
      return AppColors.dangerBackground;
    }
    if (_sameColor(value, AppColors.primary) ||
        _sameColor(value, AppColors.success) ||
        _sameColor(value, AppColors.green)) {
      return AppColors.successBackground;
    }
    if (_sameColor(value, AppColors.info) ||
        _sameColor(value, AppColors.blue) ||
        _sameColor(value, AppColors.tial)) {
      return AppColors.infoBackground;
    }
    return AppColors.neutralBackground;
  }

  Color _semanticBorder(Color value) {
    if (_sameColor(value, AppColors.warning) ||
        _sameColor(value, AppColors.orange) ||
        _sameColor(value, AppColors.yellow)) {
      return AppColors.warningBorder;
    }
    if (_sameColor(value, AppColors.danger) ||
        _sameColor(value, AppColors.red)) {
      return AppColors.dangerBorder;
    }
    if (_sameColor(value, AppColors.primary) ||
        _sameColor(value, AppColors.success) ||
        _sameColor(value, AppColors.green)) {
      return AppColors.successBorder;
    }
    if (_sameColor(value, AppColors.info) ||
        _sameColor(value, AppColors.blue) ||
        _sameColor(value, AppColors.tial)) {
      return AppColors.infoBorder;
    }
    return AppColors.neutralBorder;
  }

  bool _sameColor(Color first, Color second) =>
      first.toARGB32() == second.toARGB32();
}
