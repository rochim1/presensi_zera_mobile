import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../../bloc/attendance_request_state.dart';
import '../../widgets/_widgets.dart';
import 'bloc/approval_state.dart';

@RoutePage()
class AttendanceRequestApprovalPage extends StatelessWidget {
  const AttendanceRequestApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AttendanceRequestApprovalCubit>()
        ..onChangeFilterDate(
          context.read<AttendanceRequestCubit>().state.filterDate,
        ),
      child: const AttendanceRequestApprovalView(),
    );
  }
}

class AttendanceRequestApprovalView extends StatelessWidget {
  const AttendanceRequestApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AttendanceRequestCubit, AttendanceRequestState>(
          listenWhen: (previous, current) =>
              previous.filterDate != current.filterDate ||
              previous.startDate != current.startDate ||
              previous.endDate != current.endDate,
          listener: (context, state) {
            final cubit = context.read<AttendanceRequestApprovalCubit>();
            cubit.onChangeFilterDate(state.filterDate);
          },
        ),
        BlocListener<AttendanceRequestCubit, AttendanceRequestState>(
          listenWhen: (previous, current) =>
              previous.refreshCounter != current.refreshCounter,
          listener: (context, state) {
            context.read<AttendanceRequestApprovalCubit>().onRefresh();
          },
        ),
      ],
      child:
          BlocBuilder<
            AttendanceRequestApprovalCubit,
            AttendanceRequestApprovalState
          >(
            builder: (context, state) {
              final cubit = context.read<AttendanceRequestApprovalCubit>();

              void onTapLeaveRequestCard(ApprovalHistory approval) {
                final request = approval.attendanceRequest;
                if (request == null) return;
                final cubit = context.read<AttendanceRequestApprovalCubit>();

                AppBottomSheet.show(
                  context: context,
                  onClose: () {
                    cubit.onChangeApprovalAction(
                      AttendanceRequestApprovalAction.none,
                    );
                  },
                  title: const AppBottomSheetTitle(
                    title: 'Detail Request Presensi',
                  ),
                  actionsBuilder:
                      request.status == AttendanceRequestStatus.pending
                      ? (context) => _buildApprovalActions(cubit, request)
                      : null,
                  child: AttendanceRequestDetailView(
                    request: request,
                    user: approval.requester,
                  ),
                );
              }

              return AppInfiniteScrollView<ApprovalHistory>(
                onRefresh: () async => cubit.onRefresh(),
                state: state.approvals,
                onFetchNext: cubit.fetchNextPage,
                itemBuilder: (context, item) {
                  final request = item.attendanceRequest;
                  if (request == null) return const SizedBox.shrink();
                  return AttendanceRequestCard(
                    onTap: () => onTapLeaveRequestCard(item),
                    request: request,
                    user: item.requester,
                  );
                },
                separatorBuilder: (context, index) => AppDimens.h12.hSpace,
                loadingBuilder: (context) => SliverList.separated(
                  itemBuilder: (context, index) =>
                      const AttendanceRequestCard.shimmer(),
                  separatorBuilder: (context, index) => AppDimens.h12.hSpace,
                  itemCount: 5,
                ),
                sliversBefore: [
                  SliverToBoxAdapter(child: AppDimens.h16.hSpace),
                ],
              );
            },
          ),
    );
  }

  Widget _buildApprovalActions(
    AttendanceRequestApprovalCubit cubit,
    AttendanceRequest request,
  ) {
    return BlocProvider.value(
      value: cubit,
      child:
          BlocConsumer<
            AttendanceRequestApprovalCubit,
            AttendanceRequestApprovalState
          >(
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
            listenWhen: (prev, curr) =>
                prev.approvalSubmit != curr.approvalSubmit,
            listener:
                (BuildContext context, AttendanceRequestApprovalState state) {
                  state.approvalSubmit.maybeWhen(
                    orElse: () {},
                    success: (_) {
                      context.pop();
                      AppSnackbar.showSuccess(
                        context,
                        'Berhasil membuat approval',
                      );
                    },
                    failure: (e) {
                      context.pop();
                      AppSnackbar.showError(
                        context,
                        'Gagal membuat approval: $e',
                      );
                    },
                  );
                },
          ),
    );
  }
}
