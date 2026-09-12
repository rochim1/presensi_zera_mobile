import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class OvertimeRequestCard extends StatelessWidget {
  final OvertimeRequest? request;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool showUser;

  const OvertimeRequestCard({
    super.key,
    required this.request,
    this.onTap,
    this.showUser = true,
  }) : isLoading = false;

  const OvertimeRequestCard.shimmer({super.key, this.showUser = true})
    : request = null,
      onTap = null,
      isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return AppRequestCard.shimmer(showUser: showUser);
    return _buildCard(context, request!);
  }

  Widget _buildCard(BuildContext context, OvertimeRequest request) {
    return AppRequestCard(
      user: request.user,
      showUser: showUser,
      statusColor: request.status.toDisplayColor,
      statusLabel: request.status.toDisplayName,
      title: 'Lembur',
      subtitle: request.reason,
      onTap: onTap,
      middleContent: [
        Row(
          children: [
            if (request.date != null)
              Expanded(
                child: AppRequestDateRow(
                  title: 'Tanggal',
                  value: request.date!.format(pattern: 'EE, dd MMM yyyy'),
                  icon: PhosphorIcons.calendarBlank,
                  iconColor: AppColors.green,
                ),
              ),
            if (request.date != null) ...[
              Container(height: 28, width: 1, color: AppColors.dividerLight),
              SizedBox(width: AppDimens.w16),
            ],
            Expanded(
              child: AppRequestDateRow(
                title: 'Total Jam',
                value: request.durationInHours != 0
                    ? '${request.durationInHours} Jam'
                    : '-',
                icon: PhosphorIcons.clock,
                iconColor: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppRequestDateRow(
                title: 'Waktu Mulai',
                value: request.startTime?.format(pattern: 'HH:mm') ?? '--:--',
                icon: PhosphorIcons.signIn,
                iconColor: AppColors.orange,
              ),
            ),
            Container(height: 28, width: 1, color: AppColors.dividerLight),
            SizedBox(width: AppDimens.w16),
            Expanded(
              child: AppRequestDateRow(
                title: 'Waktu Selesai',
                value: request.endTime?.format(pattern: 'HH:mm') ?? '--:--',
                icon: PhosphorIcons.signOut,
                iconColor: AppColors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
