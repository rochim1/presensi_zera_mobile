import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppTabBar extends StatefulWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Map<int, int>? badges;
  final double? width;
  final double height;
  final bool? isScrollable;

  const AppTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.badges,
    this.width,
    this.height = 48,
    this.isScrollable,
  });

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.currentIndex,
    );
  }

  @override
  void didUpdateWidget(AppTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _tabController.animateTo(widget.currentIndex);
    }
    if (oldWidget.tabs.length != widget.tabs.length) {
      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.currentIndex,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool effectiveScrollable =
        widget.isScrollable ?? widget.tabs.length > 3;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double minTabWidth = constraints.maxWidth * 4 / 9;

        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.fillQuarternary,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: Theme(
            data: context.theme.copyWith(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: TabBar(
              controller: _tabController,
              onTap: widget.onTap,
              isScrollable: effectiveScrollable,
              tabAlignment: effectiveScrollable
                  ? TabAlignment.start
                  : TabAlignment.fill,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: effectiveScrollable
                  ? EdgeInsets.symmetric(horizontal: AppDimens.w12)
                  : null,
              indicator: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(widget.height / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: AppColors.labelPrimary,
              labelStyle: context.theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelColor: AppColors.labelSecondary,
              unselectedLabelStyle: context.theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
              tabs: List.generate(widget.tabs.length, (index) {
                final badgeCount = widget.badges?[index] ?? 0;
                return Tab(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: minTabWidth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.tabs[index]),
                        if (badgeCount > 0) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                badgeCount > 9 ? '9+' : badgeCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
