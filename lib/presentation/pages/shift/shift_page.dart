import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

@RoutePage()
class ShiftPage extends StatelessWidget {
  final bool initialApproval;

  const ShiftPage({super.key, this.initialApproval = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ShiftCubit>()..init(),
      child: ShiftView(initialApproval: initialApproval),
    );
  }
}

class ShiftView extends StatefulWidget {
  final bool initialApproval;

  const ShiftView({super.key, this.initialApproval = false});

  @override
  State<ShiftView> createState() => _ShiftViewState();
}

class _ShiftViewState extends State<ShiftView> {
  late bool _showingApproval;

  @override
  void initState() {
    super.initState();
    _showingApproval = widget.initialApproval;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftCubit, ShiftState>(
      builder: (context, state) {
        return PopScope(
          canPop: !_showingApproval || widget.initialApproval,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && _showingApproval) {
              setState(() => _showingApproval = false);
            }
          },
          child: Scaffold(
            appBar: AppTopBar(
              title: (_showingApproval
                  ? ('Approval Tukar Shift').tr(context)
                  : ('Shift').tr(context)),
              centerTitle: false,
              subtitle: (_showingApproval
                  ? ('Tinjau pengajuan tukar shift karyawan').tr(context)
                  : ('Kelola jadwal dan pengajuan tukar shift Anda').tr(
                      context,
                    )),
              onBackTap: _showingApproval && !widget.initialApproval
                  ? () => setState(() => _showingApproval = false)
                  : null,
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
