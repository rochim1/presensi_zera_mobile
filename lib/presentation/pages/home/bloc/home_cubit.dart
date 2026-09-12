import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/service/websocket_service.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final BreakIn breakInUseCase;
  final BreakOut breakOutUseCase;
  final GetAnnouncements getAnnouncementsUseCase;
  final GetUnreadNotificationsCount getUnreadNotificationsCountUseCase;
  final ChatGetConversationsUseCase chatGetConversationsUseCase;
  final CountUnreadEmailUsecase countUnreadEmailUseCase;
  final Logger logger;

  HomeCubit({
    required this.logger,
    required this.breakInUseCase,
    required this.breakOutUseCase,
    required this.getUnreadNotificationsCountUseCase,
    required this.getAnnouncementsUseCase,
    required this.chatGetConversationsUseCase,
    required this.countUnreadEmailUseCase,
  }) : super(const HomeState());

  void breakIn() async {
    if (state.breakIn.isLoading) return;
    emit(state.copyWith(breakIn: BaseState.loading()));

    final params = BreakInParams(jamMulai: DateTime.now());
    final result = await breakInUseCase.call(params);

    result.fold(
      (failure) {
        emit(state.copyWith(breakIn: BaseState.failure(failure)));
      },
      (_) {
        emit(state.copyWith(breakIn: BaseState.success(null)));
      },
    );
  }

  void breakOut() async {
    if (state.breakOut.isLoading) return;
    emit(state.copyWith(breakOut: BaseState.loading()));

    final params = BreakOutParams(jamMulai: DateTime.now());
    final result = await breakOutUseCase.call(params);

    result.fold(
      (failure) {
        emit(state.copyWith(breakOut: BaseState.failure(failure)));
      },
      (_) {
        emit(state.copyWith(breakOut: BaseState.success(null)));
      },
    );
  }

  Future<void> getUnreadNotificationsCount() async {
    emit(state.copyWith(notificationCount: BaseState.loading()));

    final result = await getUnreadNotificationsCountUseCase.call(NoParams());

    result.fold(
      (failure) {
        emit(state.copyWith(notificationCount: BaseState.failure(failure)));
      },
      (v) {
        emit(state.copyWith(notificationCount: BaseState.success(v)));
      },
    );
  }

  Future<void> getUnreadChatCount() async {
    emit(state.copyWith(unreadChatCount: BaseState.loading()));

    final result = await chatGetConversationsUseCase.call(page: 1, limit: 100);

    result.fold(
      (failure) {
        emit(state.copyWith(unreadChatCount: BaseState.failure(failure)));
      },
      (conversations) {
        int count = 0;
        for (var conv in conversations) {
          count += conv.unreadCount ?? 0;
        }
        emit(state.copyWith(unreadChatCount: BaseState.success(count)));
      },
    );
  }

  Future<void> getUnreadEmailCount() async {
    emit(state.copyWith(unreadEmailCount: BaseState.loading()));

    final result = await countUnreadEmailUseCase.call(NoParams());

    result.fold(
      (failure) {
        emit(state.copyWith(unreadEmailCount: BaseState.failure(failure)));
      },
      (count) {
        emit(state.copyWith(unreadEmailCount: BaseState.success(count)));
      },
    );
  }

  Future<void> getAnnouncements() async {
    emit(state.copyWith(announcements: BaseState.loading()));

    final params = GetAnnouncementsParams();
    final result = await getAnnouncementsUseCase.call(params);

    result.fold(
      (failure) {
        emit(state.copyWith(announcements: BaseState.failure(failure)));
      },
      (v) {
        emit(state.copyWith(announcements: BaseState.success(v)));
      },
    );
  }

  /// WebSocket notification listener — increment badge count in real-time
  void _onWsNotification(Map<String, dynamic> data) {
    final type = data['type']?.toString() ?? '';
    if (type == 'chat_message') {
      // Chat message received — refresh unread chat count
      getUnreadChatCount();
    } else if (type == 'email_received') {
      // Email received - refresh unread email count
      getUnreadEmailCount();
    } else {
      // Other notification — increment notification badge
      final currentCount = state.notificationCount.maybeWhen(
        success: (v) => v,
        orElse: () => 0,
      );
      emit(
        state.copyWith(notificationCount: BaseState.success(currentCount + 1)),
      );
    }
  }

  void init() {
    getUnreadNotificationsCount();
    getAnnouncements();
    getUnreadChatCount();
    getUnreadEmailCount();
    // Listen for real-time notifications via WebSocket
    WebSocketService.instance.addNotificationListener(_onWsNotification);
  }

  Future<void> onRefresh() async {
    await Future.wait([getUnreadNotificationsCount(), getAnnouncements(), getUnreadChatCount(), getUnreadEmailCount()]);
  }

  @override
  Future<void> close() {
    WebSocketService.instance.removeNotificationListener(_onWsNotification);
    return super.close();
  }
}
