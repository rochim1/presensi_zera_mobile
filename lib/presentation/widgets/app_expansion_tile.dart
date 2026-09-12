import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppExpansionTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final List<Widget> children;
  final Widget? leading;
  final Widget? trailing;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final EdgeInsetsGeometry? tilePadding;
  final EdgeInsetsGeometry? childrenPadding;
  final BorderRadius? borderRadius;
  final bool showDivider;

  const AppExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.leading,
    this.trailing,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.tilePadding,
    this.childrenPadding,
    this.borderRadius,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: initiallyExpanded ? backgroundColor : collapsedBackgroundColor,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppDimens.radiusMedium),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: DefaultTextStyle.merge(
            style: context.theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.labelPrimary,
            ),
            child: title,
          ),
          subtitle: subtitle != null
              ? DefaultTextStyle.merge(
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.labelSecondary,
                  ),
                  child: subtitle!,
                )
              : null,
          leading: leading,
          trailing: trailing,
          initiallyExpanded: initiallyExpanded,
          onExpansionChanged: onExpansionChanged,
          backgroundColor: backgroundColor ?? Colors.transparent,
          collapsedBackgroundColor:
              collapsedBackgroundColor ?? Colors.transparent,
          tilePadding:
              tilePadding ??
              const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingMediumX,
                vertical: AppDimens.paddingSmall,
              ),
          childrenPadding:
              childrenPadding ??
              const EdgeInsets.only(
                left: AppDimens.paddingMediumX,
                right: AppDimens.paddingMediumX,
                bottom: AppDimens.paddingMediumX,
              ),
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.circular(AppDimens.radiusMedium),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.circular(AppDimens.radiusMedium),
          ),
          children: [
            if (showDivider)
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.dividerLight,
              ),
            ...children,
          ],
        ),
      ),
    );
  }
}
