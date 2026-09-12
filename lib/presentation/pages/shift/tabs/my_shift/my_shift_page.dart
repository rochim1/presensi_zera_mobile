import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import '../../widgets/_widgets.dart';
import 'package:table_calendar/table_calendar.dart';

@RoutePage()
class MyShiftPage extends StatelessWidget {
  const MyShiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<MyShiftCubit>()
            ..onChangeFilterDate(context.read<ShiftCubit>().state.filterDate),
      child: const MyShiftView(),
    );
  }
}

class MyShiftView extends StatefulWidget {
  const MyShiftView({super.key});

  @override
  State<MyShiftView> createState() => _MyShiftViewState();
}

class _MyShiftViewState extends State<MyShiftView> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyShiftCubit, MyShiftState>(
      builder: (context, state) {
        final cubit = context.read<MyShiftCubit>();

        void onTapShiftCard(ShiftSchedule schedule) {
          final now = DateTime.now();

          AppBottomSheet.show(
            context: context,
            title: const AppBottomSheetTitle(
              title: 'Detail Shift',
              subtitle: 'Informasi jadwal kerja',
            ),
            child: ShiftScheduleDetailView(schedule: schedule),
            actions: [
              AppButtonNew(
                onPressed: () => context.router.pop(),
                text: 'Tutup',
                variant: AppButtonNewVariant.tertiary,
                style: AppButtonNewStyle.ghost,
              ),
              if (schedule.assignedDate?.isAfter(now.addDays(3)) ?? false) ...[
                AppButtonNew(
                  onPressed: () async {
                    context.router.pop();
                    final result = await context.router.push(
                      ShiftSwapRequestFormPageRoute(
                        shiftScheduleId: schedule.id,
                      ),
                    );
                    if (result == true && context.mounted) {
                      await cubit.onRefresh();
                    }
                  },
                  text: 'Tukar Shift',
                ),
              ],
            ],
          );
        }

        final filteredState = state.shiftSchedules.maybeWhen(
          success: (data, page, hasReachedMax) {
            if (state.filterDate != null) {
              final filteredData = data
                  .where((e) => isSameDay(e.assignedDate, state.filterDate))
                  .toList();
              return BasePaginatedState.success(
                data: filteredData,
                page: page,
                hasReachedMax: true,
              );
            }
            return state.shiftSchedules;
          },
          orElse: () => state.shiftSchedules,
        );

        return AppInfiniteScrollView<ShiftSchedule>(
          state: filteredState,
          onRefresh: () async => cubit.onRefresh(),
          onFetchNext: () => cubit.fetchNextPage(),
          sliversBefore: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: AppDimens.h16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    currentDay: DateTime.now(),
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Bulan',
                    },
                    selectedDayPredicate: (day) =>
                        isSameDay(state.filterDate, day),
                    eventLoader: (day) {
                      return state.shiftSchedules.maybeWhen(
                        success: (data, _, _) {
                          return data
                              .where((e) => isSameDay(e.assignedDate, day))
                              .toList();
                        },
                        orElse: () => [],
                      );
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                      context.read<MyShiftCubit>().onChangeFilterDate(
                        selectedDay,
                      );
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                      context.read<MyShiftCubit>().onChangeFocusedMonth(
                        focusedDay,
                      );
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: context.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.w16,
            vertical: AppDimens.paddingSmallX,
          ),
          itemBuilder: (context, schedule) => ShiftScheduleCard(
            schedule: schedule,
            onTap: () => onTapShiftCard(schedule),
          ),
          loadingBuilder: (context) => SliverList.separated(
            itemBuilder: (context, index) => ShiftScheduleCard.shimmer(),
            separatorBuilder: (context, index) => AppDimens.h12.hSpace,
            itemCount: 10,
          ),
          separatorBuilder: (context, index) => AppDimens.h12.hSpace,
        );
      },
    );
  }
}
