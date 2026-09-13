part of 'delivery_page.dart';

@RoutePage()
class DeliveryPendingTab extends StatefulWidget {
  const DeliveryPendingTab({super.key, this.dateFilter});

  final DateTime? dateFilter;

  DateTime get effectiveDateFilter => dateFilter ?? DateTime.now();

  @override
  State<DeliveryPendingTab> createState() => _DeliveryPendingTabState();
}

class _DeliveryPendingTabState extends State<DeliveryPendingTab> {
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (AppUtility.isBottomInfinity(scrollController)) {
        context.read<TasksGetAllPendingCubit>().getAllData(
          widget.effectiveDateFilter,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
    refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksGetAllPerjalananCubit, TasksGetAllPerjalananState>(
      builder: (ctxPerjalanan, _) {
        return BlocBuilder<PresensiGetAllDataCubit, PresensiGetAllDataState>(
          builder: (ctxPresensi, presState) {
            return BlocBuilder<
              TasksGetAllCanceledCubit,
              TasksGetAllCanceledState
            >(
              builder: (ctxCanceled, _) {
                return BlocBuilder<
                  TasksGetAllSuccessCubit,
                  TasksGetAllSuccessState
                >(
                  builder: (ctxSuccess, _) {
                    return BlocBuilder<
                      TasksGetAllPendingCubit,
                      TasksGetAllPendingState
                    >(
                      builder: (ctxPending, pedState) => SmartRefresher(
                        controller: refreshController,
                        onRefresh: () {
                          ctxPending
                              .read<TasksGetAllPendingCubit>()
                              .initLoadAllData(widget.effectiveDateFilter);
                          ctxPending.read<SalesTargetCubit>().loadMyTarget();
                          refreshController.refreshCompleted();
                        },
                        child: setList(
                          ctxSuccess: ctxSuccess,
                          ctxCanceled: ctxCanceled,
                          ctxPending: ctxPending,
                          ctxPresensi: ctxPresensi,
                          ctxPerjalanan: ctxPerjalanan,
                          pedState: pedState,
                          presState: presState,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget setList({
    required BuildContext ctxSuccess,
    required BuildContext ctxCanceled,
    required BuildContext ctxPending,
    required BuildContext ctxPresensi,
    required BuildContext ctxPerjalanan,
    required PresensiGetAllDataState presState,
    required TasksGetAllPendingState pedState,
  }) {
    if (pedState.status.isLoaded) {
      return ListView.separated(
        itemCount: pedState.hasMax!
            ? pedState.tasks!.length
            : pedState.tasks!.length + 1,
        padding: const EdgeInsets.all(AppDimens.paddingMediumX),
        itemBuilder: (_, index) {
          if (index >= pedState.tasks!.length) return const ShimmerInfinity();
          final task = pedState.tasks?[index];

          if (task == null) return const SizedBox.shrink();

          return DeliveryTaskItemCard(
            task: task,
            onCanceled: () async {
              final appState = context.read<AppCubit>().state;
              if (appState.hasCheckedOutToday && !appState.isOvertimeActive) {
                await AppModalBottom.showDefault(
                  context,
                  emptyState: EmptyState.confirmation,
                  contentTitle: 'Peringatan',
                  contentSubtitle:
                      'Anda sudah pulang. Tekan tombol "Mulai Lembur" di Beranda terlebih dahulu jika ingin membatalkan Kunjungan.',
                  hasActionPop: true,
                );
                return;
              }

              //! jika status presensi istirahat tidak bisa cancel task
              if (presState.status.isLoaded &&
                  AppUtility.toBreakOut(presState.data)) {
                await AppModalBottom.showDefault(
                  context,
                  emptyState: EmptyState.confirmation,
                  contentTitle: 'Konfirmasi',
                  contentSubtitle:
                      'Tidak bisa membatalkan Kunjungan, status kerja anda masih Istirahat',
                  hasActionPop: true,
                );
                return;
              }

              final result = await context.router.push<bool?>(
                DeliveryCanceledFormRoute(tasks: task),
              );

              if (!ctxPending.mounted ||
                  !ctxCanceled.mounted ||
                  !ctxPerjalanan.mounted ||
                  !ctxPresensi.mounted) {
                return;
              }
              if (result ?? false) {
                ctxPending.read<TasksGetAllPendingCubit>().initLoadAllData();
                ctxCanceled.read<TasksGetAllCanceledCubit>().initLoadAllData();
                ctxPerjalanan
                    .read<TasksGetAllPerjalananCubit>()
                    .initLoadAllData();
                ctxPresensi.read<PresensiGetAllDataCubit>().getAllData();
                ctxPending.read<SalesTargetCubit>().loadMyTarget();
              }
            },
            onTap: () async {
              final appState = context.read<AppCubit>().state;
              if (appState.hasCheckedOutToday && !appState.isOvertimeActive) {
                await AppModalBottom.showDefault(
                  context,
                  emptyState: EmptyState.confirmation,
                  contentTitle: 'Peringatan',
                  contentSubtitle:
                      'Anda sudah pulang. Tekan tombol "Mulai Lembur" di Beranda terlebih dahulu jika ingin mengerjakan Kunjungan.',
                  hasActionPop: true,
                );
                return;
              }

              //! jika status presensi istirahat tidak bisa assign task
              if (presState.status.isLoaded &&
                  AppUtility.toBreakOut(presState.data)) {
                await AppModalBottom.showDefault(
                  context,
                  emptyState: EmptyState.confirmation,
                  contentTitle: 'Konfirmasi',
                  contentSubtitle:
                      'Tidak bisa memeriksa Kunjungan, status kerja anda masih Istirahat',
                  hasActionPop: true,
                );
                return;
              }

              final result = await context.router.push<bool?>(
                DeliveryCheckingFormRoute(tasks: task),
              );

              if (!ctxPending.mounted ||
                  !ctxSuccess.mounted ||
                  !ctxCanceled.mounted ||
                  !ctxPerjalanan.mounted ||
                  !ctxPresensi.mounted) {
                return;
              }
              if (result ?? false) {
                ctxPending.read<TasksGetAllPendingCubit>().initLoadAllData();
                ctxSuccess.read<TasksGetAllSuccessCubit>().initLoadAllData();
                ctxCanceled.read<TasksGetAllCanceledCubit>().initLoadAllData();
                ctxPerjalanan
                    .read<TasksGetAllPerjalananCubit>()
                    .initLoadAllData();
                ctxPresensi.read<PresensiGetAllDataCubit>().getAllData();
                ctxPending.read<SalesTargetCubit>().loadMyTarget();
              }
            },
          );
        },
        separatorBuilder: (context, index) => AppDimens.paddingMediumX.hSpace,
      );
    } else if (pedState.status.isNotLoaded) {
      return FailureViewWidget(failure: pedState.failure);
    } else {
      return ListView.separated(
        itemCount: 8,
        padding: const EdgeInsets.all(AppDimens.paddingMediumX),
        itemBuilder: (_, _) => const ShimmerListItem(),
        separatorBuilder: (_, _) => AppDimens.paddingSmallX.hSpace,
      );
    }
  }
}
