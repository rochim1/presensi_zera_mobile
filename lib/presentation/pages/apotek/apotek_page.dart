import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/widgets/apotek/apotek_item_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage()
class ApotekPage extends StatefulWidget {
  const ApotekPage({super.key});

  @override
  State<ApotekPage> createState() => ApotekPageState();
}

class ApotekPageState extends State<ApotekPage>
    with SingleTickerProviderStateMixin {
  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];
  final List<RefreshController> _refreshControllers = [
    RefreshController(),
    RefreshController(),
    RefreshController(),
  ];
  late TabController tabController;
  late ApotekGetAllDataCubit _cubit;
  int _currentTabIndex = 0;
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cubit = sl<ApotekGetAllDataCubit>()..initLoadAllData();

    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (tabController.index != _currentTabIndex) {
        _currentTabIndex = tabController.index;
        String? status;
        if (tabController.index == 1) status = 'active';
        if (tabController.index == 2) status = 'deleted';
        _cubit.filterByStatus(status);
      }
    });

    for (var controller in _scrollControllers) {
      controller.addListener(() {
        if (AppUtility.isBottomInfinity(controller)) {
          _cubit.getAllData();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    for (var controller in _refreshControllers) {
      controller.dispose();
    }
    tabController.dispose();
    _cubit.close();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppTopBar(
              title: 'Daftar Outlet',
              actions: [
                AppTopBarActionButton(
                  onTap: () =>
                      context.router.push(const ApotekMapsPageRoute()),
                  icon: Icons.map_rounded,
                ),
              ],
            ),
            floatingActionButton:
                BlocBuilder<ApotekGetAllDataCubit, ApotekGetAllDataState>(
                  builder: (ctxApt, _) {
                    return FloatingActionButton(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      onPressed: () async {
                        final result = await context.router.push<bool?>(
                          const ApotekAddFormRoute(),
                        );

                        if (!ctxApt.mounted) return;
                        if (result ?? false) {
                          ctxApt
                              .read<ApotekGetAllDataCubit>()
                              .initLoadAllData();
                        }
                      },
                      child: const Icon(
                        Icons.add_location_alt_outlined,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
            body: BlocBuilder<ApotekGetAllDataCubit, ApotekGetAllDataState>(
              builder: (context, state) => Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimens.paddingMediumX),
                    color: Colors.white,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari outlet...',
                        prefixIcon: Icon(PhosphorIcons.magnifyingGlass),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                          borderSide: BorderSide(color: AppColors.divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                          borderSide: BorderSide(color: AppColors.divider),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce?.cancel();
                        _debounce = Timer(const Duration(milliseconds: 500), () {
                          _searchQuery = value;
                          String? status;
                          if (_currentTabIndex == 1) status = 'active';
                          if (_currentTabIndex == 2) status = 'deleted';
                          _cubit.initLoadAllData(query: value, status: status);
                        });
                      },
                    ),
                  ),
                  Container(
                    color: AppColors.white,
                    child: TabBar(
                      controller: tabController,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.labelSecondary,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'Semua'),
                        Tab(text: 'Aktif'),
                        Tab(text: 'Nonaktif'),
                      ],
                    ),
                  ),
                  _buildStatsHeader(context, state),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        _buildTabContent(state, 0),
                        _buildTabContent(state, 1),
                        _buildTabContent(state, 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsHeader(BuildContext context, ApotekGetAllDataState state) {
    if (!state.status.isLoaded) return const SizedBox.shrink();

    final total = state.apoteks?.length ?? 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.paddingMediumX,
        AppDimens.paddingMediumX,
        AppDimens.paddingMediumX,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Data Dimuat',
            style: context.textStyle.bodyMedium?.copyWith(
              color: AppColors.labelSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$total Outlet',
              style: context.textStyle.titleSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(ApotekGetAllDataState state, int tabIndex) {
    return SmartRefresher(
      controller: _refreshControllers[tabIndex],
      onRefresh: () {
        String? status;
        if (tabIndex == 1) status = 'active';
        if (tabIndex == 2) status = 'deleted';
        _cubit.initLoadAllData(query: _searchQuery, status: status);
        _refreshControllers[tabIndex].refreshCompleted();
      },
      child: setList(state, tabIndex),
    );
  }

  Widget setList(ApotekGetAllDataState state, int tabIndex) {
    if (state.status.isLoaded) {
      if (state.apoteks == null || state.apoteks!.isEmpty) {
        return const Center(child: Text("Tidak ada outlet ditemukan."));
      }
      return ListView.separated(
        itemCount: state.hasMax!
            ? state.apoteks!.length
            : state.apoteks!.length + 1,
        padding: const EdgeInsets.all(AppDimens.paddingMediumX),
        controller: _scrollControllers[tabIndex],
        itemBuilder: (_, index) {
          if (index >= state.apoteks!.length) return const ShimmerInfinity();
          final apotek = state.apoteks?[index];

          if (apotek == null) {
            return const SizedBox.shrink();
          }

          return ApotekItemCard(
            apotek: apotek,
            index: index,
            onTap: () =>
                context.router.push(ApotekDetailPageRoute(apotek: apotek)),
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
