import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../../bloc/overtime_state.dart';
import 'bloc/my_request_state.dart';
import '../../widgets/_widgets.dart';

@RoutePage()
class MyOvertimeRequestPage extends StatelessWidget {
  const MyOvertimeRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MyOvertimeRequestCubit>()
        ..onChangeFilterDate(context.read<OvertimeCubit>().state.filterDate),
      child: const MyOvertimeRequestView(),
    );
  }
}

class MyOvertimeRequestView extends StatelessWidget {
  const MyOvertimeRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OvertimeCubit, OvertimeState>(
          listenWhen: (previous, current) =>
              previous.filterDate != current.filterDate ||
              previous.startDate != current.startDate ||
              previous.endDate != current.endDate,
          listener: (context, state) {
            final cubit = context.read<MyOvertimeRequestCubit>();
            cubit.onChangeFilterDate(state.filterDate);
          },
        ),
        BlocListener<OvertimeCubit, OvertimeState>(
          listenWhen: (previous, current) =>
              previous.refreshCounter != current.refreshCounter,
          listener: (context, state) {
            context.read<MyOvertimeRequestCubit>().onRefresh();
          },
        ),
      ],
      child: BlocBuilder<MyOvertimeRequestCubit, MyOvertimeRequestState>(
        builder: (context, state) {
          final cubit = context.read<MyOvertimeRequestCubit>();

          void onTapOvertimeRequestCard(OvertimeRequest request) {
            final canEdit = request.status == OvertimeRequestStatus.pending;
            final canDelete =
                request.status == OvertimeRequestStatus.pending ||
                request.status == OvertimeRequestStatus.rejected;

            AppBottomSheet.show(
              context: context,
              title: const AppBottomSheetTitle(title: 'Detail Lembur'),
              child: OvertimeRequestDetailView(request: request),
              actionsBuilder: (sheetContext) => AppFlatSheetActions(
                actions: [
                  AppFlatSheetAction(
                    icon: Icons.delete_outline_rounded,
                    label: 'Hapus',
                    color: AppColors.danger,
                    onTap: canDelete
                        ? () async {
                            Navigator.of(sheetContext).pop();
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Hapus pengajuan lembur?'),
                                content: const Text(
                                  'Pengajuan yang dihapus tidak dapat dikembalikan.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(false),
                                    child: const Text('Batal'),
                                  ),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(true),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed != true || !context.mounted) return;
                            final errorMessage = await cubit.deleteRequest(
                              request.id,
                            );
                            if (!context.mounted) return;
                            if (errorMessage == null) {
                              AppSnackbar.showSuccess(
                                context,
                                'Pengajuan lembur berhasil dihapus',
                              );
                            } else {
                              AppSnackbar.showError(context, errorMessage);
                            }
                          }
                        : null,
                  ),
                  AppFlatSheetAction(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    color: AppColors.primary,
                    onTap: canEdit
                        ? () async {
                            Navigator.of(sheetContext).pop();
                            final result = await context.router.push(
                              OvertimeRequestFormPageRoute(request: request),
                            );
                            if (result == true && context.mounted) {
                              cubit.onRefresh();
                            }
                          }
                        : null,
                  ),
                  AppFlatSheetAction(
                    icon: Icons.close_rounded,
                    label: 'Tutup',
                    color: AppColors.labelSecondary,
                    onTap: () => Navigator.of(sheetContext).pop(),
                  ),
                ],
              ),
            );
          }

          return AppInfiniteScrollView<OvertimeRequest>(
            onRefresh: () async => cubit.onRefresh(),
            state: state.overtimeRequests,
            onFetchNext: cubit.fetchNextPage,
            itemBuilder: (context, item) => OvertimeRequestCard(
              onTap: () => onTapOvertimeRequestCard(item),
              request: item,
              showUser: false,
            ),
            separatorBuilder: (context, index) => AppDimens.h12.hSpace,
            loadingBuilder: (context) => SliverList.separated(
              itemBuilder: (context, index) =>
                  const OvertimeRequestCard.shimmer(showUser: false),
              separatorBuilder: (context, index) => AppDimens.h12.hSpace,
              itemCount: 5,
            ),
            sliversBefore: [
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppDimens.h16),
                    child: Row(
                      spacing: AppDimens.w8,
                      children: [
                        AppDimens.w8.wSpace,
                        AppFilterChip(
                          label: 'Semua',
                          isSelected: state.filterStatus == null,
                          onTap: () => cubit.onChangeFilterStatus(null),
                        ),
                        ...OvertimeRequestStatus.values.map(
                          (v) => AppFilterChip(
                            label: v.toDisplayName,
                            isSelected: state.filterStatus == v,
                            onTap: () => cubit.onChangeFilterStatus(v),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
