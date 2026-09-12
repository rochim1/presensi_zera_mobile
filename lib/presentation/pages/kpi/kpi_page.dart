import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

@RoutePage()
class KpiPage extends StatelessWidget {
  const KpiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final canViewKpi = context.select<AppCubit, bool>(
      (cubit) =>
          cubit.state.user.data?.hasPermission('kpi', action: 'view') ?? false,
    );
    if (!canViewKpi) {
      return const Scaffold(
        appBar: AppTopBar(title: 'Penilaian Kinerja (KPI)'),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Anda tidak memiliki izin untuk melihat KPI.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const AppTopBar(
        title: 'Penilaian Kinerja (KPI)',
        backgroundColor: AppColors.transparent,
      ),
      body: AutoTabsRouter.tabBar(
        routes: const [MyKpiTabRoute(), TeamKpiTabRoute()],
        builder: (context, child, tabController) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
                      tabs: const ['KPI Saya', 'KPI Tim'],
                      currentIndex: context.tabsRouter.activeIndex,
                      onTap: (index) {
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
