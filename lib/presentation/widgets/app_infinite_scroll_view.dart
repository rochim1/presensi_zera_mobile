import 'package:flutter/material.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class AppInfiniteScrollView<T> extends StatelessWidget {
  final BasePaginatedState<T> state;
  final VoidCallback onFetchNext;
  final Future<void> Function()? onRefresh;
  final Widget Function(BuildContext, T)? itemBuilder;
  final Widget Function(BuildContext, T, int)? itemBuilderWithIndex;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Widget Function(BuildContext)? loadingBuilder;
  final Widget? emptyView;
  final List<Widget>? sliversBefore;
  final List<Widget>? sliversAfter;
  final EdgeInsetsGeometry? padding;
  final bool shrinksWrap;

  const AppInfiniteScrollView({
    super.key,
    required this.state,
    this.itemBuilder,
    this.itemBuilderWithIndex,
    required this.onFetchNext,
    this.onRefresh,
    this.separatorBuilder,
    this.loadingBuilder,
    this.emptyView,
    this.sliversBefore,
    this.sliversAfter,
    this.padding,
    this.shrinksWrap = false,
  }) : assert(
         itemBuilder != null || itemBuilderWithIndex != null,
         'Either itemBuilder or itemBuilderWithIndex must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return AppSmartRefresher(
      onLoadMore: () async => onFetchNext(),
      onRefresh: onRefresh,
      hasReachedMax: state.hasReachedMax,
      enablePullUp: !state.isError && state.data.isNotEmpty,
      enablePullDown: onRefresh != null,
      child: CustomScrollView(
        shrinkWrap: shrinksWrap,
        slivers: [
          if (sliversBefore != null) ...sliversBefore!,
          SliverPadding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: AppDimens.w16),
            sliver: _buildBody(context),
          ),
          if (sliversAfter != null) ...sliversAfter!,
          SliverToBoxAdapter(child: AppDimens.h16.hSpace),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (state.isLoading) {
      return _buildLoadingSection(context);
    }

    if (state.isError) {
      return _buildErrorSection(context, state.failure!);
    }

    if (state.data.isEmpty) {
      return _buildEmptySection(context);
    }

    return _buildListSection(context);
  }

  Widget _buildLoadingSection(BuildContext context) {
    if (loadingBuilder != null) {
      return loadingBuilder!(context);
    }

    return SliverList.separated(
      itemBuilder: (context, index) =>
          AppShimmer.box(height: 80, width: double.infinity),
      separatorBuilder: (context, index) => AppDimens.h12.hSpace,
      itemCount: 5,
    );
  }

  Widget _buildErrorSection(BuildContext context, Failure failure) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: AppDimens.h72),
        child: AppErrorView(failure: failure, onRetry: onRefresh),
      ),
    );
  }

  Widget _buildEmptySection(BuildContext context) {
    return SliverToBoxAdapter(
      child:
          emptyView ??
          Padding(
            padding: EdgeInsets.only(top: AppDimens.h72),
            child: AppErrorView(failure: const NotFoundFailure()),
          ),
    );
  }

  Widget _buildListSection(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverList.separated(
          itemBuilder: (context, index) {
            final item = state.data[index];
            if (itemBuilderWithIndex != null) {
              return itemBuilderWithIndex!(context, item, index);
            }
            return itemBuilder!(context, item);
          },
          separatorBuilder: (context, index) =>
              separatorBuilder?.call(context, index) ?? AppDimens.h12.hSpace,
          itemCount: state.data.length,
        ),
      ],
    );
  }
}
