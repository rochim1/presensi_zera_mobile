import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../bloc/attendance_state.dart';

class AttendanceStatsCard extends StatefulWidget {
  const AttendanceStatsCard({super.key});

  @override
  State<AttendanceStatsCard> createState() => _AttendanceStatsCardState();
}

class _AttendanceStatsCardState extends State<AttendanceStatsCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getTypeLabel(String? type) {
    switch (type) {
      case 'reguler':
        return 'Reguler';
      case 'shift':
        return 'Shift';
      case 'oncall':
        return 'On Call';
      default:
        return type ?? '-';
    }
  }

  Color _getTypeColor(String? type) {
    switch (type) {
      case 'reguler':
        return AppColors.primary;
      case 'shift':
        return const Color(0xFFE67E22);
      case 'oncall':
        return const Color(0xFF8E44AD);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      buildWhen: (prev, curr) => prev.statistics != curr.statistics,
      builder: (context, state) {
        return state.statistics.when(
          initial: () => _buildShimmer(),
          loading: () => _buildShimmer(),
          failure: (failure) => _buildError(failure),
          success: (data) => _buildStats(data),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Ringkasan Kehadiran',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const Spacer(),
              AppShimmer.box(width: 60, height: 20, radius: 10),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return Expanded(
                child: Column(
                  children: [
                    AppShimmer.box(width: 30, height: 22, radius: 4),
                    const SizedBox(height: 6),
                    AppShimmer.box(width: 45, height: 10, radius: 2),
                    const SizedBox(height: 4),
                    AppShimmer.box(width: 30, height: 10, radius: 2),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Center(child: AppShimmer.box(width: 50, height: 6, radius: 3)),
          const SizedBox(height: 16),
          AppShimmer.box(width: double.infinity, height: 38, radius: 12),
        ],
      ),
    );
  }

  Widget _buildError(Failure failure) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          'Gagal memuat statistik',
          style: TextStyle(color: AppColors.labelSecondary, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildStats(List<AttendanceStatistic> stats) {
    if (stats.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ringkasan Kehadiran',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
              // Type badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getTypeColor(
                    stats[_currentPage].typePresensi,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getTypeLabel(stats[_currentPage].typePresensi),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getTypeColor(stats[_currentPage].typePresensi),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // PageView for stats
          SizedBox(
            height: 80,
            child: PageView.builder(
              controller: _pageController,
              itemCount: stats.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final stat = stats[index];
                return _buildStatPage(stat);
              },
            ),
          ),
          const SizedBox(height: 12),

          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(stats.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? _getTypeColor(stats[index].typePresensi)
                      : AppColors.dividerLight,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Konsistensi bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.chartBarFill,
                  size: 18,
                  color: AppColors.labelSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Konsistensi presensi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.labelSecondary,
                    ),
                  ),
                ),
                Text(
                  '${stats[_currentPage].konsistensi.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _getKonsistensiColor(
                      stats[_currentPage].konsistensi,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getKonsistensiColor(double value) {
    if (value >= 80) return const Color(0xFF0F8B6D);
    if (value >= 50) return const Color(0xFFE67E22);
    return const Color(0xFFE74C3C);
  }

  Widget _buildStatPage(AttendanceStatistic stat) {
    final isOncall = stat.typePresensi == 'oncall';

    if (isOncall) {
      // On Call: only show total hadir
      return Row(
        children: [
          _buildStatItem(
            value: stat.totalHadir.toString(),
            label: 'Total Hadir',
            sublabel: '',
          ),
        ],
      );
    }

    final items = <Widget>[
      _buildStatItem(
        value: stat.totalHariKerja.toString(),
        label: 'Hari Kerja',
        sublabel: 'Total',
      ),
      _buildStatItem(
        value: stat.totalHadir.toString(),
        label: 'Hadir',
        sublabel: stat.totalHariKerja > 0
            ? '${((stat.totalHadir / stat.totalHariKerja) * 100).toStringAsFixed(0)}%'
            : '-',
      ),
      _buildStatItem(
        value: stat.totalTerlambat.toString(),
        label: 'Terlambat',
        sublabel: stat.totalHariKerja > 0
            ? '${((stat.totalTerlambat / stat.totalHariKerja) * 100).toStringAsFixed(0)}%'
            : '-',
      ),
      _buildStatItem(
        value: stat.totalTidakHadir.toString(),
        label: 'Tidak Hadir',
        sublabel: stat.totalHariKerja > 0
            ? '${((stat.totalTidakHadir / stat.totalHariKerja) * 100).toStringAsFixed(0)}%'
            : '-',
      ),
      _buildStatItem(
        value: stat.totalCutiIzin.toString(),
        label: 'Cuti / Izin',
        sublabel: stat.totalHariKerja > 0
            ? '${((stat.totalCutiIzin / stat.totalHariKerja) * 100).toStringAsFixed(0)}%'
            : '-',
      ),
    ];

    // Add libur for reguler
    if (stat.typePresensi == 'reguler' && stat.totalLibur > 0) {
      items.add(
        _buildStatItem(
          value: stat.totalLibur.toString(),
          label: 'Libur',
          sublabel: '',
        ),
      );
    }

    return Row(children: items);
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required String sublabel,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.labelSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (sublabel.isNotEmpty)
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.labelSecondary,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
