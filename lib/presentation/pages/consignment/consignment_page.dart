import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'consignment_resume.dart';

@RoutePage()
class ConsignmentPage extends StatefulWidget {
  const ConsignmentPage({super.key});

  @override
  State<ConsignmentPage> createState() => _ConsignmentPageState();
}

class _ConsignmentPageState extends State<ConsignmentPage> {
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (AppUtility.isBottomInfinity(scrollController)) {
        context.read<TasksGetAllPerjalananCubit>().getAllData();
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
    return Scaffold(
      appBar: AppBarWidget(
        titleText: 'Perjalanan',
        actions: [
          BlocBuilder<TasksGetAllPerjalananCubit, TasksGetAllPerjalananState>(
            builder: (context, state) {
              return ButtonAddAppBar(
                onTap: () async {
                  final answer = await AppModalDialog.datePicker(
                    context,
                    initialDate: state.filter?.taskDateAssigned?.toDateTime,
                  );

                  if (answer == null) return;
                  if (!context.mounted) return;
                  context.read<TasksGetAllPerjalananCubit>().initLoadAllData(
                    answer,
                  );
                },
                icon: const Icon(Icons.date_range),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: AppDimens.bottomNavbarHeight,
            color: AppColors.primary,
          ),
          Container(
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimens.radiusLarge),
              ),
            ),
            child:
                BlocBuilder<
                  TasksGetAllPerjalananCubit,
                  TasksGetAllPerjalananState
                >(
                  builder: (context, state) => SmartRefresher(
                    controller: refreshController,
                    onRefresh: () {
                      context
                          .read<TasksGetAllPerjalananCubit>()
                          .initLoadAllData();
                      refreshController.refreshCompleted();
                    },
                    child: setList(context, state),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget setList(BuildContext context, TasksGetAllPerjalananState state) {
    if (state.status.isLoaded) {
      return ListView.separated(
        controller: scrollController,
        itemCount: state.hasMax!
            ? state.tasks!.length
            : state.tasks!.length + 1,
        padding: const EdgeInsets.all(AppDimens.paddingMediumX),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ConsignmentResume(
              tasks: state.tasks?.first,
              dateFilter:
                  state.filter?.taskDateAssigned?.toDateTime ?? DateTime.now(),
            );
          }
          if (index >= state.tasks!.length) return const ShimmerInfinity();
          return ItemCardConsignment(tasks: state.tasks?[index]);
        },
        separatorBuilder: (_, _) => AppDimens.paddingMediumX.hSpace,
      );
    } else if (state.status.isNotLoaded) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.paddingMediumX),
            child: ConsignmentResume(
              tasks: null,
              dateFilter: state.filter!.taskDateAssigned!.toDateTime!,
            ),
          ),
          AppDimens.size4XL.hSpace,
          FailureViewWidget(failure: state.failure),
        ],
      );
    } else {
      return ListView.separated(
        itemCount: 6,
        padding: const EdgeInsets.all(AppDimens.paddingMediumX),
        itemBuilder: (_, int index) {
          if (index == 0) {
            return ConsignmentResume(
              dateFilter: state.filter!.taskDateAssigned!.toDateTime!,
              tasks: null,
            );
          }
          return const ShimmerListItem();
        },
        separatorBuilder: (_, _) => AppDimens.paddingMediumX.hSpace,
      );
    }
  }
}
