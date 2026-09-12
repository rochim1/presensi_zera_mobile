import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class ShiftScheduleCard extends StatelessWidget {
  final ShiftSchedule? schedule;
  final VoidCallback? onTap;
  final bool isLoading;

  const ShiftScheduleCard({
    super.key,
    required ShiftSchedule this.schedule,
    this.onTap,
  }) : isLoading = false;

  const ShiftScheduleCard.shimmer({super.key})
    : schedule = null,
      isLoading = true,
      onTap = null;

  bool get _isToday => schedule?.assignedDate?.isToday ?? false;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildShimmer(context);
    return _buildCard(context, schedule!);
  }

  Widget _buildCard(BuildContext context, ShiftSchedule schedule) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.dividerLight.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppDimens.r16),
      ),
      child: InkWell(
        onTap: () {
          if (onTap != null) onTap!();
        },
        borderRadius: BorderRadius.circular(AppDimens.r16),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.h16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, schedule),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.dividerLight),
              const SizedBox(height: 12),
              
              // Nama Shift (Always Visible)
              Row(
                children: [
                  Icon(PhosphorIcons.briefcaseFill, size: 16, color: AppColors.primary),
                  SizedBox(width: AppDimens.w8),
                  Expanded(
                    child: Text(
                      '${schedule.shift.name} (${schedule.shift.jamMasuk?.format(pattern: 'HH:mm') ?? '--:--'} - ${schedule.shift.jamPulang?.format(pattern: 'HH:mm') ?? '--:--'})',
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ShiftSchedule schedule) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIcons.calendarBlank,
              size: 16,
              color: AppColors.primary,
            ),
            if (schedule.assignedDate != null) ...[
              SizedBox(width: AppDimens.w8),
              Text(
                '${schedule.assignedDate!.format(pattern: 'EE, dd MMM yyyy')}${_isToday ? " (Hari Ini)" : ""}',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.labelPrimary,
                ),
              ),
            ],
          ],
        ),
        AppChip(
          label: schedule.status.toDisplayName,
          color: schedule.status.toDisplayColor,
          borderRadius: AppDimens.r16,
        ),
      ],
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.dividerLight.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppDimens.r16),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimens.h16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 120, height: 20),
                AppShimmer.box(width: 60, height: 24, radius: 12),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.dividerLight),
            const SizedBox(height: 12),
            AppShimmer.box(width: double.infinity, height: 24),
          ],
        ),
      ),
    );
  }
}
