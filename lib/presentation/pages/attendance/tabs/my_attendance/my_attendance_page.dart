import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../../bloc/attendance_state.dart';
import 'bloc/my_attendance_state.dart';

@RoutePage()
class MyAttendancePage extends StatelessWidget {
  const MyAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final filter = context.read<AttendanceCubit>().state;
        return sl<MyAttendanceCubit>()..applyFilters(
          startDate: filter.startDate,
          endDate: filter.endDate,
          typePresensi: filter.typePresensi,
          searchName: filter.searchName,
        );
      },
      child: const MyAttendanceView(),
    );
  }
}

class MyAttendanceView extends StatelessWidget {
  const MyAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AttendanceCubit, AttendanceState>(
          listenWhen: (prev, curr) =>
              prev.startDate != curr.startDate ||
              prev.endDate != curr.endDate ||
              prev.typePresensi != curr.typePresensi ||
              prev.searchName != curr.searchName,
          listener: (context, state) {
            context.read<MyAttendanceCubit>().applyFilters(
              startDate: state.startDate,
              endDate: state.endDate,
              typePresensi: state.typePresensi,
              searchName: state.searchName,
            );
          },
        ),
      ],
      child: BlocBuilder<MyAttendanceCubit, MyAttendanceState>(
        builder: (context, state) {
          final cubit = context.read<MyAttendanceCubit>();

          void onTapAttendanceCard(Attendance attendance) {
            context.router.push(
              AttendanceDetailPageRoute(attendanceId: attendance.id),
            );
          }

          return AppInfiniteScrollView<Attendance>(
            state: state.attendances,
            onRefresh: () async => cubit.onRefresh(),
            onFetchNext: () => cubit.fetchNextPage(),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.w16,
              vertical: AppDimens.paddingSmallX,
            ),
            itemBuilderWithIndex: (context, attendance, index) =>
                AttendanceCard(
                  attendance: attendance,
                  showUser: false,
                  index: index,
                  onTap: () => onTapAttendanceCard(attendance),
                ),
            loadingBuilder: (context) => SliverList.separated(
              itemBuilder: (context, index) => const AttendanceCard.shimmer(),
              separatorBuilder: (context, index) => AppDimens.h12.hSpace,
            ),
            separatorBuilder: (context, index) => AppDimens.h12.hSpace,
          );
        },
      ),
    );
  }
}
