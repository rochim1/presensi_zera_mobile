import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class AttendanceCard extends StatelessWidget {
  final Attendance? attendance;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool showUser;
  final int? index;

  const AttendanceCard({
    super.key,
    required Attendance this.attendance,
    this.onTap,
    this.showUser = true,
    this.index,
  }) : isLoading = false;

  const AttendanceCard.shimmer({super.key})
    : attendance = null,
      isLoading = true,
      onTap = null,
      showUser = true,
      index = null;

  bool get _isToday => attendance?.date?.isToday ?? false;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildShimmer(context);
    if (attendance == null) return const SizedBox.shrink();
    return _buildCard(context, attendance!);
  }

  Widget _buildCard(BuildContext context, Attendance attendance) {
    bool isLate() {
      final activities = attendance.activities;
      if (activities.isEmpty) return false;
      return activities.first.isLate;
    }

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.dividerLight.withValues(alpha: 1)),
        borderRadius: BorderRadius.circular(AppDimens.r16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.h16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, attendance, isLate()),
              const SizedBox(height: 12),
              if (showUser && attendance.user != null) ...[
                const Divider(height: 1, color: AppColors.dividerLight),
                const SizedBox(height: 12),
                AppUserInfoTile(user: attendance.user),
                const SizedBox(height: 12),
              ],
              const Divider(height: 1, color: AppColors.dividerLight),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeSection(
                      context,
                      label: 'Masuk',
                      value:
                          attendance.jamMasuk?.format(pattern: 'HH:mm') ??
                          '--:--',
                      icon: PhosphorIcons.signIn,
                      iconColor: AppColors.labelSecondary,
                    ),
                  ),
                  Container(
                    height: 28,
                    width: 1,
                    color: AppColors.dividerLight,
                  ),
                  SizedBox(width: AppDimens.w16),
                  Expanded(
                    child: _buildTimeSection(
                      context,
                      label: 'Pulang',
                      value:
                          attendance.jamPulang?.format(pattern: 'HH:mm') ??
                          '--:--',
                      icon: PhosphorIcons.signOut,
                      iconColor: AppColors.labelSecondary,
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

  Widget _buildTimeSection(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        SizedBox(width: AppDimens.w12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.labelSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.labelPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Attendance attendance,
    bool isLate,
  ) {
    return Row(
      children: [
        const Icon(
          PhosphorIcons.calendarBlank,
          size: 18,
          color: AppColors.labelSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            '${attendance.date?.format(pattern: 'EE, dd MMM yyyy') ?? '-'}${_isToday ? " (Hari Ini)" : ""}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 2,
          child: Text(
            [attendance.type.toName, if (isLate) 'Terlambat'].join(' · '),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: AppColors.labelSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.chevron_right,
          size: 18,
          color: AppColors.labelSecondary,
        ),
      ],
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.dividerLight.withValues(alpha: 1)),
        borderRadius: BorderRadius.circular(AppDimens.r16),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimens.h16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  PhosphorIcons.calendarBlank,
                  size: 18,
                  color: AppColors.dividerLight,
                ),
                SizedBox(width: AppDimens.w8),
                AppShimmer.box(width: 140, height: 16, radius: 4),
              ],
            ),
            const SizedBox(height: 12),
            if (showUser) ...[
              const Divider(height: 1, color: AppColors.dividerLight),
              const SizedBox(height: 12),
              const AppUserInfoTile(isLoading: true),
              const SizedBox(height: 12),
            ],
            const Divider(height: 1, color: AppColors.dividerLight),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.dividerLight.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: AppDimens.w12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppShimmer.box(width: 50, height: 10, radius: 2),
                          const SizedBox(height: 4),
                          AppShimmer.box(width: 40, height: 16, radius: 4),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(height: 28, width: 1, color: AppColors.dividerLight),
                SizedBox(width: AppDimens.w16),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.dividerLight.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: AppDimens.w12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppShimmer.box(width: 50, height: 10, radius: 2),
                          const SizedBox(height: 4),
                          AppShimmer.box(width: 40, height: 16, radius: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
