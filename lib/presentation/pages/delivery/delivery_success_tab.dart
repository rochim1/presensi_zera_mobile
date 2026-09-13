part of 'delivery_page.dart';

@RoutePage()
class DeliverySuccessTab extends StatefulWidget {
  const DeliverySuccessTab({super.key, this.dateFilter});

  final DateTime? dateFilter;

  DateTime get effectiveDateFilter => dateFilter ?? DateTime.now();

  @override
  State<DeliverySuccessTab> createState() => _DeliverySuccessTabState();
}

class _DeliverySuccessTabState extends State<DeliverySuccessTab> {
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (AppUtility.isBottomInfinity(scrollController)) {
        context.read<TasksGetAllSuccessCubit>().getAllData(
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
    return BlocBuilder<TasksGetAllSuccessCubit, TasksGetAllSuccessState>(
      builder: (context, state) => SmartRefresher(
        controller: refreshController,
        onRefresh: () {
          context.read<TasksGetAllSuccessCubit>().initLoadAllData(
            widget.effectiveDateFilter,
          );
          context.read<SalesTargetCubit>().loadMyTarget();
          refreshController.refreshCompleted();
        },
        child: setList(context, state),
      ),
    );
  }

  Widget setList(BuildContext context, TasksGetAllSuccessState state) {
    if (state.status.isLoaded) {
      return ListView.separated(
        itemCount: state.hasMax!
            ? state.tasks!.length
            : state.tasks!.length + 1,
        padding: const EdgeInsets.all(AppDimens.paddingMediumX),
        itemBuilder: (_, index) {
          if (index >= state.tasks!.length) return const ShimmerInfinity();
          final task = state.tasks?[index];

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
