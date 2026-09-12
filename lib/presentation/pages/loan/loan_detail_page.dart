import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

@RoutePage()
class LoanDetailPage extends StatelessWidget {
  final EmployeeLoan loan;

  const LoanDetailPage({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Detail Pinjaman',
        showBackButton: true,
        onBackTap: () => context.router.maybePop(),
        backgroundColor: AppColors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimens.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildDetailCard(context)],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.w16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nomor Pinjaman: ${loan.loanNumber ?? '-'}',
            style: context.textStyle.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppDimens.h16.hSpace,
          _buildRow(context, 'Tipe Pinjaman', loan.loanTypeLabel ?? '-'),
          _buildRow(context, 'Nominal', _currency(loan.principalAmount)),
          _buildRow(
            context,
            'Sisa Pinjaman',
            _currency(loan.outstandingBalance),
          ),
          if ((loan.monthlyPayment ?? 0) > 0)
            _buildRow(context, 'Cicilan/Bulan', _currency(loan.monthlyPayment)),
          _buildRow(context, 'Tenor', '${loan.loanTermMonths ?? 0} Bulan'),
          _buildRow(context, 'Tujuan', loan.purpose ?? '-'),
          _buildRow(context, 'Status', loan.approvalStatus ?? 'PENDING'),
          if (loan.createdAt != null)
            _buildRow(
              context,
              'Tanggal Pengajuan',
              DateFormat('dd MMM yyyy').format(loan.createdAt!),
            ),
          if ((loan.rejectedReason ?? '').isNotEmpty)
            _buildRow(context, 'Alasan Ditolak', loan.rejectedReason!),
          if ((loan.paymentSchedule ?? []).isNotEmpty) ...[
            AppDimens.h16.hSpace,
            Text(
              'Jadwal Cicilan',
              style: context.textStyle.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDimens.h8.hSpace,
            ...loan.paymentSchedule!.map(
              (schedule) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Cicilan ke-${schedule.period ?? '-'}'),
                subtitle: Text(
                  schedule.dueDate == null
                      ? '-'
                      : 'Jatuh tempo ${DateFormat('dd MMM yyyy').format(schedule.dueDate!)}',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_currency(schedule.total)),
                    Text(
                      _scheduleStatus(schedule.status),
                      style: context.textStyle.bodySmall?.copyWith(
                        color: _scheduleColor(schedule.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.h8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: context.textStyle.bodyMedium?.copyWith(
                color: AppColors.labelSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: context.textStyle.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _currency(double? amount) => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(amount ?? 0);

  String _scheduleStatus(String? status) {
    switch (status) {
      case 'paid':
        return 'Lunas';
      case 'overdue':
        return 'Terlambat';
      default:
        return 'Akan datang';
    }
  }

  Color _scheduleColor(String? status) {
    switch (status) {
      case 'paid':
        return AppColors.green;
      case 'overdue':
        return AppColors.red;
      default:
        return AppColors.orange;
    }
  }
}
