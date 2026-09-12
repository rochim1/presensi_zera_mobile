import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../bloc/approval_payroll_cubit.dart';
import '../bloc/approval_payroll_state.dart';

@RoutePage()
class ApprovalPayrollPage extends StatelessWidget {
  const ApprovalPayrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ApprovalPayrollCubit>()..load(),
      child: const _ApprovalPayrollView(),
    );
  }
}

class _ApprovalPayrollView extends StatelessWidget {
  const _ApprovalPayrollView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApprovalPayrollCubit, ApprovalPayrollState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) =>
          AppSnackbar.showError(context, state.errorMessage!),
      builder: (context, state) {
        if (state.isLoading && state.approvals.isEmpty)
          return const Center(child: CircularProgressIndicator());
        if (state.errorMessage != null && state.approvals.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppDimens.w24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: context.read<ApprovalPayrollCubit>().load,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state.approvals.isEmpty) {
          return RefreshIndicator(
            onRefresh: context.read<ApprovalPayrollCubit>().load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * .2),
                Icon(
                  PhosphorIcons.checkCircle,
                  size: 56,
                  color: AppColors.primary.withValues(alpha: .35),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text('Tidak ada payroll yang menunggu approval'),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: context.read<ApprovalPayrollCubit>().load,
          child: ListView.separated(
            padding: EdgeInsets.all(AppDimens.w16),
            itemCount: state.approvals.length,
            separatorBuilder: (_, _) => SizedBox(height: AppDimens.h12),
            itemBuilder: (context, index) => _ApprovalCard(
              number: index + 1,
              approval: state.approvals[index],
              submitting: state.isSubmitting,
            ),
          ),
        );
      },
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final int number;
  final ApprovalHistory approval;
  final bool submitting;

  const _ApprovalCard({
    required this.number,
    required this.approval,
    required this.submitting,
  });

  @override
  Widget build(BuildContext context) {
    final batch = approval.payrollBatch;
    final submittedAt = approval.createdAt == null
        ? '-'
        : DateFormat(
            'dd MMM yyyy, HH:mm',
            'id_ID',
          ).format(approval.createdAt!.toLocal());
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.r16),
        side: const BorderSide(color: AppColors.dividerLight),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimens.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withValues(alpha: .1),
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Approval Payroll',
                        style: context.textStyle.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        approval.requester?.name ?? 'Pengaju payroll',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyle.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7E6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Menunggu',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB76E00),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _info('Diajukan', submittedAt),
            _info('Periode', batch?.period ?? '-'),
            _info('Jumlah slip', '${batch?.totalSlips ?? 0} karyawan'),
            _info(
              'Total payroll',
              NumberFormat.simpleCurrency(
                locale: 'id_ID',
                name: 'Rp',
                decimalDigits: 0,
              ).format(batch?.totalAmount ?? 0),
            ),
            _info(
              'Tahap approval',
              '${approval.currentLevel} dari ${approval.totalLevel}',
            ),
            _info('ID batch', approval.requestId ?? '-'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: submitting
                        ? null
                        : () => _confirm(context, approve: false),
                    child: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: submitting
                        ? null
                        : () => _confirm(context, approve: true),
                    child: submitting
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Setujui'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        SizedBox(
          width: 112,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.labelSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );

  Future<void> _confirm(BuildContext context, {required bool approve}) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(approve ? 'Setujui payroll?' : 'Tolak payroll?'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: approve ? 'Catatan (opsional)' : 'Alasan penolakan',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(approve ? 'Setujui' : 'Tolak'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      controller.dispose();
      return;
    }
    if (!approve && controller.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'Alasan penolakan wajib diisi');
      controller.dispose();
      return;
    }
    final success = await context.read<ApprovalPayrollCubit>().process(
      approval: approval,
      action: approve
          ? AttendanceRequestApprovalAction.approve
          : AttendanceRequestApprovalAction.reject,
      reason: controller.text,
    );
    controller.dispose();
    if (success && context.mounted)
      AppSnackbar.showSuccess(
        context,
        approve ? 'Payroll berhasil disetujui' : 'Payroll berhasil ditolak',
      );
  }
}
