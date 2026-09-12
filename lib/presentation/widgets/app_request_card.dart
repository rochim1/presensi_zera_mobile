import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class AppRequestCard extends StatelessWidget {
  final User? user;
  final Color statusColor;
  final String statusLabel;
  final String? title;
  final String? subtitle;
  final List<Widget> middleContent;
  final Widget? footer;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool hasShadow;
  final bool showUser;

  const AppRequestCard({
    super.key,
    required this.user,
    required this.statusColor,
    required this.statusLabel,
    this.title,
    this.subtitle,
    required this.middleContent,
    this.footer,
    this.onTap,
    this.hasShadow = true,
    this.showUser = true,
  }) : isLoading = false;

  const AppRequestCard.shimmer({
    super.key, 
    this.hasShadow = true,
    this.showUser = true,
  })
    : user = null,
      statusColor = AppColors.grey,
      statusLabel = '',
      title = null,
      subtitle = null,
      middleContent = const [],
      footer = null,
      onTap = null,
      isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildLoading(context);
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final hasVisibleBody = (showUser && title != null) ||
        (subtitle != null && subtitle!.isNotEmpty);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimens.r16),
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: AppColors.labelSecondary.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: AppColors.labelSecondary.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(AppDimens.w16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              if (hasVisibleBody) ...[
                SizedBox(height: AppDimens.h12),
                _buildBody(context),
              ],
              if (middleContent.isNotEmpty) ...[
                SizedBox(height: AppDimens.h12),
                Container(
                  height: 1,
                  color: AppColors.labelSecondary.withValues(alpha: 0.1),
                ),
                SizedBox(height: AppDimens.h12),
                ...middleContent,
              ],
              if (footer != null) ...[SizedBox(height: AppDimens.h12), footer!],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showUser)
          Expanded(
            child: AppUserInfoTile(
              user: user,
              color: statusColor,
              padding: EdgeInsets.zero,
            ),
          )
        else if (title != null)
          Expanded(
            child: Text(
              title!,
              style: context.theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          )
        else
          const Spacer(),
        SizedBox(width: AppDimens.w8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.sizeM,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimens.size4M),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showUser && title != null)
          Text(
            title!,
            style: context.theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          if (showUser && title != null) SizedBox(height: AppDimens.h4),
          Text(
            subtitle!,
            style: context.theme.textTheme.bodySmall?.copyWith(
              color: AppColors.labelSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppColors.labelSecondary.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: AppColors.labelSecondary.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(AppDimens.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (showUser)
                  const Expanded(
                    child: AppUserInfoTile(
                      isLoading: true,
                      padding: EdgeInsets.zero,
                    ),
                  )
                else
                  const Spacer(),
                SizedBox(width: AppDimens.w8),
                AppShimmer.box(
                  width: AppDimens.w64,
                  height: AppDimens.h24,
                  radius: AppDimens.r16,
                ),
              ],
            ),
            SizedBox(height: AppDimens.h16),
            AppShimmer.box(width: AppDimens.w128, height: AppDimens.h16),
            SizedBox(height: AppDimens.h6),
            AppShimmer.box(width: double.infinity, height: AppDimens.h12),
            SizedBox(height: AppDimens.h16),
            Container(height: 1, color: AppColors.shimmerBaseColor),
            SizedBox(height: AppDimens.h16),
            AppShimmer.box(width: AppDimens.w140, height: AppDimens.h12),
            SizedBox(height: AppDimens.h10),
            AppShimmer.box(width: AppDimens.w140, height: AppDimens.h12),
          ],
        ),
      ),
    );
  }
}

class AppRequestDateRow extends StatelessWidget {
  final String? title;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const AppRequestDateRow({
    super.key,
    this.title,
    required this.value,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && title!.isNotEmpty) ...[
          Text(
            title!,
            style: context.theme.textTheme.bodySmall?.copyWith(
              color: AppColors.labelSecondary,
              fontSize: 10,
            ),
          ),
          SizedBox(height: AppDimens.h2),
        ],
        Row(
          children: [
            Icon(
              icon ?? PhosphorIcons.calendarBlank,
              size: 14,
              color: iconColor ?? AppColors.labelPrimary,
            ),
            SizedBox(width: AppDimens.w6),
            Expanded(
              child: Text(
                value,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.labelPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
