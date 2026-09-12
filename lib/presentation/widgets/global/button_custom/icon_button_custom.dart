import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class IconButtonCustom extends StatelessWidget {
  /// please use widget `Icon` or `Text`
  final Widget icon;
  final String? label;
  final bool? selected;
  final Color? selectedColor;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final bool? showShadow;
  final void Function()? onTap;

  const IconButtonCustom({
    super.key,
    required this.icon,
    this.label,
    this.selected = false,
    this.selectedColor,
    this.color,
    this.padding,
    this.onTap,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppDimens.paddingMediumX),
            decoration: BoxDecoration(
              color: selected! ? selectedColor : AppColors.fillTertiary,
              shape: BoxShape.circle,
              boxShadow: [
                if (showShadow!)
                  BoxShadow(
                    color: AppColors.grey.shade200,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
              ],
            ),
            alignment: Alignment.center,
            child: Theme(
              data: ThemeData(
                iconTheme: IconThemeData(
                  color: color ?? AppColors.labelPrimary,
                ),
              ),
              child: icon,
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: AppDimens.size3S),
          Text(
            label!,
            style: context.textStyle.bodyMedium!.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
