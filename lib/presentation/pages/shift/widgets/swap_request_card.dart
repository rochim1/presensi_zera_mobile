import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class SwapRequestCard extends StatelessWidget {
  final ShiftSwapRequest? swapRequest;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool showUser;

  const SwapRequestCard({
    super.key,
    required this.swapRequest,
    this.onTap,
    this.showUser = true,
  }) : isLoading = false;

  const SwapRequestCard.shimmer({
    super.key,
    this.showUser = true,
  })
    : swapRequest = null,
      isLoading = true,
      onTap = null;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const AppRequestCard.shimmer();

    final request = swapRequest!;
    final accent = AppColors.primary;
    final date = request.requesterSchedule.assignedDate;

    return AppRequestCard(
      onTap: onTap,
      user: request.requesterUser,
      showUser: showUser,
      statusColor: request.status.toDisplayColor,
      statusLabel: request.status.toDisplayName,
      title: date?.format(pattern: 'EE, dd MMM yyyy'),
      middleContent: [
        _buildSwapDetails(context, request, accent),
        if (request.alasan.isNotEmpty) ...[
          SizedBox(height: AppDimens.h12),
          AppLabeledValue(
            label: 'Alasan Tukar',
            value: request.alasan,
            maxLines: 3,
            icon: PhosphorIcons.chatText,
            iconColor: AppColors.orange,
          ),
        ],
      ],
    );
  }


  Widget _buildSwapDetails(
    BuildContext context,
    ShiftSwapRequest request,
    Color accent,
  ) {
    return Column(
      spacing: AppDimens.h12,
      children: [
        _buildShiftInfo(
          context,
          user: request.requesterUser,
          schedule: request.requesterSchedule,
          label: 'Dari',
          accent: accent,
          isRequester: true,
        ),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.w12),
              child: Icon(
                PhosphorIcons.arrowsDownUpBold,
                size: 16,
                color: AppColors.labelTertiary,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        _buildShiftInfo(
          context,
          user: request.targetUser,
          schedule: request.targetSchedule,
          label: 'Ke',
          accent: accent,
          isRequester: false,
        ),
      ],
    );
  }

  Widget _buildShiftInfo(
    BuildContext context, {
    required User user,
    required ShiftSchedule schedule,
    required String label,
    required Color accent,
    required bool isRequester,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h8,
      children: [
        Row(
          children: [
            Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.labelSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              user.name,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.labelPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Row(
          spacing: AppDimens.w12,
          children: [
            Expanded(
              child: AppLabeledValue(
                label: 'Shift',
                value: schedule.shift.name,
                icon: PhosphorIcons.calendarCheckFill,
                iconColor: isRequester ? accent : AppColors.orange,
              ),
            ),
            Expanded(
              child: AppLabeledValue(
                label: 'Waktu',
                value:
                    '${schedule.shift.jamMasuk?.format(pattern: 'HH:mm')} - ${schedule.shift.jamPulang?.format(pattern: 'HH:mm')}',
                icon: PhosphorIcons.clockFill,
                iconColor: AppColors.labelTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }


}
