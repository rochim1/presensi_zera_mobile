import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_domain/src/entities/sales_target/sales_target.dart';
import 'package:presensi_mobile/core/_core.dart';

class SalesTargetDailyBreakdownList extends StatelessWidget {
  final List<DailyBreakdownEntity> breakdown;

  const SalesTargetDailyBreakdownList({
    super.key,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    if (breakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Detail Harian',
          style: context.textStyle.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.labelPrimary,
          ),
        ),
        const SizedBox(height: AppDimens.paddingMedium),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: breakdown.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppDimens.paddingSmall),
          itemBuilder: (context, index) {
            final day = breakdown[index];
            return _buildDayCard(context, day);
          },
        ),
      ],
    );
  }

  Widget _buildDayCard(BuildContext context, DailyBreakdownEntity day) {
    final isToday = day.date.year == DateTime.now().year &&
        day.date.month == DateTime.now().month &&
        day.date.day == DateTime.now().day;

    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingMedium),
      decoration: BoxDecoration(
        color: day.isWorkingDay ? (isToday ? AppColors.primary.withValues(alpha: 0.05) : AppColors.white) : AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(
          color: isToday ? AppColors.primary.withValues(alpha: 0.3) : AppColors.borderGrey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(day.date),
                style: context.textStyle.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: !day.isWorkingDay ? AppColors.labelSecondary : (isToday ? AppColors.primary : AppColors.labelPrimary),
                ),
              ),
              if (!day.isWorkingDay)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.grey[200]!,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Libur',
                    style: context.textStyle.labelSmall?.copyWith(color: AppColors.labelSecondary),
                  ),
                )
            ],
          ),
          if (day.isWorkingDay) ...[
            const SizedBox(height: AppDimens.paddingSmall),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildMetric(context, 'Omzet', _formatCurrency(day.achievement), _formatCurrency(day.dailyTargetSales)),
                ),
                Expanded(
                  flex: 2,
                  child: _buildMetric(context, 'Call', day.actualCall.toString(), day.dailyTargetCall.toString()),
                ),
                Expanded(
                  flex: 2,
                  child: _buildMetric(context, 'EC', day.actualEc.toString(), day.dailyTargetEc.toString()),
                ),
                Expanded(
                  flex: 2,
                  child: _buildMetric(context, 'NOO', day.actualNoo.toString(), day.dailyTargetNoo.toString()),
                ),
              ],
            ),
          ] else if (day.reason.isNotEmpty) ...[
            const SizedBox(height: AppDimens.paddingSmall),
            Text(
              day.reason,
              style: context.textStyle.bodySmall?.copyWith(color: AppColors.labelSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetric(BuildContext context, String label, String actual, String target) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyle.labelSmall?.copyWith(color: AppColors.labelSecondary),
        ),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            style: context.textStyle.bodySmall?.copyWith(color: AppColors.labelPrimary),
            children: [
              TextSpan(
                text: actual,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: ' / '),
              TextSpan(
                text: target,
                style: TextStyle(color: AppColors.labelSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}k';
    }
    return amount.toStringAsFixed(0);
  }
}
