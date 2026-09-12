part of '../home_page.dart';

class HomePanel extends StatefulWidget {
  const HomePanel({super.key});

  @override
  State<HomePanel> createState() => _HomePanelState();
}

class _HomePanelState extends State<HomePanel> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppDimens.h16,
              horizontal: AppDimens.w16,
            ),
            child: BlocBuilder<PresensiGetAllDataCubit, PresensiGetAllDataState>(
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
                          builder: (ctxPending, pedState) {
                            if (pedState.status.isLoaded) {
                              if (pedState.tasks?.isEmpty ?? true) {
                                return _buildEmptyState(context);
                              }

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: (pedState.tasks ?? [])
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      final index = entry.key;
                                      final data = entry.value;
                                      return ItemActivityHome(
                                        activity: data.aktivitas!,
                                        onTap: () async {
                                          if (presState.status.isLoaded &&
                                              AppUtility.toBreakOut(
                                                presState.data,
                                              )) {
                                            await AppModalBottom.showDefault(
                                              context,
                                              emptyState:
                                                  EmptyState.confirmation,
                                              contentTitle: 'Konfirmasi',
                                              contentSubtitle:
                                                  'Tidak bisa memeriksa Kunjungan, status kerja anda masih Istirahat',
                                              hasActionPop: true,
                                            );

                                            return;
                                          }

                                          final result = await context.router
                                              .push<bool?>(
                                                DeliveryCheckingFormRoute(
                                                  tasks: pedState.tasks?[index],
                                                ),
                                              );

                                          if (!ctxPending.mounted ||
                                              !ctxSuccess.mounted ||
                                              !ctxCanceled.mounted ||
                                              !ctxPresensi.mounted) {
                                            return;
                                          }
                                          if (result ?? false) {
                                            ctxPending
                                                .read<TasksGetAllPendingCubit>()
                                                .initLoadAllData();
                                            ctxSuccess
                                                .read<TasksGetAllSuccessCubit>()
                                                .initLoadAllData();
                                            ctxCanceled
                                                .read<
                                                  TasksGetAllCanceledCubit
                                                >()
                                                .initLoadAllData();
                                            ctxPresensi
                                                .read<PresensiGetAllDataCubit>()
                                                .getAllData();
                                          }
                                        },
                                      );
                                    })
                                    .toList(),
                              );
                            } else if (pedState.status.isNotLoaded) {
                              if (pedState.failure?.code.isArrayEmpty ??
                                  false) {
                                return _buildEmptyState(context);
                              } else {
                                return _buildErrorState(
                                  context,
                                  pedState.failure,
                                );
                              }
                            } else {
                              return _buildLoadingState();
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      child: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimens.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.assignment_turned_in_rounded,
                  size: AppDimens.size2XL,
                  color: AppColors.grey.shade400,
                ),
              ),
              AppDimens.paddingMediumX.hSpace,
              Text(
                'Tidak Ada Kunjungan',
                style: context.textStyle.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelPrimary,
                ),
              ),
              AppDimens.size2S.hSpace,
              Text(
                'Belum ada kunjungan yang dijadwalkan untuk hari ini',
                textAlign: TextAlign.center,
                style: context.textStyle.bodyMedium!.copyWith(
                  color: AppColors.labelSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        4,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: AppDimens.sizeM),
          child: const ShimmerCustom(size: Size(double.infinity, 80)),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, dynamic failure) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      child: FailureViewWidget(failure: failure),
    );
  }
}
