part of 'delivery_page.dart';

@RoutePage()
class DeliveryCanceledTab extends StatefulWidget {
  const DeliveryCanceledTab({super.key});

  @override
  State<DeliveryCanceledTab> createState() => _DeliveryCanceledTabState();
}

class _DeliveryCanceledTabState extends State<DeliveryCanceledTab> {
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (AppUtility.isBottomInfinity(scrollController)) {
        context.read<TasksGetAllCanceledCubit>().getAllData();
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
    return BlocBuilder<TasksGetAllCanceledCubit, TasksGetAllCanceledState>(
      builder: (context, state) => SmartRefresher(
        controller: refreshController,
        onRefresh: () {
          context.read<TasksGetAllCanceledCubit>().initLoadAllData();
          context.read<SalesTargetCubit>().loadMyTarget();
          refreshController.refreshCompleted();
        },
        child: setList(state),
      ),
    );
  }

  Widget setList(TasksGetAllCanceledState state) {
    if (state.status.isLoaded) {
      return ListView.separated(
        itemCount: state.hasMax!
            ? state.tasks!.length
            : state.tasks!.length + 1,
        padding: const EdgeInsets.all(AppDimens.paddingMediumX),
        itemBuilder: (_, index) {
          final task = state.tasks?[index];

          if (index >= state.tasks!.length) return const ShimmerInfinity();
          if (task == null) return const SizedBox.shrink();

          return DeliveryTaskItemCard(
            task: task,
            onTap: () =>
                context.router.push(DeliveryDetailPageRoute(tasks: task)),
          );
        },
        separatorBuilder: (context, index) => AppDimens.paddingMediumX.hSpace,
      );
    } else if (state.status.isNotLoaded) {
      return FailureViewWidget(failure: state.failure);
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
