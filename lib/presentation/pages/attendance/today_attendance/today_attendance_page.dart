import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../tabs/attendances/bloc/attendances_state.dart';

@RoutePage()
class TodayAttendancePage extends StatelessWidget {
  const TodayAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return BlocProvider(
      create: (_) => sl<AttendancesCubit>()..applyFilters(
        startDate: today,
        endDate: today,
      ),
      child: const TodayAttendanceView(),
    );
  }
}

class TodayAttendanceView extends StatelessWidget {
  const TodayAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Presensi Hari Ini',
        showBackButton: true,
        onBackTap: () => context.router.maybePop(),
        backgroundColor: AppColors.transparent,
      ),
      body: BlocBuilder<AttendancesCubit, AttendancesState>(
        builder: (context, state) {
          final cubit = context.read<AttendancesCubit>();

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
