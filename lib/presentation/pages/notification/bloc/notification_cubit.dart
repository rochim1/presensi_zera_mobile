import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart' hide NotificationState;

import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotifications getNotificationsUseCase;
  final MarkNotificationAsReadById markNotificationAsReadByIdUseCase;
  final DeleteNotificationById deleteNotificationByIdUseCase;
  final Logger logger;

  NotificationCubit({
    required this.logger,
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadByIdUseCase,
    required this.deleteNotificationByIdUseCase,
  }) : super(const NotificationState());

  static const int _limit = 10;

  GetNotificationParams _getNotificationParams({int page = 0}) =>
      GetNotificationParams(isMyNotif: true, page: page, limit: _limit);

  Future<void> getNotifications() async {
    if (state.notifications.isLoading) return;

    emit(state.copyWith(notifications: const BasePaginatedState.loading()));

    final result = await getNotificationsUseCase.call(_getNotificationParams());

    result.fold(
      (failure) {
        emit(
          state.copyWith(notifications: BasePaginatedState.failure(failure)),
        );
      },
      (value) {
        emit(
          state.copyWith(
            notifications: BasePaginatedState.success(
              data: value,
              page: 1,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void fetchNextPage() async {
    final current = state.notifications;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        notifications: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final params = _getNotificationParams(page: nextPage);
    final result = await getNotificationsUseCase.call(params);

    result.fold(
      (failure) {
        // Revert to success without advancing the page
        emit(
          state.copyWith(
            notifications: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<AppNotification>.from(current.data)..addAll(value);
        emit(
          state.copyWith(
            notifications: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  Future<void> markAsReadById(String id) async {
    final currentNotifs = state.notifications.data;
    final index = currentNotifs.indexWhere((n) => n.id == id);
    if (index == -1) return;

    final originalNotif = currentNotifs[index];
    if (originalNotif.isRead) return;

    // Optimistic update
    final updatedList = List<AppNotification>.from(currentNotifs);
    updatedList[index] = originalNotif.copyWith(isRead: true);
    emit(
      state.copyWith(
        notifications: BasePaginatedState.success(data: updatedList),
      ),
    );

    final result = await markNotificationAsReadByIdUseCase.call(id);

    result.fold(
      (failure) {
        // Rollback
        final rollbackList = List<AppNotification>.from(
          state.notifications.data,
        );
        final rIndex = rollbackList.indexWhere((n) => n.id == id);
        if (rIndex != -1) {
          rollbackList[rIndex] = originalNotif;
          emit(
            state.copyWith(
              notifications: BasePaginatedState.success(data: rollbackList),
              markAsRead: BaseState.failure(failure),
            ),
          );
        }
      },
      (_) {
        emit(state.copyWith(markAsRead: BaseState.success(null)));
      },
    );
  }

  Future<void> deleteById(String id) async {
    final currentNotifs = state.notifications.data;
    final index = currentNotifs.indexWhere((n) => n.id == id);
    if (index == -1) return;

    final originalNotif = currentNotifs[index];

    // Optimistic delete
    final updatedList = List<AppNotification>.from(currentNotifs)
      ..removeAt(index);
    emit(
      state.copyWith(
        notifications: BasePaginatedState.success(data: updatedList),
      ),
    );

    final result = await deleteNotificationByIdUseCase.call(id);

    result.fold(
      (failure) {
        // Rollback (insert back at the original index)
        final rollbackList = List<AppNotification>.from(
          state.notifications.data,
        );
        if (index <= rollbackList.length) {
          rollbackList.insert(index, originalNotif);
        } else {
          rollbackList.add(originalNotif);
        }
        emit(
          state.copyWith(
            notifications: BasePaginatedState.success(data: rollbackList),
            delete: BaseState.failure(failure),
          ),
        );
      },
      (_) {
        emit(state.copyWith(delete: BaseState.success(null)));
      },
    );
  }

  void init() {
    getNotifications();
  }

  Future<void> onRefresh() async {
    await getNotifications();
  }
}
