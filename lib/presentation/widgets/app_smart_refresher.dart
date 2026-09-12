import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AppSmartRefresher extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final bool enablePullUp;
  final bool enablePullDown;
  final bool hasReachedMax;
  final ScrollController? scrollController;

  const AppSmartRefresher({
    super.key,
    required this.child,
    this.onRefresh,
    this.onLoadMore,
    this.enablePullUp = false,
    this.enablePullDown = true,
    this.hasReachedMax = false,
    this.scrollController,
  });

  @override
  State<AppSmartRefresher> createState() => _AppSmartRefresherState();
}

class _AppSmartRefresherState extends State<AppSmartRefresher> {
  final RefreshController _controller = RefreshController();

  Future<void> _handleRefresh() async {
    try {
      await widget.onRefresh?.call();
      _controller.refreshCompleted();
      _controller.resetNoData();
    } catch (_) {
      _controller.refreshFailed();
    }
  }

  Future<void> _handleLoadMore() async {
    try {
      await widget.onLoadMore?.call();
      if (widget.hasReachedMax) {
        _controller.loadNoData();
      } else {
        _controller.loadComplete();
      }
    } catch (_) {
      _controller.loadFailed();
    }
  }

  @override
  void didUpdateWidget(AppSmartRefresher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasReachedMax != oldWidget.hasReachedMax) {
      if (widget.hasReachedMax) {
        _controller.loadNoData();
      } else {
        _controller.resetNoData();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _controller,
      enablePullDown: widget.enablePullDown,
      enablePullUp: widget.enablePullUp,
      scrollController: widget.scrollController,
      onRefresh: widget.onRefresh != null ? _handleRefresh : null,
      onLoading: widget.onLoadMore != null ? _handleLoadMore : null,
      footer: const ClassicFooter(
        idleText: "Tarik untuk muat lagi",
        loadingText: "Memuat...",
        noDataText: "Tidak ada data lagi",
        failedText: "Gagal, coba lagi",
        canLoadingText: "Lepas untuk memuat lagi",
      ),
      child: widget.child,
    );
  }
}
