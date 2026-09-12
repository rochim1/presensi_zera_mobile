import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../../bloc/leave_state.dart';
import '../../widgets/_widgets.dart';
import 'bloc/approval_state.dart';

@RoutePage()
class LeaveApprovalPage extends StatelessWidget {
  const LeaveApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<LeaveApprovalCubit>()
            ..onChangeFilterDate(context.read<LeaveCubit>().state.filterDate),
      child: const LeaveApprovalView(),
    );
  }
}

class LeaveApprovalView extends StatelessWidget {
  const LeaveApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LeaveCubit, LeaveState>(
          listenWhen: (previous, current) =>
              previous.filterDate != current.filterDate ||
              previous.refreshCounter != current.refreshCounter,
          listener: (context, state) {
            final cubit = context.read<LeaveApprovalCubit>();
            if (cubit.state.filterDate != state.filterDate) {
              cubit.onChangeFilterDate(state.filterDate);
            } else {
              cubit.getLeaveRequests();
            }
          },
        ),
      ],
      child: BlocBuilder<LeaveApprovalCubit, LeaveApprovalState>(
        builder: (context, state) {
          final cubit = context.read<LeaveApprovalCubit>();

          void onTapLeaveRequestCard(LeaveRequest request) {
            final cubit = context.read<LeaveApprovalCubit>();

            AppBottomSheet.show(
              context: context,
              onClose: () =>
                  cubit.onChangeApprovalAction(LeaveApprovalAction.none),
              title: const _LeaveApprovalDetailTitle(),
              actionsBuilder: request.status == LeaveStatus.diajukan
                  ? (context) => _buildApprovalActions(cubit, request)
                  : null,
              child: LeaveRequestDetailView(request: request),
            );
          }

          return AppInfiniteScrollView<LeaveRequest>(
            onRefresh: cubit.onRefresh,
            state: state.leaveRequests,
            onFetchNext: cubit.fetchNextPage,
            itemBuilder: (context, item) => LeaveRequestCard(
              onTap: () => onTapLeaveRequestCard(item),
              leaveRequest: item,
            ),
            separatorBuilder: (context, index) => AppDimens.h12.hSpace,
            loadingBuilder: (context) => SliverList.separated(
              itemBuilder: (context, index) => const LeaveRequestCard.shimmer(),
              separatorBuilder: (context, index) => AppDimens.h12.hSpace,
              itemCount: 5,
            ),
          );
        },
      ),
    );
  }

  Widget _buildApprovalActions(LeaveApprovalCubit cubit, LeaveRequest request) {
    return BlocProvider.value(
      value: cubit,
      child: BlocConsumer<LeaveApprovalCubit, LeaveApprovalState>(
        listenWhen: (prev, curr) => prev.approvalSubmit != curr.approvalSubmit,
        listener: (context, state) {
          state.approvalSubmit.maybeWhen(
            orElse: () {},
            success: (_) {
              context.pop();
              AppSnackbar.showSuccess(context, 'Berhasil membuat approval');
            },
            failure: (e) {
              context.pop();
              AppSnackbar.showError(context, 'Gagal membuat approval: $e');
            },
          );
        },
        builder: (context, state) {
          final isActionSelected =
              state.approvalAction != LeaveApprovalAction.none;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isActionSelected) ...[
                AppTextField(
                  label:
                      'Alasan ${state.approvalAction.isApprove ? 'Persetujuan' : 'Penolakan'}',
                  hintText: 'Masukkan alasan...',
                  maxLines: 3,
                  isRequired: state.approvalAction.isReject,
                  onChanged: cubit.onChangeReason,
                  errorText: state.reasonInput.errorMessage,
                ),
                SizedBox(height: AppDimens.h16),
                AppButtonNew(
                  onPressed: () => cubit.submitApproval(request),
                  text: 'Kirim',
                  variant: AppButtonNewVariant.primary,
                  style: AppButtonNewStyle.filled,
                  isLoading: state.approvalSubmit.isLoading,
                ),
              ] else ...[
                AppFlatSheetActions(
                  actions: [
                    AppFlatSheetAction(
                      icon: Icons.close_rounded,
                      label: 'Tolak',
                      color: AppColors.danger,
                      onTap: () => cubit.onChangeApprovalAction(
                        LeaveApprovalAction.reject,
                      ),
                    ),
                    AppFlatSheetAction(
                      icon: Icons.check_rounded,
                      label: 'Setujui',
                      color: AppColors.primary,
                      onTap: () => cubit.onChangeApprovalAction(
                        LeaveApprovalAction.approve,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _LeaveApprovalDetailTitle extends StatelessWidget {
  const _LeaveApprovalDetailTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Detail Cuti'),
        SizedBox(height: AppDimens.h2),
        Text(
          'Informasi pengajuan cuti',
          style: context.textStyle.bodySmall?.copyWith(
            color: AppColors.labelSecondary,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
