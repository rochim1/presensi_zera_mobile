import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

@RoutePage()
class ShiftPage extends StatelessWidget {
  const ShiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ShiftCubit>()..init(),
      child: const ShiftView(),
    );
  }
}

class ShiftView extends StatefulWidget {
  const ShiftView({super.key});

  @override
  State<ShiftView> createState() => _ShiftViewState();
}

class _ShiftViewState extends State<ShiftView> {
  bool _showingApproval = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftCubit, ShiftState>(
      builder: (context, state) {
        return PopScope(
          canPop: !_showingApproval,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && _showingApproval) {
              setState(() => _showingApproval = false);
            }
          },
          child: Scaffold(
            appBar: AppTopBar(
              title: _showingApproval ? 'Approval Tukar Shift' : 'Shift',
              backgroundColor: AppColors.transparent,
              onBackTap: _showingApproval
                  ? () => setState(() => _showingApproval = false)
                  : null,
              actions: [
                AppApprovalNavigationButton(
                  showingApproval: _showingApproval,
                  returnLabel: 'Shift Saya',
                  onTap: () =>
                      setState(() => _showingApproval = !_showingApproval),
                ),
              ],
            ),
            body: _showingApproval
                ? const ApprovalShiftSwapPage()
                : AutoTabsRouter.tabBar(
                    routes: [MyShiftPageRoute(), MyShiftSwapPageRoute()],
                    builder: (context, child, tabController) =>
                        NestedScrollView(
                          headerSliverBuilder: (context, innerBoxIsScrolled) =>
                              [
                                // Removed old filter button
                                SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _StickyTabBarDelegate(
                                    child: ColoredBox(
                                      color: Theme.of(
                                        context,
                                      ).scaffoldBackgroundColor,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppDimens.w16,
                                          vertical: AppDimens.paddingSmallX,
                                        ),
                                        child: AppTabBar(
                                          tabs: const [
                                            'Shift Saya',
                                            'Request Tukar Shift',
                                          ],
                                          isScrollable: true,
                                          currentIndex:
                                              context.tabsRouter.activeIndex,
                                          onTap: (index) {
                                            context.tabsRouter.setActiveIndex(
                                              index,
                                            );
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
