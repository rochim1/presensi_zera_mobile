import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class AttendanceRequestDetailView extends StatelessWidget {
  final AttendanceRequest request;
  final User? user;
  const AttendanceRequestDetailView({
    super.key,
    required this.request,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppDimens.h16,
        children: [
          _buildHeader(context),
          _buildRequestDetails(context),
          _buildReason(context),
          _buildApprovalHistory(context),
          _buildTechnicalInfo(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppUserInfoTile(
            user: user ?? request.user,
            color: request.status.toDisplayColor,
            avatarSize: AppDimens.w56,
            subtitle: request.type.displayName,
            padding: EdgeInsets.zero,
          ),
        ),
        SizedBox(width: AppDimens.w12),
        AppChip(
          label: request.status.toDisplayName,
          color: request.status.toDisplayColor,
          borderRadius: AppDimens.r16,
        ),
      ],
    );
  }

  Widget _buildRequestDetails(BuildContext context) {
    return AppDetailSectionCard(
      title: 'Informasi Request',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppDimens.h12,
        children: [
          Text(
            'Detail Request',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppLabeledValue(
            label: 'Jenis Request',
            value: request.type.displayName,
            icon: PhosphorIcons.article,
            iconColor: request.status.toDisplayColor,
          ),
          if (request.tanggalPresensi != null)
            AppLabeledValue(
              label: 'Tanggal Presensi',
              value: request.tanggalPresensi!.format(
                pattern: 'EEEE, dd MMMM yyyy',
              ),
              icon: PhosphorIcons.calendarBlank,
            ),
          AppLabeledValue(
            label: 'Waktu yang Diminta',
            value: request.waktuYangDiminta.isEmpty
                ? '-'
                : request.waktuYangDiminta,
            icon: PhosphorIcons.clock,
            iconColor: AppColors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildReason(BuildContext context) {
    return AppDetailSectionCard(
      title: 'Alasan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request.alasan.isEmpty ? '-' : request.alasan,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.labelSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalHistory(BuildContext context) {
    return AppDetailSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (request.approvalHistory == null)
            Text(
              'Belum ada riwayat persetujuan.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.labelSecondary,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            AppApprovalHistory(history: request.approvalHistory!),
        ],
      ),
    );
  }

  Widget _buildTechnicalInfo(BuildContext context) {
    return AppDetailSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppDimens.h8,
        children: [
          AppMetaText('ID: #${request.id}'),
          if (request.createdAt != null)
            AppMetaText(
              'DIBUAT PADA: ${request.createdAt!.format(pattern: 'dd MMM yyyy, HH:mm')}',
            ),
        ],
      ),
    );
  }
}
