import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import 'bloc/payroll_state.dart';

@RoutePage()
class PayrollPage extends StatelessWidget {
  const PayrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PayrollCubit>()..init(),
      child: const PayrollView(),
    );
  }
}

class PayrollView extends StatelessWidget {
  const PayrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayrollCubit, PayrollState>(
      buildWhen: (previous, current) =>
          previous.isApprover != current.isApprover,
      builder: (context, state) {
        if (!state.isApprover) {
          // If not approver, show the normal view (using MyPayrollPage indirectly)
          // Wait, MyPayrollPage is a separate route, but here we can just render its content directly
          // or we can push it, but we can't do that easily inside a builder without a router.
          // Let's just use the MyPayrollPage widget since it expects PayrollCubit in context
          return Scaffold(
            appBar: AppTopBar(
              title: 'Slip Gaji',
              backgroundColor: AppColors.transparent,
              actions: [const _PayrollMoreMenu(showApproval: false)],
            ),
            body: const MyPayrollPage(),
          );
        }

        return AutoTabsRouter.tabBar(
          routes: const [MyPayrollPageRoute(), ApprovalPayrollPageRoute()],
          builder: (context, child, tabController) {
            final showingApproval = context.tabsRouter.activeIndex == 1;
            void showMyPayroll() {
              context.tabsRouter.setActiveIndex(0);
              tabController.animateTo(0);
            }

            return PopScope(
              canPop: !showingApproval,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop && showingApproval) showMyPayroll();
              },
              child: Scaffold(
                appBar: AppTopBar(
                  title: 'Slip Gaji',
                  backgroundColor: AppColors.transparent,
                  onBackTap: showingApproval ? showMyPayroll : null,
                  actions: [
                    _PayrollMoreMenu(
                      showApproval: true,
                      onApproval: () {
                        context.tabsRouter.setActiveIndex(1);
                        tabController.animateTo(1);
                      },
                    ),
                  ],
                ),
                body: NestedScrollView(
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
                              tabs: const ['Pengajuan Saya', 'Approval'],
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
      },
    );
  }
}

enum _PayrollMenuAction { downloads, approval }

class _PayrollMoreMenu extends StatelessWidget {
  final bool showApproval;
  final VoidCallback? onApproval;

  const _PayrollMoreMenu({required this.showApproval, this.onApproval});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_PayrollMenuAction>(
      tooltip: 'Menu slip gaji',
      padding: EdgeInsets.zero,
      offset: Offset(0, AppDimens.h40 + AppDimens.h4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.r12),
      ),
      child: Container(
        width: AppDimens.w40,
        height: AppDimens.w40,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppDimens.r12),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Icon(
          PhosphorIcons.dotsThreeVertical,
          color: AppColors.white,
          size: AppDimens.iconMedium,
        ),
      ),
      onSelected: (action) {
        switch (action) {
          case _PayrollMenuAction.downloads:
            context.router.push(const PayrollDownloadPageRoute());
          case _PayrollMenuAction.approval:
            onApproval?.call();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _PayrollMenuAction.downloads,
          child: Row(
            children: [
              Icon(PhosphorIcons.downloadSimple, size: 20),
              const SizedBox(width: 12),
              const Text('Unduhan Slip Gaji'),
            ],
          ),
        ),
        if (showApproval)
          PopupMenuItem(
            value: _PayrollMenuAction.approval,
            child: Row(
              children: [
                Icon(PhosphorIcons.checkCircle, size: 20),
                const SizedBox(width: 12),
                const Text('Approval Slip Gaji'),
              ],
            ),
          ),
      ],
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
