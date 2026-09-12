import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'notification_state.freezed.dart';

@freezed
abstract class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<AppNotification> notifications,
    @Default(BaseState.initial()) BaseState<void> markAsRead,
    @Default(BaseState.initial()) BaseState<void> delete,
  }) = _NotificationState;
}
