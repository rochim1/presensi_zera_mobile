import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/cubits/sales_target/sales_target_cubit.dart';
import 'package:presensi_mobile/presentation/cubits/task_report/task_report_cubit.dart';
import 'package:presensi_mobile/presentation/widgets/common/month_picker_bottom_sheet.dart';
import 'package:presensi_mobile/presentation/widgets/delivery/sales_target_daily_breakdown_list.dart';
import 'package:presensi_domain/presensi_domain.dart';

@RoutePage()
class SalesDashboardPage extends StatefulWidget {
  const SalesDashboardPage({super.key});

  @override
  State<SalesDashboardPage> createState() => _SalesDashboardPageState();
}

class _SalesDashboardPageState extends State<SalesDashboardPage> {
  DateTime _selectedMonth = DateTime.now();
  late SalesTargetCubit _salesTargetCubit;
  late TaskReportCubit _taskReportCubit;

  @override
  void initState() {
    super.initState();
    _salesTargetCubit = sl<SalesTargetCubit>();
    _taskReportCubit = sl<TaskReportCubit>();
    _loadData();
  }

  void _loadData() {
    final periode = DateFormat('yyyy-MM').format(_selectedMonth);
    _salesTargetCubit.loadMyTarget(periode: periode);
    _taskReportCubit.loadMyReport(periode: periode);
  }

  void _changeMonth(DateTime month) {
    setState(() {
      _selectedMonth = month;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _salesTargetCubit),
        BlocProvider.value(value: _taskReportCubit),
      ],
      child: Scaffold(
        appBar: const AppTopBar(title: 'Performa Sales'),
        body: RefreshIndicator(
          onRefresh: () async {
            _loadData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimens.paddingMediumX),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFilterButton(),
                const SizedBox(height: AppDimens.paddingMediumX),
                _buildSectionTitle(
                  context,
                  'Pencapaian Target (${DateFormat('MMMM yyyy', 'id_ID').format(_selectedMonth)})',
                ),
                const SizedBox(height: AppDimens.paddingMediumX),
                _buildTargetSection(),
                const SizedBox(height: AppDimens.paddingLarge),

                _buildSectionTitle(context, 'Rangkuman Perjalanan'),
                const SizedBox(height: AppDimens.paddingMediumX),
                _buildReportSection(),
                const SizedBox(height: AppDimens.paddingLarge),

                _buildSectionTitle(context, 'Kunjungan Bulan Ini'),
                const SizedBox(height: AppDimens.paddingMediumX),
                _buildMonthlyTasksSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: () {
        MonthPickerBottomSheet.show(
          context,
          initialDate: _selectedMonth,
          onMonthSelected: _changeMonth,
        );
      },
      borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          border: Border.all(color: AppColors.dividerLight),
        ),
        child: Row(
          children: [
            Icon(Icons.date_range, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                DateFormat('MMMM yyyy', 'id_ID').format(_selectedMonth),
                style: context.textStyle.bodyMedium?.copyWith(
                  color: AppColors.labelPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.labelSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.textStyle.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.labelPrimary,
      ),
    );
  }

  Widget _buildTargetSection() {
    return BlocBuilder<SalesTargetCubit, SalesTargetState>(
      builder: (context, state) {
        if (state is SalesTargetLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is SalesTargetEmpty) {
          return _buildEmptyCard('Belum ada target untuk bulan ini');
        } else if (state is SalesTargetError) {
          return _buildErrorCard(state.message);
        } else if (state is SalesTargetLoaded) {
          final target = state.target;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMainTargetCard(context, target),
              const SizedBox(height: AppDimens.paddingMedium),
              Row(
                children: [
                  Expanded(
                    child: _buildMiniKpiCard(
                      context,
                      'Call',
                      target.actualCall,
                      target.targetCall,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppDimens.paddingMedium),
                  Expanded(
                    child: _buildMiniKpiCard(
                      context,
                      'EC',
                      target.actualEc,
                      target.targetEc,
                      const Color(0xFF10B981),
                    ), // Emerald
                  ),
                  const SizedBox(width: AppDimens.paddingMedium),
                  Expanded(
                    child: _buildMiniKpiCard(
                      context,
                      'NOO',
                      target.actualNoo,
                      target.targetNoo,
                      const Color(0xFF8B5CF6),
                    ), // Purple
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.paddingLarge),
              SalesTargetDailyBreakdownList(breakdown: target.dailyBreakdown),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMainTargetCard(BuildContext context, SalesTargetEntity target) {
    final percent = target.targetSales > 0
        ? (target.achievement / target.targetSales)
        : 0.0;
    final isSuccess = percent >= 1.0;

    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
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
              Text(
                'Omzet',
                style: context.textStyle.titleMedium?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getRunRateText(target.runRate),
                  style: context.textStyle.labelSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.paddingMedium),
          Text(
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(target.achievement),
            style: context.textStyle.headlineMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'dari ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(target.targetSales)}',
            style: context.textStyle.bodyMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: AppDimens.paddingLarge),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 8,
                    backgroundColor: AppColors.white.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isSuccess ? const Color(0xFF10B981) : AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(percent * 100).toStringAsFixed(1)}%',
                style: context.textStyle.labelLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRunRateText(String runRate) {
    if (runRate == 'ahead') return 'Ahead';
    if (runRate == 'behind') return 'Behind';
    return 'On Track';
  }

  Widget _buildMiniKpiCard(
    BuildContext context,
    String title,
    int actual,
    int target,
    Color color,
  ) {
    final double percent = target > 0 ? (actual / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textStyle.labelSmall?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: context.textStyle.titleMedium?.copyWith(
                color: AppColors.labelPrimary,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: '$actual'),
                TextSpan(
                  text: '/$target',
                  style: context.textStyle.bodySmall?.copyWith(
                    color: AppColors.labelSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            minHeight: 4,
            backgroundColor: color.withValues(alpha: 0.1),
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildReportSection() {
    return BlocBuilder<TaskReportCubit, TaskReportState>(
      builder: (context, state) {
        if (state is TaskReportLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is TaskReportEmpty) {
          return _buildEmptyCard('Belum ada data perjalanan');
        } else if (state is TaskReportError) {
          return _buildErrorCard(state.message);
        } else if (state is TaskReportLoaded) {
          final summary = state.summary;
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildReportCard(
                      context,
                      title: 'Estimasi Biaya Transportasi',
                      value: NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(summary.totalCost),
                      icon: Icons.local_gas_station,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: AppDimens.paddingMedium),
                  Expanded(
                    child: _buildReportCard(
                      context,
                      title: 'Total Jarak',
                      value:
                          '${summary.totalDistanceFinal.toStringAsFixed(1)} km',
                      icon: Icons.route,
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: context.textStyle.labelSmall?.copyWith(
                    color: AppColors.labelSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: context.textStyle.titleMedium?.copyWith(
              color: AppColors.labelPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTasksSection() {
    return BlocBuilder<TaskReportCubit, TaskReportState>(
      builder: (context, state) {
        if (state is TaskReportLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is TaskReportEmpty) {
          return _buildEmptyCard('Belum ada data kunjungan bulan ini');
        } else if (state is TaskReportError) {
          return _buildErrorCard(state.message);
        } else if (state is TaskReportLoaded) {
          final summary = state.summary;
          final totalCount = summary.totalTasks;
          final successCount = summary.totalTasksDone;
          final pendingCount = summary.totalTasksPending;
          final canceledCount = summary.totalTasksCancel;

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Total',
                      value: totalCount.toString(),
                      icon: Icons.map_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppDimens.paddingMediumX),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Selesai',
                      value: successCount.toString(),
                      icon: Icons.check_circle_outline,
                      color: const Color(0xFF10B981), // Emerald
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.paddingMediumX),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Pending',
                      value: pendingCount.toString(),
                      icon: Icons.pending_actions,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: AppDimens.paddingMediumX),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Batal',
                      value: canceledCount.toString(),
                      icon: Icons.cancel_outlined,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingMediumX),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
        boxShadow: [
          BoxShadow(
            color: AppColors.labelSecondary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.paddingMediumX),
          Text(
            value,
            style: context.textStyle.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.labelPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: context.textStyle.bodySmall?.copyWith(
              color: AppColors.labelSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(color: AppColors.borderGrey),
      ),
      alignment: Alignment.center,
      child: Text(
        message,
        style: context.textStyle.bodyMedium?.copyWith(
          color: AppColors.labelSecondary,
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      alignment: Alignment.center,
      child: Text(
        'Gagal memuat data:\n$message',
        textAlign: TextAlign.center,
        style: context.textStyle.bodySmall?.copyWith(color: Colors.red),
      ),
    );
  }
}
