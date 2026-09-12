import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/pages/attendance_request/bloc/attendance_request_state.dart';
import 'package:presensi_mobile/presentation/pages/attendance_request/tabs/my_request/bloc/my_request_cubit.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

import '../../bloc/attendance_request_cubit.dart';
import 'bloc/my_request_state.dart';
import '../../widgets/_widgets.dart';

@RoutePage()
class MyAttendanceRequestPage extends StatelessWidget {
  const MyAttendanceRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MyAttendanceRequestCubit>()
        ..onChangeFilterDate(
          context.read<AttendanceRequestCubit>().state.filterDate,
        ),
      child: const MyAttendanceRequestView(),
    );
  }
}

class MyAttendanceRequestView extends StatelessWidget {
  const MyAttendanceRequestView({super.key});

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
            final cubit = context.read<MyAttendanceRequestCubit>();
            cubit.onChangeFilterDate(state.filterDate);
          },
        ),
        BlocListener<AttendanceRequestCubit, AttendanceRequestState>(
          listenWhen: (previous, current) =>
              previous.refreshCounter != current.refreshCounter,
          listener: (context, state) {
            context.read<MyAttendanceRequestCubit>().onRefresh();
          },
        ),
      ],
      child: BlocBuilder<MyAttendanceRequestCubit, MyAttendanceRequestState>(
        builder: (context, state) {
          final cubit = context.read<MyAttendanceRequestCubit>();

          void onTapAttendanceRequestCard(AttendanceRequest request) {
            AppBottomSheet.show(
              context: context,
              title: const AppBottomSheetTitle(
                title: 'Detail Request Presensi',
              ),
              child: AttendanceRequestDetailView(request: request),
              actionsBuilder: (sheetContext) => AppFlatSheetActions(
                actions: [
                  AppFlatSheetAction(
                    icon: Icons.delete_outline_rounded,
                    label: 'Hapus',
                    color: AppColors.danger,
                    onTap: request.status == AttendanceRequestStatus.pending
                        ? () async {
                            Navigator.of(sheetContext).pop();
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Hapus request presensi?'),
                                content: const Text(
                                  'Request yang dihapus tidak dapat dikembalikan.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              final error = await cubit.deleteRequest(
                                request.id,
                              );
                              if (context.mounted && error != null) {
                                AppBottomSheet.showError(
                                  context: context,
                                  titleText: 'Gagal menghapus',
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
                    onTap: request.status == AttendanceRequestStatus.pending
                        ? () async {
                            Navigator.of(sheetContext).pop();
                            await context.router.push(
                              AttendanceRequestFormPageRoute(request: request),
                            );
                            cubit.onRefresh();
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

          return AppInfiniteScrollView<AttendanceRequest>(
            onRefresh: () async => cubit.onRefresh(),
            state: state.attendanceRequests,
            onFetchNext: cubit.fetchNextPage,
            itemBuilder: (context, item) => AttendanceRequestCard(
              onTap: () => onTapAttendanceRequestCard(item),
              request: item,
              showUser: false,
            ),
            separatorBuilder: (context, index) => AppDimens.h12.hSpace,
            loadingBuilder: (context) => SliverList.separated(
              itemBuilder: (context, index) =>
                  const AttendanceRequestCard.shimmer(showUser: false),
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
                        ...AttendanceRequestStatus.values.map(
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
