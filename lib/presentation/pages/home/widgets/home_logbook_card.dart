import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/pages/logbook/bloc/logbook_cubit.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class HomeLogbookCard extends StatelessWidget {
  const HomeLogbookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogbookCubit, LogbookState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEBEFF3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 14),
              if (state.isLoading)
                _buildLoading()
              else if (state.errorMessage != null)
                _buildError(context)
              else if (state.logbooks.isEmpty)
                _buildEmpty(context)
              else
                _buildContent(context, state.logbooks),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Logbook Hari Ini',
                style: context.textStyle.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.labelPrimary,
                ),
              ),
              Text(
                'Pantau aktivitas pekerjaanmu',
                style: context.textStyle.bodySmall?.copyWith(
                  color: AppColors.labelSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Buka Logbook Harian',
          visualDensity: VisualDensity.compact,
          onPressed: () => context.router.push(const LogbookPageRoute()),
          icon: Icon(
            PhosphorIcons.arrowRight,
            size: 20,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, List<LogbookEntry> entries) {
    final totalMinutes = entries.fold<int>(
      0,
      (total, entry) => total + (entry.durasiMenit ?? 0),
    );
    final visibleEntries = entries.take(3).toList();

    return Column(
      children: [
        Row(
          children: [
            _buildSummary(
              context,
              value: '${entries.length}',
              label: 'Aktivitas',
              icon: PhosphorIcons.listChecks,
            ),
            const SizedBox(width: 8),
            _buildSummary(
              context,
              value: _formatDuration(totalMinutes),
              label: 'Total durasi',
              icon: PhosphorIcons.timer,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFF0F2F5)),
        const SizedBox(height: 5),
        ...visibleEntries.map((entry) => _buildEntry(context, entry)),
        if (entries.length > visibleEntries.length)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: TextButton(
              onPressed: () => context.router.push(const LogbookPageRoute()),
              child: Text(
                'Lihat ${entries.length - visibleEntries.length} aktivitas lainnya',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSummary(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
  }) {
    final accent = AppColors.primary;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFFE3E8ED)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: accent),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.labelSecondary,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntry(BuildContext context, LogbookEntry entry) {
    return InkWell(
      onTap: () => context.router.push(const LogbookPageRoute()),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 76,
              child: Text(
                '${entry.jamMulai ?? '--:--'}–${entry.jamSelesai ?? '--:--'}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelSecondary,
                ),
              ),
            ),
            Expanded(
              child: Text(
                entry.judulTugas,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.bodySmall?.copyWith(
                  color: AppColors.labelPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              PhosphorIcons.caretRight,
              size: 14,
              color: AppColors.labelSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return InkWell(
      onTap: () => context.router.push(const LogbookPageRoute()),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAF9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(PhosphorIcons.plusCircle, color: AppColors.primary, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Belum ada aktivitas',
                    style: context.textStyle.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Tambahkan logbook pekerjaan hari ini',
                    style: context.textStyle.bodySmall?.copyWith(
                      color: AppColors.labelSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(PhosphorIcons.arrowRight, color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Logbook hari ini belum dapat dimuat.',
            style: context.textStyle.bodySmall?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () => context.read<LogbookCubit>().fetchLogbooks(),
          icon: const Icon(Icons.refresh, size: 17),
          label: const Text('Coba Lagi'),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: AppShimmer.box(width: double.infinity, height: 34),
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours == 0) return '${remainingMinutes}m';
    if (remainingMinutes == 0) return '${hours}j';
    return '${hours}j ${remainingMinutes}m';
  }
}
