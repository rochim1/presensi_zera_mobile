import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import 'bloc/payroll_detail_state.dart';

@RoutePage()
class PayrollDetailPage extends StatelessWidget {
  final String slipId;

  const PayrollDetailPage({super.key, required this.slipId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PayrollDetailCubit>()..init(slipId),
      child: const PayrollDetailView(),
    );
  }
}

class PayrollDetailView extends StatelessWidget {
  const PayrollDetailView({super.key});

  String _formatCurrency(num value) => NumberFormat.simpleCurrency(
    locale: 'id',
    decimalDigits: 0,
    name: "Rp",
  ).format(value);

  String _periodLabel(PayrollSlip slip) {
    if (slip.month != null &&
        slip.year != null &&
        slip.month! >= 1 &&
        slip.month! <= 12) {
      return DateTime(slip.year!, slip.month!, 1).format(pattern: 'MMMM yyyy');
    }

    if (slip.period != null && slip.period!.isNotEmpty) {
      return slip.period!;
    }

    return '-';
  }

  String _failureMessage(Failure? failure) {
    if (failure == null) return FAILURE_UNKNOWN;
    if (failure.message.isNotEmpty) return failure.message;
    return FAILURE_UNKNOWN;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PayrollDetailCubit, PayrollDetailState>(
      listenWhen: (previous, current) =>
          previous.downloadSlipPdf != current.downloadSlipPdf,
      listener: (context, state) {
        state.downloadSlipPdf.whenOrNull(
          success: (savedPath) async {
            context.read<PayrollDetailCubit>().clearDownloadSlipPdfState();
            final file = File(savedPath);
            if (!await file.exists()) {
              if (context.mounted) {
                AppSnackbar.showError(context, 'File PDF tidak ditemukan');
              }
              return;
            }
            if (!context.mounted) return;
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PayrollPdfViewerPage(file: file),
              ),
            );
          },
          failure: (failure) {
            AppSnackbar.showError(context, _failureMessage(failure));
            context.read<PayrollDetailCubit>().clearDownloadSlipPdfState();
          },
        );
      },
      builder: (context, state) {
        final cubit = context.read<PayrollDetailCubit>();

        return Scaffold(
          appBar: AppTopBar(
            title: 'Detail Slip Gaji',
            backgroundColor: AppColors.transparent,
          ),
          body: _buildBody(context, state, cubit),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    PayrollDetailState state,
    PayrollDetailCubit cubit,
  ) {
    if (state.payrollSlip.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.payrollSlip.isError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w24),
          child: AppErrorView(
            failure: state.payrollSlip.failure ?? const UnknownFailure(),
            onRetry: () => cubit.getPayrollSlipById(),
          ),
        ),
      );
    }

    final slip = state.payrollSlip.maybeWhen(
      orElse: () => null,
      success: (v) => v,
    );
    if (slip == null) {
      return const Center(child: AppErrorView(failure: NotFoundFailure()));
    }

    return AppSmartRefresher(
      onRefresh: () async => cubit.onRefresh(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimens.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppDimens.h16,
          children: [
            _SummaryHeaderCard(
              employeeName: slip.user?.name ?? '-',
              employeeEmail: slip.user?.email ?? '-',
              employeeDepartment: slip.user?.departmentName ?? '-',
              employeePosition: slip.user?.positionName ?? '-',
              periodLabel: _periodLabel(slip),
              statusLabel: slip.status.toDisplayName,
              statusColor: slip.status.toDisplayColor,
            ),
            AppButtonNew(
              text: 'Unduh Slip PDF',
              onPressed: cubit.downloadPayrollSlipPdf,
              isLoading: state.downloadSlipPdf.isLoading,
            ),
            if (slip.attendance != null)
              _SectionCard(
                icon: PhosphorIcons.calendarCheck,
                title: 'Ringkasan Kehadiran',
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'Hari Kerja',
                      value: '${slip.attendance!.totalHariKerja}',
                    ),
                    _InfoRow(
                      label: 'Hadir',
                      value: '${slip.attendance!.totalHadir}',
                    ),
                    _InfoRow(
                      label: 'Izin',
                      value: '${slip.attendance!.totalIzin}',
                    ),
                    _InfoRow(
                      label: 'Cuti',
                      value: '${slip.attendance!.totalCuti}',
                    ),
                    _InfoRow(
                      label: 'Alpha',
                      value: '${slip.attendance!.totalAlpha}',
                    ),
                    _InfoRow(
                      label: 'Terlambat',
                      value:
                          '${slip.attendance!.totalTerlambat} (${slip.attendance!.totalMenitTerlambat} menit)',
                    ),
                    _InfoRow(
                      label: 'Pulang Awal',
                      value: '${slip.attendance!.totalPulangAwal}',
                    ),
                    _InfoRow(
                      label: 'Lupa Presensi',
                      value: '${slip.attendance!.totalLupaPresensi}',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            _SectionCard(
              icon: PhosphorIcons.trendUp,
              title: 'Pendapatan',
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Gaji Pokok',
                    value: _formatCurrency(slip.baseSalary),
                  ),
                  _InfoRow(
                    label: 'Total Tunjangan',
                    value: _formatCurrency(slip.totalAllowance),
                  ),
                  _InfoRow(
                    label: 'Total Lembur',
                    value: _formatCurrency(slip.totalOvertime),
                  ),
                  _InfoRow(
                    label: 'Total Insentif',
                    value: _formatCurrency(slip.totalIncentive),
                  ),
                  _InfoRow(
                    label: 'Adjustment (+)',
                    value: _formatCurrency(slip.totalIncomeAdjustment),
                  ),
                  _InfoRow(
                    label: 'Total Pendapatan',
                    value: _formatCurrency(slip.totalIncome),
                    isLast: true,
                    valueColor: AppColors.green,
                    isBold: true,
                  ),
                ],
              ),
            ),
            _SectionCard(
              icon: PhosphorIcons.trendDown,
              title: 'Potongan',
              child: Column(
                children: [
                  _InfoRow(
                    label: 'BPJS Kesehatan',
                    value: _formatCurrency(slip.deductions?.bpjsKesehatan ?? 0),
                  ),
                  _InfoRow(
                    label: 'BPJS JHT',
                    value: _formatCurrency(
                      slip.deductions?.bpjsKetenagakerjaanJht ?? 0,
                    ),
                  ),
                  _InfoRow(
                    label: 'BPJS JP',
                    value: _formatCurrency(
                      slip.deductions?.bpjsKetenagakerjaanJp ?? 0,
                    ),
                  ),
                  _InfoRow(
                    label: 'PPh 21',
                    value: _formatCurrency(slip.deductions?.pajakPph21 ?? 0),
                  ),
                  _InfoRow(
                    label: 'Punishment Terlambat',
                    value: _formatCurrency(
                      slip.deductions?.punishmentKeterlambatan ?? 0,
                    ),
                  ),
                  _InfoRow(
                    label: 'Punishment Absen',
                    value: _formatCurrency(
                      slip.deductions?.punishmentAbsenTanpaIjin ?? 0,
                    ),
                  ),
                  _InfoRow(
                    label: 'Punishment Pulang Awal',
                    value: _formatCurrency(
                      slip.deductions?.punishmentPulangAwal ?? 0,
                    ),
                  ),
                  _InfoRow(
                    label: 'Punishment Lupa Presensi',
                    value: _formatCurrency(
                      slip.deductions?.punishmentLupaPresensi ?? 0,
                    ),
                  ),
                  _InfoRow(
                    label: 'Adjustment (-)',
                    value: _formatCurrency(slip.totalDeductionAdjustment),
                  ),
                  _InfoRow(
                    label: 'Total Potongan',
                    value: _formatCurrency(slip.totalDeduction),
                    isLast: true,
                    valueColor: AppColors.danger,
                    isBold: true,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppDimens.w16),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimens.r16),
              ),
              child: Column(
                spacing: AppDimens.h4,
                children: [
                  Text(
                    'Gaji Bersih (Take Home Pay)',
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.labelSecondary,
                    ),
                  ),
                  Text(
                    _formatCurrency(slip.netSalary),
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if ((slip.notes?.isNotEmpty ?? false) ||
                (slip.cancelReason?.isNotEmpty ?? false))
              _SectionCard(
                icon: PhosphorIcons.notePencil,
                title: 'Catatan',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppDimens.h10,
                  children: [
                    if (slip.notes?.isNotEmpty ?? false)
                      Text(
                        slip.notes!,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.labelPrimary,
                        ),
                      ),
                    if (slip.cancelReason?.isNotEmpty ?? false)
                      Text(
                        'Alasan Pembatalan: ${slip.cancelReason!}',
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.danger,
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
}

class _SummaryHeaderCard extends StatelessWidget {
  final String employeeName;
  final String employeeEmail;
  final String employeeDepartment;
  final String employeePosition;
  final String periodLabel;
  final String statusLabel;
  final Color statusColor;

  const _SummaryHeaderCard({
    required this.employeeName,
    required this.employeeEmail,
    required this.employeeDepartment,
    required this.employeePosition,
    required this.periodLabel,
    required this.statusLabel,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.w16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppDimens.h10,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  employeeName,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.labelPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AppChip(label: statusLabel, color: statusColor),
            ],
          ),
          _MiniText(text: employeeEmail),
          _MiniText(text: '$employeePosition • $employeeDepartment'),
          _MiniText(text: 'Periode: $periodLabel', isBold: true),
        ],
      ),
    );
  }
}

class _MiniText extends StatelessWidget {
  final String text;
  final bool isBold;

  const _MiniText({required this.text, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.theme.textTheme.bodySmall?.copyWith(
        color: AppColors.labelSecondary,
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.w16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppDimens.w18, color: AppColors.primary),
              SizedBox(width: AppDimens.w8),
              Text(
                title,
                style: context.theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.labelPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.h12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final bool isBold;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppDimens.h8),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: AppColors.dividerLight)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.labelSecondary,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: AppDimens.w12),
          Text(
            value,
            textAlign: TextAlign.right,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: valueColor ?? AppColors.labelPrimary,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
