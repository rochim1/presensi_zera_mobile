import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

class TeamSummaryCards extends StatelessWidget {
  final KpiTeamSummary summary;

  const TeamSummaryCards({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GridView.count(
        crossAxisCount: constraints.maxWidth >= 600 ? 4 : 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: constraints.maxWidth >= 600 ? 1.8 : 1.5,
        children: [
          _buildCard(
            context,
            'Total Anggota',
            summary.totalKaryawan?.toString() ?? '0',
            AppColors.primary,
          ),
          _buildCard(
            context,
            'Rata-rata Skor',
            summary.avgScore?.toStringAsFixed(1) ?? '0.0',
            AppColors.orange,
          ),
          _buildCard(
            context,
            'Menunggu Review',
            summary.inProgress?.toString() ?? '0',
            Colors.blue,
          ),
          _buildCard(
            context,
            'Selesai',
            summary.completed?.toString() ?? '0',
            AppColors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: context.textStyle.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: context.textStyle.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
