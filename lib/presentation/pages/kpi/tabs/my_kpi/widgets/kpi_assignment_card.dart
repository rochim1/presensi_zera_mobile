import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import '../../../widgets/_widgets.dart';

class KpiAssignmentCard extends StatelessWidget {
  final KpiAssignment assignment;
  final VoidCallback? onSelfAssessment;
  final VoidCallback? onAcknowledge;
  final VoidCallback? onDetail;

  const KpiAssignmentCard({
    super.key,
    required this.assignment,
    this.onSelfAssessment,
    this.onAcknowledge,
    this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    final status = assignment.status ?? '';
    final canSelfAssess =
        const {'draft', 'data_collection', 'self_review'}.contains(status) &&
        assignment.template?.allowSelfAssessment != false;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    assignment.periodeLabel ?? '-',
                    style: context.textStyle.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                KpiStatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              assignment.template?.namaTemplate ?? '-',
              style: context.textStyle.bodyMedium?.copyWith(
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Final Score', style: context.textStyle.bodySmall),
                      const SizedBox(height: 4),
                      KpiScoreDisplay(score: assignment.finalScore),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Grade', style: context.textStyle.bodySmall),
                      const SizedBox(height: 4),
                      KpiGradeBadge(grade: assignment.finalGrade),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (canSelfAssess)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSelfAssessment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Self Assessment'),
                ),
              )
            else if (status == 'completed')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDetail,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Detail'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAcknowledge,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Acknowledge'),
                    ),
                  ),
                ],
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
