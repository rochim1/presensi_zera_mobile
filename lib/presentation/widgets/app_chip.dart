import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:presensi_mobile/core/themes/pantoo_ui.dart';
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
    // Status/category labels are neutral metadata, not colored badges.
    const themeColor = AppColors.labelSecondary;
    final themeBackgroundColor = backgroundColor ?? Colors.transparent;
    return Container(
      padding: padding ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: themeBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? AppDimens.r6),
        border: hasBorder ? Border.fromBorderSide(PantooUi.border) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: HrText(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: PantooUi.metadata.copyWith(fontSize: fontSize),
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: (fontSize ?? 12) + 2, color: themeColor),
          ],
        ],
      ),
    );
  }
}
