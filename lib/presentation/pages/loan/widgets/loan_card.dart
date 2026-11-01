import 'package:presensi_mobile/presentation/widgets/app_chip.dart';
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
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
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
                const SizedBox(width: 8),
                Flexible(
                  child: AppChip(
                    label: item.approvalStatus?.toUpperCase() ?? 'PENDING',
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.labelSecondary,
                ),
              ],
            ),
            const Divider(height: 25, color: AppColors.divider),
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
}
