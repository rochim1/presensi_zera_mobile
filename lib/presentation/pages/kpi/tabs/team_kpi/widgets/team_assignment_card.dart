import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import '../../../widgets/_widgets.dart';

class TeamAssignmentCard extends StatelessWidget {
  final KpiAssignment assignment;
  final VoidCallback? onReview;
  final VoidCallback? onDetail;

  const TeamAssignmentCard({
    super.key,
    required this.assignment,
    this.onReview,
    this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    final status = assignment.status ?? '';
    final userName = assignment.user?.name ?? '';
    final initial = userName.isNotEmpty
        ? userName.substring(0, 1).toUpperCase()
        : 'U';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    initial,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName.isNotEmpty ? userName : '-',
                        style: context.textStyle.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        assignment.user?.divisiName ?? '-',
                        style: context.textStyle.bodySmall?.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                KpiStatusBadge(status: status),
              ],
            ),
            const Divider(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 10,
              alignment: WrapAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 105,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Periode', style: context.textStyle.bodySmall),
                      Text(
                        assignment.periodeLabel ?? '-',
                        style: context.textStyle.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Final Score', style: context.textStyle.bodySmall),
                      KpiScoreDisplay(score: assignment.finalScore),
                    ],
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Grade', style: context.textStyle.bodySmall),
                      KpiGradeBadge(grade: assignment.finalGrade),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (status == 'manager_review')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Review KPI'),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onDetail,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Lihat Detail'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
