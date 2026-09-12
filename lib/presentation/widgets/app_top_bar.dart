import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'app_top_bar_action_button.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final Color? backgroundColor;
  final bool useGradient;
  final Color? titleColor;
  final bool centerTitle;

  const AppTopBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.onBackTap,
    this.backgroundColor,
    this.useGradient = true,
    this.titleColor,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: useGradient
          ? const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              image: DecorationImage(
                image: AssetImage(AppImages.geometricBg),
                fit: BoxFit.cover,
                alignment: Alignment.topLeft,
              ),
            )
          : null,
      color: useGradient ? null : (backgroundColor ?? Colors.transparent),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppDimens.h8,
        left: AppDimens.w16,
        right: AppDimens.w16,
        bottom: AppDimens.h8,
      ),
      child: Row(
        children: [
          // Leading
          Container(
            constraints: BoxConstraints(minWidth: AppDimens.w48),
            child:
                leading ??
                (showBackButton
                    ? AppTopBarActionButton(
                        icon: Icons.arrow_back,
                        onTap: onBackTap ?? () => Navigator.of(context).pop(),
                      )
                    : null),
          ),

          // Title
          Expanded(
            child: Align(
              alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '',
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          titleColor ??
                          (useGradient
                              ? AppColors.white
                              : AppColors.labelPrimary),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: AppDimens.h2),
                    Text(
                      subtitle!,
                      style: context.textStyle.bodySmall?.copyWith(
                        color: (titleColor ?? AppColors.white).withValues(
                          alpha: .78,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Actions
          Container(
            constraints: BoxConstraints(minWidth: AppDimens.w48),
            child: actions != null && actions!.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(AppDimens.h56 + (subtitle == null ? 16 : AppDimens.h28));
}
