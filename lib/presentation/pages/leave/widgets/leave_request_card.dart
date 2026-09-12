import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequest? leaveRequest;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool showUser;

  const LeaveRequestCard({
    super.key,
    required this.leaveRequest,
    this.onTap,
    this.showUser = true,
  }) : isLoading = false;

  const LeaveRequestCard.shimmer({super.key, this.showUser = true})
    : leaveRequest = null,
      onTap = null,
      isLoading = true;

  String _formatDateTime(DateTime dt) =>
      DateFormat('EEEE, dd MMMM yyyy', 'id').format(dt);

  String getDurationLabel(
    DateTime fromDate,
    DateTime toDate, {
    required bool isHalfDay,
  }) {
    if (isHalfDay) return 'Setengah Hari';

    final from = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final to = DateTime(toDate.year, toDate.month, toDate.day);

    final difference = to.difference(from).inDays + 1;
    return '${difference.clamp(1, double.infinity).toInt()} Hari';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppRequestCard.shimmer(showUser: showUser);
    }

    final color = leaveRequest!.status.toDisplayColor;

    if (!showUser) return _buildPersonalLeaveCard(context, color);

    return AppRequestCard(
      user: leaveRequest!.user,
      showUser: showUser,
      statusColor: color,
      statusLabel: leaveRequest!.status.toDisplayName,
      title: leaveRequest!.category?.name ?? 'Kategori tidak diketahui',
      subtitle: leaveRequest!.alasan,
      onTap: onTap,
      middleContent: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTimelineConnector(
              color: color,
              width: AppDimens.w8,
              height: AppDimens.h48,
              isDashed: true,
            ),
            SizedBox(width: AppDimens.w10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppDimens.h10,
                children: [
                  if (leaveRequest!.tanggalIzin != null)
                    AppRequestDateRow(
                      value: _formatDateTime(leaveRequest!.tanggalIzin!),
                    ),
                  if (leaveRequest!.tanggalMasuk != null)
                    AppRequestDateRow(
                      value: _formatDateTime(leaveRequest!.tanggalMasuk!),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
      footer:
          (leaveRequest!.tanggalMasuk != null &&
              leaveRequest!.tanggalIzin != null)
          ? Text(
              getDurationLabel(
                leaveRequest!.tanggalIzin!,
                leaveRequest!.tanggalMasuk!,
                isHalfDay: leaveRequest!.isHalfDay == true,
              ),
              style: context.theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }

  Widget _buildPersonalLeaveCard(BuildContext context, Color statusColor) {
    final request = leaveRequest!;
    final start = request.tanggalIzin;
    final end = request.tanggalMasuk;
    final duration = start != null && end != null
        ? getDurationLabel(start, end, isHalfDay: request.isHalfDay == true)
        : '-';
    final categoryName = request.category?.name ?? 'Kategori tidak diketahui';
    final categoryStyle = _categoryStyle(categoryName);

    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.r16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppDimens.w14),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: AppDimens.w48,
                    height: AppDimens.w48,
                    decoration: BoxDecoration(
                      color: categoryStyle.background,
                      borderRadius: BorderRadius.circular(AppDimens.r12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      categoryStyle.icon,
                      color: categoryStyle.foreground,
                      size: AppDimens.iconMedium,
                    ),
                  ),
                  SizedBox(width: AppDimens.w12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textStyle.titleSmall?.copyWith(
                            color: AppColors.labelPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppDimens.h2),
                        Text(
                          request.alasan.isEmpty ? '-' : request.alasan,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textStyle.bodySmall?.copyWith(
                            color: AppColors.labelSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppDimens.w8),
                  AppChip(
                    label: request.status.toDisplayName,
                    color: statusColor,
                    icon: _statusIcon(request.status),
                    borderRadius: AppDimens.r20,
                    fontSize: 10,
                  ),
                  SizedBox(width: AppDimens.w4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.labelSecondary,
                  ),
                ],
              ),
              SizedBox(height: AppDimens.h12),
              const Divider(height: 1, color: AppColors.divider),
              SizedBox(height: AppDimens.h12),
              Row(
                children: [
                  Expanded(
                    child: _dateItem(
                      context,
                      label: 'Tanggal Mulai',
                      date: start,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: AppDimens.h48,
                    color: AppColors.divider,
                  ),
                  SizedBox(width: AppDimens.w12),
                  Expanded(
                    child: _dateItem(
                      context,
                      label: 'Tanggal Selesai',
                      date: end,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimens.h12),
              const Divider(height: 1, color: AppColors.divider),
              SizedBox(height: AppDimens.h12),
              Row(
                children: [
                  Expanded(
                    child: _metricItem(
                      context,
                      icon: PhosphorIcons.hourglass,
                      label: 'Durasi',
                      value: duration,
                    ),
                  ),
                  Expanded(
                    child: _metricItem(
                      context,
                      icon: PhosphorIcons.briefcase,
                      label: 'Jenis',
                      value: request.isHalfDay == true
                          ? 'Setengah Hari'
                          : 'Sehari Penuh',
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

  Widget _dateItem(
    BuildContext context, {
    required String label,
    DateTime? date,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          PhosphorIcons.calendarBlank,
          color: AppColors.primary,
          size: 20,
        ),
        SizedBox(width: AppDimens.w8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: _smallLabel(context)),
              SizedBox(height: AppDimens.h2),
              Text(
                date == null
                    ? '-'
                    : DateFormat('dd MMM yyyy', 'id').format(date),
                style: context.textStyle.bodySmall?.copyWith(
                  color: AppColors.labelPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (date != null)
                Text(
                  DateFormat('EEEE', 'id').format(date),
                  style: _smallLabel(context),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metricItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        SizedBox(width: AppDimens.w8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: _smallLabel(context)),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.bodySmall?.copyWith(
                  color: AppColors.labelPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle? _smallLabel(BuildContext context) => context.textStyle.bodySmall
      ?.copyWith(color: AppColors.labelSecondary, fontSize: 10);

  IconData _statusIcon(LeaveStatus status) => switch (status) {
    LeaveStatus.diajukan => PhosphorIcons.clock,
    LeaveStatus.diterima => PhosphorIcons.checkCircle,
    LeaveStatus.ditolak => PhosphorIcons.xCircle,
  };

  _LeaveCategoryStyle _categoryStyle(String category) {
    final value = category.toLowerCase();
    if (value.contains('sakit') || value.contains('sick')) {
      return const _LeaveCategoryStyle(
        icon: PhosphorIcons.stethoscope,
        foreground: AppColors.primary,
        background: AppColors.primaryLight,
      );
    }
    if (value.contains('izin') || value.contains('permission')) {
      return const _LeaveCategoryStyle(
        icon: PhosphorIcons.fileText,
        foreground: AppColors.info,
        background: AppColors.infoBackground,
      );
    }
    return const _LeaveCategoryStyle(
      icon: PhosphorIcons.airplaneTilt,
      foreground: AppColors.purple,
      background: AppColors.lightPurple,
    );
  }
}

class _LeaveCategoryStyle {
  final IconData icon;
  final Color foreground;
  final Color background;

  const _LeaveCategoryStyle({
    required this.icon,
    required this.foreground,
    required this.background,
  });
}
