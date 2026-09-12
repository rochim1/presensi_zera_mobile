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
      create: (_) => sl<AttendanceCubit>()..init(),
      child: const AttendanceView(),
    );
  }
}

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

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
        return Scaffold(
          appBar: AppTopBar(
            title: 'Presensi',
            showBackButton: true,
            onBackTap: () => context.tabsRouter.setActiveIndex(0),
            backgroundColor: AppColors.transparent,
          ),
          body: AutoTabsRouter.tabBar(
            routes: [MyAttendancePageRoute(), AttendancesPageRoute()],
            builder: (context, child, tabController) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
                            showSearchName: context.tabsRouter.activeIndex == 1,
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
                          tabs: const ['Presensi Saya', 'Presensi User'],
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
