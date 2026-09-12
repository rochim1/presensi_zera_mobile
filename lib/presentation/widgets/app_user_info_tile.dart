import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class AppUserInfoTile extends StatelessWidget {
  final Widget Function(BuildContext context, Widget defaultLeading)?
  leadingBuilder;
  final Widget Function(BuildContext context, String title)? titleBuilder;
  final Widget Function(BuildContext context, String subtitle)? subtitleBuilder;
  final User? user;
  final VoidCallback? onTap;
  final Color? color;
  final String? subtitle;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final double? avatarSize;

  const AppUserInfoTile({
    super.key,
    this.leadingBuilder,
    this.titleBuilder,
    this.subtitleBuilder,
    this.user,
    this.onTap,
    this.color,
    this.subtitle,
    this.isLoading = false,
    this.padding,
    this.avatarSize,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoading(context);
    }

    final name = user?.name ?? 'Unknown';
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final sub = subtitle ?? user?.department?.name ?? 'Karyawan';
    final avatarUrl = user?.avatar?.url;
    final resolvedAvatarSize = avatarSize ?? AppDimens.w40;
    final defaultLeading = SizedBox.square(
      dimension: resolvedAvatarSize,
      child: ClipOval(
        child: AppImage(
          url: avatarUrl?.resolvedApiUri.toString(),
          width: resolvedAvatarSize,
          height: resolvedAvatarSize,
          fit: BoxFit.cover,
          errorBuilder: (context) => Container(
            color: color ?? AppColors.primary.withValues(alpha: 0.3),
            alignment: Alignment.center,
            child: Text(
              firstLetter,
              style: context.theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
    final defaultTitle = Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textStyle.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.labelPrimary,
      ),
    );
    final defaultSubtitle = Text(
      sub,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textStyle.bodySmall?.copyWith(
        color: AppColors.labelSecondary,
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      child: Container(
        padding: padding,
        child: Row(
          children: [
            if (leadingBuilder != null)
              leadingBuilder!(context, defaultLeading)
            else
              defaultLeading,
            AppDimens.sizeM.wSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (titleBuilder != null)
                    titleBuilder!(context, name)
                  else
                    defaultTitle,
                  AppDimens.size2S.hSpace,
                  if (subtitleBuilder != null)
                    subtitleBuilder!(context, sub)
                  else
                    defaultSubtitle,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        children: [
          AppShimmer.circle(size: AppDimens.size3L),
          AppDimens.sizeM.wSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppShimmer.box(width: AppDimens.w112, height: AppDimens.w14),
                AppDimens.size2S.hSpace,
                AppShimmer.box(width: AppDimens.w160, height: AppDimens.w14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
