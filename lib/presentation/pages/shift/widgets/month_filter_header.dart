import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/core/_core.dart';

class MonthFilterHeader extends StatelessWidget {
  final DateTime currentMonth;
  final ValueChanged<DateTime> onMonthChanged;

  const MonthFilterHeader({
    super.key,
    required this.currentMonth,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.h16),
      padding: EdgeInsets.symmetric(horizontal: AppDimens.w16, vertical: AppDimens.h8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              final newMonth = DateTime(currentMonth.year, currentMonth.month - 1);
              onMonthChanged(newMonth);
            },
            icon: const Icon(Icons.chevron_left, color: AppColors.labelPrimary),
          ),
          Text(
            DateFormat('MMMM yyyy', 'id_ID').format(currentMonth),
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              final newMonth = DateTime(currentMonth.year, currentMonth.month + 1);
              onMonthChanged(newMonth);
            },
            icon: const Icon(Icons.chevron_right, color: AppColors.labelPrimary),
          ),
        ],
      ),
    );
  }
}
