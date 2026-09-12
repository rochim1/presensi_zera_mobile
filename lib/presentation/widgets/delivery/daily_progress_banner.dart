import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/cubits/sales_target/sales_target_cubit.dart';


class DailyProgressBanner extends StatelessWidget {
  const DailyProgressBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesTargetCubit, SalesTargetState>(
      builder: (context, state) {
        if (state is SalesTargetLoaded) {
          final today = DateTime.now();
          // Find today's breakdown
          final todayBreakdown = state.target.dailyBreakdown.where((element) => 
            element.date.year == today.year && 
            element.date.month == today.month && 
            element.date.day == today.day
          ).firstOrNull;

          if (todayBreakdown == null || !todayBreakdown.isWorkingDay) {
            return const SizedBox.shrink();
          }

          return Container(
            margin: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
            padding: const EdgeInsets.all(AppDimens.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bar_chart, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Progress Hari Ini',
                      style: context.textStyle.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Omzet: ${_formatCurrency(todayBreakdown.achievement)}',
                      style: context.textStyle.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.labelPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMiniProgress(context, 'Call', todayBreakdown.actualCall, todayBreakdown.dailyTargetCall, AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMiniProgress(context, 'EC', todayBreakdown.actualEc, todayBreakdown.dailyTargetEc, const Color(0xFF10B981)), // Emerald
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMiniProgress(context, 'NOO', todayBreakdown.actualNoo, todayBreakdown.dailyTargetNoo, const Color(0xFF8B5CF6)), // Purple
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMiniProgress(BuildContext context, String label, int actual, int target, Color color) {
    final double percent = target > 0 ? (actual / target).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: context.textStyle.labelSmall?.copyWith(color: AppColors.labelSecondary)),
            Text('$actual/$target', style: context.textStyle.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.labelPrimary)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: color.withValues(alpha: 0.1),
          color: color,
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
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
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(amount);
  }
}
