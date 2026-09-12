import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../../bloc/reimbursement_state.dart';
import '../../widgets/_widgets.dart';
import 'bloc/approval_reimbursement_state.dart';

@RoutePage()
class ApprovalReimbursementPage extends StatelessWidget {
  const ApprovalReimbursementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ApprovalReimbursementCubit>()
        ..onChangeFilterDate(
          context.read<ReimbursementCubit>().state.filterDate,
        ),
      child: const ApprovalReimbursementView(),
    );
  }
}

class ApprovalReimbursementView extends StatelessWidget {
  const ApprovalReimbursementView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReimbursementCubit, ReimbursementState>(
          listenWhen: (prev, curr) =>
              prev.filterDate != curr.filterDate ||
              prev.startDate != curr.startDate ||
              prev.endDate != curr.endDate,
          listener: (context, state) {
            context.read<ApprovalReimbursementCubit>().onChangeFilterDate(
              state.filterDate,
            );
          },
        ),
        BlocListener<ReimbursementCubit, ReimbursementState>(
          listenWhen: (prev, curr) =>
              prev.refreshCounter != curr.refreshCounter,
          listener: (context, state) {
            context.read<ApprovalReimbursementCubit>().onRefresh();
          },
        ),
      ],
      child:
          BlocBuilder<ApprovalReimbursementCubit, ApprovalReimbursementState>(
            builder: (context, state) {
              final cubit = context.read<ApprovalReimbursementCubit>();

              void onTapReimbursementCard(Reimbursement reimbursement) {
                AppBottomSheet.show(
                  context: context,
                  onClose: () {
                    cubit.onChangeApprovalAction(
                      AttendanceRequestApprovalAction.none,
                    );
                  },
                  title: const AppBottomSheetTitle(
                    title: 'Detail Reimbursement',
                  ),
                  actionsBuilder:
                      reimbursement.statusReimbursement?.toLowerCase() ==
                          'pending'
                      ? (context) => _buildApprovalActions(cubit, reimbursement)
                      : null,
                  child: ReimbursementDetailView(reimbursement: reimbursement),
                );
              }

              return AppInfiniteScrollView<Reimbursement>(
                state: state.reimbursements,
                onRefresh: () async => cubit.onRefresh(),
                onFetchNext: () => cubit.fetchNextPage(),
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.w16,
                  vertical: AppDimens.paddingSmallX,
                ),
                itemBuilder: (context, reimbursement) => ReimbursementCard(
                  reimbursement: reimbursement,
                  onTap: () => onTapReimbursementCard(reimbursement),
                ),
                loadingBuilder: (context) => SliverList.separated(
                  itemBuilder: (context, index) => ReimbursementCard.shimmer(),
                  separatorBuilder: (context, index) => AppDimens.h12.hSpace,
                  itemCount: 10,
                ),
                separatorBuilder: (context, index) => AppDimens.h12.hSpace,
              );
            },
          ),
    );
  }

  Widget _buildApprovalActions(
    ApprovalReimbursementCubit cubit,
    Reimbursement reimbursement,
  ) {
    return BlocProvider.value(
      value: cubit,
      child: BlocConsumer<ApprovalReimbursementCubit, ApprovalReimbursementState>(
        builder: (context, state) {
          final isActionSelected = !state.approvalAction.isNone;

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
                  onPressed: () => cubit.submitApproval(reimbursement),
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
                      onTap: () {
                        cubit.onChangeApprovalAction(
                          AttendanceRequestApprovalAction.reject,
                        );
                      },
                    ),
                    AppFlatSheetAction(
                      icon: Icons.check_rounded,
                      label: 'Setujui',
                      color: AppColors.primary,
                      onTap: () {
                        cubit.onChangeApprovalAction(
                          AttendanceRequestApprovalAction.approve,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ],
          );
        },
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
      ),
    );
  }
}
