import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class AppRequestDetailView extends StatelessWidget {
  final User? user;
  final String statusLabel;
  final Color statusColor;
  final String? headerSubtitle;
  final String? reason;
  final List<Widget> middleContent;
  final ApprovalHistory? approvalHistory;
  final DateTime? createdAt;
  final String Function(DateTime)? dateFormatter;
  final double? sectionSpacing;

  const AppRequestDetailView({
    super.key,
    required this.user,
    required this.statusLabel,
    required this.statusColor,
    this.headerSubtitle,
    this.reason,
    required this.middleContent,
    this.approvalHistory,
    this.createdAt,
    this.dateFormatter,
    this.sectionSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: sectionSpacing ?? AppDimens.h20,
        children: [
          _buildHeaderSection(context),
          if (reason != null)
            AppDetailSectionCard(
              title: 'Alasan',
              child: _buildReasonSection(context),
            ),
          if (middleContent.isNotEmpty)
            AppDetailSectionCard(
              title: 'Informasi Pengajuan',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: middleContent,
              ),
            ),
          if (createdAt != null)
            AppDetailSectionCard(child: _buildCreatedAtSection(context)),
          if (approvalHistory != null) ...[
            AppDetailSectionCard(
              child: AppApprovalHistory(history: approvalHistory!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppUserInfoTile(
            user: user,
            color: statusColor,
            subtitle: headerSubtitle,
            padding: EdgeInsets.zero,
          ),
        ),
        SizedBox(width: AppDimens.w12),
        AppChip(
          label: statusLabel,
          color: statusColor,
          borderRadius: AppDimens.r16,
        ),
      ],
    );
  }

  Widget _buildReasonSection(BuildContext context) {
    return Text(
      reason!.isEmpty ? '-' : reason!,
      style: context.theme.textTheme.bodyMedium?.copyWith(
        color: AppColors.labelPrimary,
        height: 1.45,
      ),
    );
  }

  Widget _buildCreatedAtSection(BuildContext context) {
    return Row(
      children: [
        Icon(PhosphorIcons.calendarCheck, color: AppColors.primary),
        SizedBox(width: AppDimens.w12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tanggal Pengajuan',
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.labelSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimens.h2),
              Text(
                _formatDate(createdAt),
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.labelPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    if (dateFormatter != null) return dateFormatter!(dt);
    return dt.format(pattern: 'dd MMMM yyyy');
  }
}

class AppRequestDetailItem extends StatelessWidget {
  final String label;
  final DateTime? date;
  final String? textValue;
  final IconData? icon;
  final String Function(DateTime)? dateFormatter;

  const AppRequestDetailItem({
    super.key,
    required this.label,
    this.date,
    this.textValue,
    this.icon,
    this.dateFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.theme.textTheme.bodySmall?.copyWith(
            color: AppColors.labelSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppDimens.h4),
        Row(
          children: [
            Icon(
              icon ?? PhosphorIcons.calendarBlank,
              size: AppDimens.w14,
              color: AppColors.labelPrimary,
            ),
            SizedBox(width: AppDimens.w6),
            Text(
              date != null ? _formatDate(date!) : (textValue ?? '-'),
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.labelPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    if (dateFormatter != null) return dateFormatter!(dt);
    return dt.format(pattern: 'dd MMMM yyyy');
  }
}
