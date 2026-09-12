import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

class ConsignmentResume extends StatefulWidget {
  final TasksEntity? tasks;
  final DateTime dateFilter;

  const ConsignmentResume({
    super.key,
    required this.tasks,
    required this.dateFilter,
  });

  @override
  State<ConsignmentResume> createState() => _ConsignmentResumeState();
}

class _ConsignmentResumeState extends State<ConsignmentResume> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        widget.dateFilter.year == now.year &&
        widget.dateFilter.month == now.month &&
        widget.dateFilter.day == now.day;

    return Container(
      padding: const EdgeInsets.all(
        AppDimens.paddingMediumX,
      ).copyWith(bottom: AppDimens.paddingLargeX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rangkuman Perjalanan',
                        style: context.textStyle.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppDimens.size2S.hSpace,
                      Text(
                        "${widget.dateFilter.toEEEdMMMy}${isToday ? ' (Hari Ini)' : ''}",
                        style: context.textStyle.bodyMedium?.copyWith(
                          color: AppColors.labelSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDimens.size3M.hSpace,
                // Divider
                Container(height: 1, color: AppColors.primary.withValues(alpha: 0.2)),
                AppDimens.size3M.hSpace,
                // detail section
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildDetailRow(
                            context,
                            'Total Waktu Istirahat',
                            widget.tasks?.totalWaktuIstirahat?.toTimeMinute?.isEmptyStrip ?? '-',
                            Icons.coffee_rounded,
                          ),
                        ),
                        const SizedBox(width: AppDimens.paddingMedium),
                        Expanded(
                          child: _buildDetailRow(
                            context,
                            'Total Waktu Realita',
                            widget.tasks?.totalWaktuTempuh?.toTimeSecond?.isEmptyStrip ?? '-',
                            Icons.timer,
                          ),
                        ),
                      ],
                    ),
                    AppDimens.paddingMedium.hSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildDetailRow(
                            context,
                            'Total Waktu Estimasi',
                            widget.tasks?.totalWaktuGmaps?.toTimeSecond?.isEmptyStrip ?? '-',
                            Icons.schedule,
                          ),
                        ),
                        const SizedBox(width: AppDimens.paddingMedium),
                        Expanded(
                          child: _buildDetailRow(
                            context,
                            'Total Jarak Estimasi',
                            widget.tasks?.countJarakFromAttendance?.toKilometer?.isEmptyStrip ??
                                '-',
                            Icons.route,
                          ),
                        ),
                      ],
                    ),
                    AppDimens.paddingMedium.hSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildDetailRow(
                            context,
                            'Total Biaya Estimasi',
                            widget.tasks?.biayaActually?.toCurrency.isEmptyStrip ?? '-',
                            Icons.attach_money_outlined,
                          ),
                        ),
                        const SizedBox(width: AppDimens.paddingMedium),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    int maxLines = 2,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: AppDimens.paddingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyle.bodySmall?.copyWith(
                  color: AppColors.labelSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: context.textStyle.bodyMedium?.copyWith(
                  color: AppColors.labelPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
