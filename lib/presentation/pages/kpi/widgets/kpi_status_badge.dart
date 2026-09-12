import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class KpiStatusBadge extends StatelessWidget {
  final String status;
  const KpiStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (status) {
      case 'draft':
        label = 'Siap Dinilai';
        color = Colors.grey;
        break;
      case 'data_collection':
        label = 'Pengumpulan Data';
        color = Colors.grey;
        break;
      case 'self_review':
        label = 'Self Assessment';
        color = AppColors.orange;
        break;
      case 'manager_review':
        label = 'Menunggu Review';
        color = Colors.blue;
        break;
      case 'completed':
        label = 'Menunggu Acknowledge';
        color = AppColors.green;
        break;
      case 'acknowledged':
        label = 'Selesai';
        color = AppColors.green;
        break;
      default:
        label = status;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: context.textStyle.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
