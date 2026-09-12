import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_data/core/failure/failure.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:presensi_mobile/core/_core.dart' hide NotificationState;
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import 'bloc/notification_state.dart';
import 'widgets/_widgets.dart';

@RoutePage()
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationCubit>()..init(),
      child: const NotificationView(),
    );
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      listenWhen: (previous, current) =>
          (previous.markAsRead != current.markAsRead &&
              current.markAsRead.isError) ||
          (previous.delete != current.delete && current.delete.isError),
      listener: (context, state) {
        if (state.markAsRead.isError) {
          AppBottomSheet.showError(
            context: context,
            message: state.markAsRead.failure?.message,
          );
        } else if (state.delete.isError) {
          AppBottomSheet.showError(
            context: context,
            message: state.delete.failure?.message,
          );
        }
      },
      child: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          final cubit = context.read<NotificationCubit>();
          final groupedNotifications = _groupNotifications(
            state.notifications.data,
          );

          return Scaffold(
            appBar: AppTopBar(
              title: 'Notifikasi',
              subtitle: 'Informasi dan pembaruan terbaru',
              centerTitle: false,
            ),
            body: AppSmartRefresher(
              onRefresh: () async => cubit.onRefresh(),
              onLoadMore: () async => cubit.fetchNextPage(),
              hasReachedMax: state.notifications.hasReachedMax,
              enablePullUp:
                  state.notifications.data.isNotEmpty &&
                  !state.notifications.hasReachedMax,
              child: CustomScrollView(
                slivers: [
                  if (state.notifications.isLoading &&
                      state.notifications.data.isEmpty)
                    _buildLoadingSliver()
                  else if (state.notifications.data.isEmpty)
                    _buildEmptySliver()
                  else
                    ...groupedNotifications.entries.map((entry) {
                      return SliverStickyHeader(
                        header: _buildHeader(context, entry.key),
                        sliver: SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimens.w16,
                          ),
                          sliver: SliverList.separated(
                            itemBuilder: (context, index) {
                              final item = entry.value[index];
                              return NotificationCard(
                                notification: item,
                                onTap: () => cubit.markAsReadById(item.id),
                                onDelete: () => cubit.deleteById(item.id),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                AppDimens.h12.hSpace,
                            itemCount: entry.value.length,
                          ),
                        ),
                      );
                    }),
                  SliverToBoxAdapter(child: AppDimens.h24.hSpace),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      height: AppDimens.h48,
      color: AppColors.bgPrimary,
      padding: EdgeInsets.fromLTRB(
        AppDimens.w16,
        AppDimens.h12,
        AppDimens.w16,
        AppDimens.h8,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: context.textTheme.titleSmall!.copyWith(
          color: AppColors.labelPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Map<String, List<AppNotification>> _groupNotifications(
    List<AppNotification> notifications,
  ) {
    final Map<String, List<AppNotification>> groups = {};
    for (var notification in notifications) {
      if (notification.createdAt == null) continue;
      final date = notification.createdAt!;
      final now = DateTime.now();
      String header;

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        header = 'Hari Ini';
      } else if (DateUtils.isSameDay(
        date,
        now.subtract(const Duration(days: 1)),
      )) {
        header = 'Kemarin';
      } else {
        header = date.format(pattern: 'dd MMMM yyyy');
      }

      groups.putIfAbsent(header, () => []).add(notification);
    }
    return groups;
  }

  Widget _buildLoadingSliver() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
      sliver: SliverList.separated(
        itemBuilder: (context, index) => NotificationCard.shimmer(),
        separatorBuilder: (context, index) => AppDimens.h12.hSpace,
        itemCount: 10,
      ),
    );
  }

  Widget _buildEmptySliver() {
    return const SliverFillRemaining(
      child: Center(child: AppErrorView(failure: NotFoundFailure())),
    );
  }
}
