import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class AttendanceRequestCard extends StatelessWidget {
  final AttendanceRequest? request;
  final VoidCallback? onTap;
  final User? user;
  final bool isLoading;
  final bool showUser;

  const AttendanceRequestCard({
    super.key,
    required this.request,
    this.onTap,
    this.user,
    this.showUser = true,
  }) : isLoading = false;

  const AttendanceRequestCard.shimmer({
    super.key,
    this.showUser = true,
  })
    : request = null,
      onTap = null,
      user = null,
      isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return AppRequestCard.shimmer(showUser: showUser);
    return _buildCard(context, request!);
  }

  Widget _buildCard(BuildContext context, AttendanceRequest request) {
    final resolvedUser = user ?? request.user;

    return AppRequestCard(
      user: resolvedUser,
      showUser: showUser,
      statusColor: request.status.toDisplayColor,
      statusLabel: request.status.toDisplayName,
      title: 'Request Presensi',
      subtitle: request.alasan,
      onTap: onTap,
      middleContent: [
        Row(
          children: [
            Icon(PhosphorIcons.articleFill, size: 16, color: request.status.toDisplayColor),
            SizedBox(width: AppDimens.w8),
            Expanded(
              child: Text(
                request.type.displayName,
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (request.tanggalPresensi != null)
              Expanded(
                child: AppRequestDateRow(
                  title: 'Tanggal',
                  value: request.tanggalPresensi!.format(pattern: 'dd MMM yyyy'),
                  icon: PhosphorIcons.calendarBlank,
                  iconColor: AppColors.green,
                ),
              ),
            if (request.tanggalPresensi != null) ...[
              Container(height: 28, width: 1, color: AppColors.dividerLight),
              SizedBox(width: AppDimens.w16),
            ],
            Expanded(
              child: AppRequestDateRow(
                title: 'Waktu Diminta',
                value: request.waktuYangDiminta.isEmpty ? '-' : request.waktuYangDiminta,
                icon: PhosphorIcons.clock,
                iconColor: AppColors.orange,
              ),
            ),
          ],
        ),
      ],
      footer: request.createdAt != null
          ? Align(
              alignment: Alignment.centerRight,
              child: Text(
                'DIAJUKAN ${request.createdAt!.timeAgo()}',
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.labelSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
