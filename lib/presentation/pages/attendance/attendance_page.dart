import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import 'bloc/attendance_state.dart';

@RoutePage()
class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AttendanceCubit>()
        ..currentUserId = context.read<AppCubit>().state.user.data?.id
        ..init(),
      child: const AttendanceView(),
    );
  }
}

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView>
    with WidgetsBindingObserver {
  bool _refreshing = true;
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshPolicy());
  }

  Future<void> _refreshPolicy() async {
    if (!mounted) return;
    setState(() {
      _refreshing = true;
      _verified = false;
    });
    final refreshed = await context.read<AppCubit>().getSetting();
    if (!mounted) return;
    if (context.read<AppCubit>().state.setting.data?.canViewTeamAttendance !=
        true) {
      _clearNameFilter();
    }
    setState(() {
      _refreshing = false;
      _verified = refreshed;
    });
  }

  void _clearNameFilter() {
    final cubit = context.read<AttendanceCubit>();
    final filter = cubit.state;
    if (filter.searchName == null) return;
    cubit.applyFilters(
      startDate: filter.startDate,
      endDate: filter.endDate,
      typePresensi: filter.typePresensi,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_refreshPolicy());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String _buildFilterSummary(AttendanceState state) {
    final List<String> filters = [];
    if (state.startDate != null && state.endDate != null) {
      filters.add(
        '${DateFormat('dd MMM yyyy').format(state.startDate!)} - ${DateFormat('dd MMM yyyy').format(state.endDate!)}',
      );
    } else {
      filters.add('Bulan Ini');
    }
    if (state.typePresensi != null) {
      filters.add(
        state.typePresensi![0].toUpperCase() + state.typePresensi!.substring(1),
      );
    }
    if (state.searchName != null && state.searchName!.isNotEmpty) {
      filters.add('Cari: ${state.searchName}');
    }
    return filters.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        final cubit = context.read<AttendanceCubit>();
        final appState = context.watch<AppCubit>().state;
        final canViewTeam =
            !_refreshing &&
            _verified &&
            appState.setting.data?.canViewTeamAttendance == true;
        return Scaffold(
          appBar: AppTopBar(
            title: 'Presensi',
            actions: [
              IconButton(
                tooltip: 'Perbarui pengaturan presensi',
                onPressed: _refreshing ? null : _refreshPolicy,
                icon: const Icon(Icons.refresh),
              ),
            ],
            showBackButton: true,
            onBackTap: () => context.tabsRouter.setActiveIndex(0),
            backgroundColor: AppColors.transparent,
          ),
          body: AutoTabsRouter.tabBar(
            key: ValueKey(canViewTeam),
            routes: [
              MyAttendancePageRoute(),
              if (canViewTeam) AttendancesPageRoute(),
            ],
            builder: (context, child, tabController) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      _refreshing
                          ? 'Memperbarui izin presensi…'
                          : !_verified
                          ? 'Izin tim belum dapat diperbarui. Periksa koneksi lalu ketuk tombol perbarui.'
                          : canViewTeam
                          ? 'Anda dapat melihat presensi tim sesuai izin admin. Ringkasan di bawah adalah presensi Anda.'
                          : 'Admin membatasi akses ke presensi Anda sendiri.',
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AttendanceFilterBottomSheet(
                            initialStartDate: state.startDate,
                            initialEndDate: state.endDate,
                            initialTypePresensi: state.typePresensi,
                            initialSearchName: state.searchName,
                            showSearchName:
                                canViewTeam &&
                                context.tabsRouter.activeIndex == 1,
                            onApply: (start, end, type, name) {
                              cubit.applyFilters(
                                startDate: start,
                                endDate: end,
                                typePresensi: type,
                                searchName: name,
                              );
                            },
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusMedium,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusMedium,
                          ),
                          border: Border.all(color: AppColors.dividerLight),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.filter_list,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _buildFilterSummary(state),
                                style: context.textStyle.bodyMedium?.copyWith(
                                  color: AppColors.labelPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.labelSecondary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: const AttendanceStatsCard(),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
                    child: ColoredBox(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.w16,
                          vertical: AppDimens.paddingSmallX,
                        ),
                        child: AppTabBar(
                          tabs: [
                            'Presensi Saya',
                            if (canViewTeam) 'Presensi Tim',
                          ],
                          currentIndex: context.tabsRouter.activeIndex,
                          onTap: (index) {
                            if (index == 0) _clearNameFilter();
                            context.tabsRouter.setActiveIndex(index);
                            tabController.animateTo(index);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              body: child,
            ),
          ),
        );
      },
    );
  }
}

/// Gives AppTabBar a fixed height so it can be used as a pinned SliverPersistentHeader.
/// Height = AppTabBar default (48) + vertical padding (8 * 2) = 64.
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  static const double _height = 64.0;

  const _StickyTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) => true;
}
