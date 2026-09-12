import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification? notification;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isLoading;

  const NotificationCard({
    super.key,
    required AppNotification this.notification,
    this.onTap,
    this.onDelete,
  }) : isLoading = false;

  const NotificationCard.shimmer({super.key})
    : notification = null,
      onTap = null,
      onDelete = null,
      isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildLoading(context);
    final notification = this.notification!;
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(color: AppColors.transparent),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.w20),
        decoration: BoxDecoration(
          color: AppColors.dangerBackground,
          borderRadius: BorderRadius.circular(AppDimens.r12),
          border: Border.all(color: AppColors.dangerBorder),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(PhosphorIconsFill.trash, color: AppColors.danger),
            SizedBox(width: 8),
            Text(
              'Hapus',
              style: TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppDimens.r12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingMediumX,
                  vertical: AppDimens.paddingMedium,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDimens.r12),
                  ),
                  border: Border.all(
                    color: notification.isRead
                        ? AppColors.border
                        : AppColors.successBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon Container
                    Container(
                      width: AppDimens.w48,
                      height: AppDimens.w48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: notification.type.iconColor.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(AppDimens.r12),
                      ),
                      child: Icon(
                        notification.type.icon,
                        color: notification.type.iconColor,
                        size: AppDimens.iconMedium,
                      ),
                    ),
                    SizedBox(width: AppDimens.w12),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title.trim(),
                            style: TextStyle(
                              fontSize: AppDimens.size3M,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w700,
                              color: AppColors.labelPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppDimens.h4),
                          Text(
                            notification.body.trim(),
                            style: TextStyle(
                              fontSize: AppDimens.size2M,
                              fontWeight: FontWeight.normal,
                              color: AppColors.labelSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (notification.createdAt != null) ...[
                            SizedBox(height: AppDimens.h8),
                            Text(
                              notification.createdAt!.timeAgo(
                                pattern: 'dd MMMM yyyy HH:mm:ss',
                              ),
                              style: TextStyle(
                                fontSize: AppDimens.sizeM,
                                color: notification.isRead
                                    ? AppColors.labelTertiary
                                    : AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!notification.isRead)
            Positioned(
              top: AppDimens.h10,
              right: AppDimens.w10,
              child: Container(
                width: AppDimens.w8,
                height: AppDimens.h8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMediumX,
        vertical: AppDimens.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.r12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Container Shimmer
          AppShimmer.box(
            width: AppDimens.w48,
            height: AppDimens.w48,
            radius: AppDimens.r12,
          ),
          SizedBox(width: AppDimens.w12),

          // Content Shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer.box(width: double.infinity, height: AppDimens.h16),
                SizedBox(height: AppDimens.h8),
                AppShimmer.box(width: double.infinity, height: AppDimens.h12),
                SizedBox(height: AppDimens.h4),
                AppShimmer.box(width: AppDimens.w128, height: AppDimens.h12),
                SizedBox(height: AppDimens.h8),
                AppShimmer.box(width: AppDimens.w80, height: AppDimens.h10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
