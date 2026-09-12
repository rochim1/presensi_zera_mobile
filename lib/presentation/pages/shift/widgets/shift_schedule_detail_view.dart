import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class ShiftScheduleDetailView extends StatelessWidget {
  final ShiftSchedule schedule;

  const ShiftScheduleDetailView({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppDimens.h16,
        children: [
          AppDetailSectionCard(child: _buildMainInfo(context)),
          AppDetailSectionCard(child: _buildTimeInfo(context)),
          if (schedule.notes != null && schedule.notes!.isNotEmpty)
            AppDetailSectionCard(child: _buildNotes(context)),
          AppDetailSectionCard(child: _buildTechnicalInfo(context)),
        ],
      ),
    );
  }

  Widget _buildMainInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Row(
          children: [
            Expanded(
              child: AppLabeledValue(
                label: 'Nama Shift',
                value: schedule.shift.name,
              ),
            ),
            AppChip(
              label: schedule.status.toDisplayName,
              color: schedule.status.toDisplayColor,
              borderRadius: AppDimens.r16,
            ),
          ],
        ),
        AppLabeledValue(
          label: 'Tanggal Penugasan',
          value:
              schedule.assignedDate?.format(pattern: 'EEEE, dd MMMM yyyy') ??
              '-',
          icon: PhosphorIcons.calendarBlank,
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Text(
          'Waktu Kerja',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AppLabeledValue(
                label: 'Check In',
                value:
                    schedule.shift.jamMasuk?.format(pattern: 'HH:mm:ss') ??
                    '--:--:--',
                icon: PhosphorIcons.signInFill,
                iconColor: AppColors.primary,
              ),
            ),
            Expanded(
              child: AppLabeledValue(
                label: 'Check Out',
                value:
                    schedule.shift.jamPulang?.format(pattern: 'HH:mm:ss') ??
                    '--:--:--',
                icon: PhosphorIcons.signOutFill,
                iconColor: AppColors.primary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: AppLabeledValue(
                label: 'Durasi Kerja',
                value: schedule.shift.totalKerja?.timeDuration() ?? '--:--',
                icon: PhosphorIcons.hourglass,
                iconColor: AppColors.primary,
              ),
            ),
            Expanded(
              child: AppLabeledValue(
                label: 'Durasi Istirahat',
                value:
                    schedule.shift.durasiIstirahat?.timeDuration() ?? '--:--',
                icon: PhosphorIcons.coffee,
                iconColor: AppColors.orange,
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildNotes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Text(
          'Catatan',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          schedule.notes!,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.labelSecondary,
            height: 1.5,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildTechnicalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h8,
      children: [
        AppMetaText('ID: #${schedule.id}'),
        if (schedule.createdAt != null)
          AppMetaText(
            'DIBUAT PADA: ${schedule.createdAt!.format(pattern: 'dd MMM yyyy, HH:mm')}',
          ),
        if (schedule.updatedAt != null)
          AppMetaText(
            'DIUPDATE PADA: ${schedule.updatedAt!.format(pattern: 'dd MMM yyyy, HH:mm')}',
          ),
      ],
    );
  }
}
