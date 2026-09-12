import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class KpiGradeBadge extends StatelessWidget {
  final String? grade;
  const KpiGradeBadge({super.key, this.grade});

  @override
  Widget build(BuildContext context) {
    if (grade == null || grade!.isEmpty) return const SizedBox.shrink();

    Color color;
    if (grade!.startsWith('A')) {
      color = AppColors.green;
    } else if (grade!.startsWith('B')) {
      color = Colors.blue;
    } else if (grade!.startsWith('C')) {
      color = AppColors.orange;
    } else {
      color = AppColors.red;
    }

    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        grade!,
        style: context.textStyle.titleMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
