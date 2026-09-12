import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:shimmer/shimmer.dart';

class LoanCard extends StatelessWidget {
  final EmployeeLoan item;
  final VoidCallback onTap;

  const LoanCard({super.key, required this.item, required this.onTap});

  const LoanCard.shimmer({super.key})
    : item = const EmployeeLoan(id: ''),
      onTap = _emptyOnTap;

  static void _emptyOnTap() {}

  @override
  Widget build(BuildContext context) {
    if (item.id.isEmpty) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      );
    }

    final statusColor = _getStatusColor(item.approvalStatus);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(AppDimens.w16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.loanTypeLabel ?? 'Pinjaman',
                    style: context.textStyle.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.w8,
                    vertical: AppDimens.h4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    item.approvalStatus?.toUpperCase() ?? 'PENDING',
                    style: context.textStyle.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            AppDimens.h8.hSpace,
            Text(
              'Nominal: Rp ${item.principalAmount?.toStringAsFixed(0) ?? 0}',
              style: context.textStyle.bodyMedium?.copyWith(
                color: AppColors.labelSecondary,
              ),
            ),
            AppDimens.h4.hSpace,
            Text(
              'Tenor: ${item.loanTermMonths ?? 0} Bulan',
              style: context.textStyle.bodyMedium?.copyWith(
                color: AppColors.labelSecondary,
              ),
            ),
            AppDimens.h4.hSpace,
            Text(
              'Tujuan: ${item.purpose ?? '-'}',
              style: context.textStyle.bodySmall?.copyWith(
                color: AppColors.labelTertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'active':
        return Colors.green;
      case 'pending_approval':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'disbursed':
        return Colors.blue;
      case 'completed':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }
}
