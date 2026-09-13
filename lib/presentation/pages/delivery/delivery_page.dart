import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/pages/consignment/consignment_resume.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/cubits/sales_target/sales_target_cubit.dart';
import 'package:presensi_mobile/presentation/widgets/delivery/daily_progress_banner.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';

part 'delivery_pending_tab.dart';

part 'delivery_canceled_tab.dart';

part 'delivery_success_tab.dart';

@RoutePage()
class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  DateTime _selectedDateFilter = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SalesTargetCubit>()..loadMyTarget(),
      child: Scaffold(
        appBar: AppTopBar(
          title: 'Kunjungan',
          leading:
              BlocBuilder<
                TasksGetAllPerjalananCubit,
                TasksGetAllPerjalananState
              >(
                builder: (context, state) {
                  return AppTopBarActionButton(
                    onTap: () async {
                      final answer = await AppModalDialog.datePicker(
                        context,
                        initialDate: state.filter?.taskDateAssigned?.toDateTime,
                      );

                      if (answer == null || !mounted || !context.mounted) {
                        return;
                      }
                      setState(() {
                        _selectedDateFilter = answer;
                      });
                      context
                          .read<TasksGetAllPerjalananCubit>()
                          .initLoadAllData(answer);
                      context.read<TasksGetAllPendingCubit>().initLoadAllData(
                        answer,
                      );
                      context.read<TasksGetAllSuccessCubit>().initLoadAllData(
                        answer,
                      );
                      context.read<TasksGetAllCanceledCubit>().initLoadAllData(
                        answer,
                      );
                    },
                    icon: Icons.date_range,
                  );
                },
              ),
          actions: [
            BlocBuilder<PresensiGetAllDataCubit, PresensiGetAllDataState>(
              builder: (_, presState) {
                return BlocBuilder<
                  TasksGetAllPendingCubit,
                  TasksGetAllPendingState
                >(
                  builder: (ctxTask, _) {
                    return BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
                      builder: (ctxLocal, _) {
                        return BlocBuilder<UserGetDataCubit, UserGetDataState>(
                          builder: (ctxUser, state) {
                            //! Button Tambah Kunjungan selalu tampil tanpa validasi presensi & status divisi
                            return AppTopBarActionButton(
                              icon: Icons.add_box_rounded,
                              onTap: () async {
                                final appState = context.read<AppCubit>().state;
                                if (appState.hasCheckedOutToday &&
                                    !appState.isOvertimeActive) {
                                  await AppModalBottom.showDefault(
                                    context,
                                    emptyState: EmptyState.confirmation,
                                    contentTitle: 'Peringatan',
                                    contentSubtitle:
                                        'Anda sudah pulang. Tekan tombol "Mulai Lembur" di Beranda terlebih dahulu jika ingin membuat Kunjungan tambahan.',
                                    hasActionPop: true,
                                  );
                                  return;
                                }

                                //! jika status presensi istirahat tidak bisa buat task
                                if (presState.status.isLoaded &&
                                    AppUtility.toBreakOut(presState.data)) {
                                  await AppModalBottom.showDefault(
                                    context,
                                    emptyState: EmptyState.confirmation,
                                    contentTitle: 'Konfirmasi',
                                    contentSubtitle:
                                        'Tidak bisa membuat Kunjungan, status kerja anda masih Istirahat',
                                    hasActionPop: true,
                                  );
                                  return;
                                }

                                final result = await context.router.push<bool?>(
                                  const DeliveryAddFormRoute(),
                                );

                                if (!ctxTask.mounted ||
                                    !ctxUser.mounted ||
                                    !ctxLocal.mounted) {
                                  return;
                                }

                                if (result ?? false) {
                                  ctxTask
                                      .read<TasksGetAllPendingCubit>()
                                      .initLoadAllData();
                                  ctxUser.read<UserGetDataCubit>().getData(
                                    false,
                                  );
                                  ctxLocal.read<UserGetLocalCubit>().getData(
                                    false,
                                  );
                                  ctxTask
                                      .read<SalesTargetCubit>()
                                      .loadMyTarget();
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverToBoxAdapter(
                  child:
                      BlocBuilder<
                        TasksGetAllPerjalananCubit,
                        TasksGetAllPerjalananState
                      >(
                        builder: (context, state) => Column(
                          children: [
                            ConsignmentResume(
                              dateFilter: _selectedDateFilter,
                              // tasks: state.tasks?.where((t) =>t.aktivitas?.statusTask == StatusTask.done.toKey).toList() ?? [],
                              tasks: state.tasks?.first,
                            ),
                            Container(
                              height: 1,
                              color: AppColors.grey.withValues(alpha: 0.2),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimens.paddingMediumX,
                                vertical: AppDimens.paddingMedium,
                              ),
                              child: DailyProgressBanner(),
                            ),
                          ],
                        ),
                      ),
                ),
              ];
            },
            // You tab view goes here
            body: Column(
              children: [
                const TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    Tab(text: 'Journey Plan'),
                    Tab(text: 'Visited (Selesai)'),
                    Tab(text: 'Unvisited / Missed'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      DeliveryPendingTab(dateFilter: _selectedDateFilter),
                      DeliverySuccessTab(dateFilter: _selectedDateFilter),
                      DeliveryCanceledTab(dateFilter: _selectedDateFilter),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
