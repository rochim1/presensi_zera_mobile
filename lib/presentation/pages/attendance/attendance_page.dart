import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'widgets/attendance_period_filter.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            title: ('Presensi').tr(context),
            centerTitle: false,
            subtitle: ('Kelola kehadiran dan riwayat presensi Anda').tr(
              context,
            ),
            actions: [
              IconButton(
                tooltip: ('Perbarui pengaturan presensi').tr(context),
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.white,
                  disabledForegroundColor: AppColors.white.withValues(
                    alpha: 0.45,
                  ),
                  backgroundColor: AppColors.white.withValues(alpha: 0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
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
                    child: HrText(
                      _refreshing
                          ? 'Memperbarui izin presensi…'
                          : !_verified
                          ? 'Izin tim belum dapat diperbarui. Periksa koneksi lalu ketuk tombol perbarui.'
                          : canViewTeam
                          ? 'Anda dapat melihat presensi tim sesuai izin admin. Ringkasan di bawah adalah presensi Anda.'
                          : 'Ringkasan dan riwayat kehadiran Anda.',
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.labelSecondary,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: AttendancePeriodFilter(
                    startDate: state.startDate,
                    endDate: state.endDate,
                    type: state.typePresensi,
                    searchName: state.searchName,
                    showSearchName:
                        canViewTeam && context.tabsRouter.activeIndex == 1,
                    onApply: (start, end, type, name) => cubit.applyFilters(
                      startDate: start,
                      endDate: end,
                      typePresensi: type,
                      searchName: name,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
