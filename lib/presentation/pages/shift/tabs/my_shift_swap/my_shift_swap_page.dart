import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import '../../widgets/_widgets.dart';
import 'bloc/my_shift_swap_state.dart';

@RoutePage()
class MyShiftSwapPage extends StatelessWidget {
  const MyShiftSwapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<MyShiftSwapCubit>()
            ..onChangeFilterDate(context.read<ShiftCubit>().state.filterDate),
      child: const MyShiftSwapView(),
    );
  }
}

class MyShiftSwapView extends StatelessWidget {
  const MyShiftSwapView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ShiftCubit, ShiftState>(
          listenWhen: (previous, current) =>
              previous.refreshCounter != current.refreshCounter,
          listener: (context, state) {
            context.read<MyShiftSwapCubit>().onRefresh();
          },
        ),
      ],
      child: BlocBuilder<MyShiftSwapCubit, MyShiftSwapState>(
        builder: (context, state) {
          final cubit = context.read<MyShiftSwapCubit>();

          void onTapSwapCard(ShiftSwapRequest request) {
            AppBottomSheet.show(
              context: context,
              title: const AppBottomSheetTitle(title: 'Detail Tukar Shift'),
              child: SwapRequestDetailView(request: request),
              actionsBuilder: (sheetContext) => AppFlatSheetActions(
                actions: [
                  AppFlatSheetAction(
                    icon: Icons.cancel_outlined,
                    label: 'Batalkan',
                    color: AppColors.danger,
                    onTap: request.status == RequestStatus.pending
                        ? () async {
                            Navigator.of(sheetContext).pop();
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Batalkan tukar shift?'),
                                content: const Text(
                                  'Pengajuan yang dibatalkan tidak dapat diproses kembali.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Kembali'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Batalkan'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              final error = await cubit.cancelRequest(
                                request.id,
                              );
                              if (context.mounted && error != null) {
                                AppBottomSheet.showError(
                                  context: context,
                                  titleText: 'Gagal membatalkan',
                                  message: error,
                                );
                              }
                            }
                          }
                        : null,
                  ),
                  AppFlatSheetAction(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    color: AppColors.primary,
                    onTap: request.status == RequestStatus.pending
                        ? () async {
                            Navigator.of(sheetContext).pop();
                            await context.router.push(
                              ShiftSwapRequestFormPageRoute(
                                shiftScheduleId: request.requesterSchedule.id,
                                request: request,
                              ),
                            );
                            await cubit.onRefresh();
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
              showUser: false,
              onTap: () => onTapSwapCard(item),
            ),
            loadingBuilder: (context) => SliverList.separated(
              itemBuilder: (context, index) =>
                  SwapRequestCard.shimmer(showUser: false),
              separatorBuilder: (context, index) => AppDimens.h12.hSpace,
              itemCount: 10,
            ),
            separatorBuilder: (context, index) => AppDimens.h12.hSpace,
          );
        },
      ),
    );
  }
}
