import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class SwapRequestDetailView extends StatelessWidget {
  final ShiftSwapRequest request;

  const SwapRequestDetailView({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppDimens.h16,
        children: [
          _buildHeader(context),
          AppDetailSectionCard(
            child: _buildShiftDetails(
              context,
              title: 'Shift Saya (Requester)',
              user: request.requesterUser,
              schedule: request.requesterSchedule,
              showDivider: false,
            ),
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
          AppDetailSectionCard(
            child: _buildShiftDetails(
              context,
              title: 'Shift Tujuan (Target)',
              user: request.targetUser,
              schedule: request.targetSchedule,
            ),
          ),
          AppDetailSectionCard(child: _buildReason(context)),
          if (request.rejectedReason != null)
            AppDetailSectionCard(child: _buildRejectReason(context)),
          if (request.cancelledReason != null)
            AppDetailSectionCard(child: _buildCancelReason(context)),
          if (request.approvalHistory != null)
            AppDetailSectionCard(child: _buildApprovalHistory(context)),
          AppDetailSectionCard(child: _buildTechnicalInfo(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Request Tukar Shift',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppChip(
              label: request.status.toDisplayName,
              color: request.status.toDisplayColor,
              borderRadius: AppDimens.r16,
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildShiftDetails(
    BuildContext context, {
    required String title,
    required User user,
    required ShiftSchedule schedule,
    bool showDivider = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppUserInfoTile(user: user),
        AppLabeledValue(
          label: 'Tanggal',
          value:
              schedule.assignedDate?.format(pattern: 'EEEE, dd MMMM yyyy') ??
              '-',
          icon: PhosphorIcons.calendarBlank,
        ),
        AppLabeledValue(
          label: 'Nama Shift',
          value: schedule.shift.name,
          icon: PhosphorIcons.calendarCheck,
        ),
        Row(
          children: [
            Expanded(
              child: AppLabeledValue(
                label: 'Jam Masuk',
                value:
                    schedule.shift.jamMasuk?.format(pattern: 'HH:mm') ??
                    '--:--',
                icon: PhosphorIcons.signIn,
              ),
            ),
            Expanded(
              child: AppLabeledValue(
                label: 'Jam Pulang',
                value:
                    schedule.shift.jamPulang?.format(pattern: 'HH:mm') ??
                    '--:--',
                icon: PhosphorIcons.signOut,
              ),
            ),
          ],
        ),
        if (showDivider) const Divider(),
      ],
    );
  }

  Widget _buildReason(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Text(
          'Alasan Tukar',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          request.alasan,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.labelSecondary,
            height: 1.5,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildRejectReason(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Text(
          'Alasan Ditolak',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.red,
          ),
        ),
        Text(
          request.rejectedReason!,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.labelSecondary,
            height: 1.5,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildCancelReason(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Text(
          'Alasan Dibatalkan',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.labelSecondary,
          ),
        ),
        Text(
          request.cancelledReason!,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.labelSecondary,
            height: 1.5,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildApprovalHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h12,
      children: [
        Text(
          'Riwayat Persetujuan',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppApprovalHistory(history: request.approvalHistory!),
        const Divider(),
      ],
    );
  }

  Widget _buildTechnicalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimens.h8,
      children: [
        AppMetaText('ID: #${request.id}'),
        if (request.createdAt != null)
          AppMetaText(
            'DIBUAT PADA: ${request.createdAt!.format(pattern: 'dd MMM yyyy, HH:mm')}',
          ),
        if (request.updatedAt != null)
          AppMetaText(
            'DIUPDATE PADA: ${request.updatedAt!.format(pattern: 'dd MMM yyyy, HH:mm')}',
          ),
      ],
    );
  }
}
