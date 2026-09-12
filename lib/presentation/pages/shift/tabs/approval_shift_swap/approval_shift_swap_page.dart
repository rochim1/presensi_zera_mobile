import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import '../../widgets/_widgets.dart';
import 'bloc/approval_shift_swap_state.dart';

@RoutePage()
class ApprovalShiftSwapPage extends StatelessWidget {
  const ApprovalShiftSwapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ApprovalShiftSwapCubit>()
            ..onChangeFilterDate(context.read<ShiftCubit>().state.filterDate),
      child: const ApprovalShiftSwapView(),
    );
  }
}

class ApprovalShiftSwapView extends StatelessWidget {
  const ApprovalShiftSwapView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ShiftCubit, ShiftState>(
          listenWhen: (previous, current) =>
              previous.refreshCounter != current.refreshCounter,
          listener: (context, state) {
            final cubit = context.read<ApprovalShiftSwapCubit>();
            cubit.onRefresh();
          },
        ),
      ],
      child: BlocBuilder<ApprovalShiftSwapCubit, ApprovalShiftSwapState>(
        builder: (context, state) {
          final cubit = context.read<ApprovalShiftSwapCubit>();

          void onTapSwapCard(ShiftSwapRequest request) {
            final cubit = context.read<ApprovalShiftSwapCubit>();

            AppBottomSheet.show(
              context: context,
              onClose: () {
                cubit.onChangeApprovalAction(null);
              },
              title: const AppBottomSheetTitle(title: 'Detail Tukar Shift'),
              child: SwapRequestDetailView(request: request),
              actionsBuilder: request.status == RequestStatus.pending
                  ? (_) => _buildApprovalActions(cubit, request)
                  : null,
            );
          }

          return AppInfiniteScrollView<ShiftSwapRequest>(
            state: state.swapRequests,
            onRefresh: () async => cubit.onRefresh(),
            onFetchNext: () => cubit.fetchNextPage(),
            sliversBefore: [
              SliverToBoxAdapter(
                child: MonthFilterHeader(
                  currentMonth: state.filterDate ?? DateTime.now(),
                  onMonthChanged: (newMonth) {
                    cubit.onChangeFilterDate(newMonth);
                  },
                ),
              ),
            ],
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.w16,
              vertical: AppDimens.paddingSmallX,
            ),
            itemBuilder: (context, item) => SwapRequestCard(
              swapRequest: item,
              onTap: () => onTapSwapCard(item),
            ),
            loadingBuilder: (context) => SliverList.separated(
              itemBuilder: (context, index) => SwapRequestCard.shimmer(),
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
    ApprovalShiftSwapCubit cubit,
    ShiftSwapRequest request,
  ) {
    return BlocProvider.value(
      value: cubit,
      child: BlocConsumer<ApprovalShiftSwapCubit, ApprovalShiftSwapState>(
        builder: (context, state) {
          final approvalAction = state.approvalAction;
          final isActionSelected = approvalAction != null;
          final isRejected = approvalAction == RequestStatus.rejected;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isActionSelected) ...[
                if (isRejected) ...[
                  AppTextField(
                    label: 'Alasan Penolakan',
                    hintText: 'Masukkan alasan...',
                    maxLines: 3,
                    isRequired: true,
                    onChanged: cubit.onChangeReason,
                    errorText: state.reasonInput.errorMessage,
                  ),
                  SizedBox(height: AppDimens.h16),
                ],
                AppButtonNew(
                  onPressed: () => cubit.submitApproval(request),
                  text: 'Kirim',
                  variant: approvalAction == RequestStatus.approved
                      ? AppButtonNewVariant.primary
                      : AppButtonNewVariant.tertiary,
                  style: approvalAction == RequestStatus.approved
                      ? AppButtonNewStyle.filled
                      : AppButtonNewStyle.ghost,
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
                        cubit.onChangeApprovalAction(RequestStatus.rejected);
                      },
                    ),
                    AppFlatSheetAction(
                      icon: Icons.check_rounded,
                      label: 'Setujui',
                      color: AppColors.primary,
                      onTap: () {
                        cubit.onChangeApprovalAction(RequestStatus.approved);
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
