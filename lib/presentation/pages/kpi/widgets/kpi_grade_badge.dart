import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class KpiGradeBadge extends StatelessWidget {
  final String? grade;
  const KpiGradeBadge({super.key, this.grade});

  @override
  Widget build(BuildContext context) {
    if (grade == null || grade!.isEmpty) return const SizedBox.shrink();

    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: Text(
        grade!,
        style: context.textStyle.titleMedium?.copyWith(
          color: AppColors.labelPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
