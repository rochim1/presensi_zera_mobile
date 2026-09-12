import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(BaseState.initial()) BaseState<void> breakIn,
    @Default(BaseState.initial()) BaseState<void> breakOut,
    @Default(BaseState.initial()) BaseState<int> notificationCount,
    @Default(BaseState.initial()) BaseState<int> unreadChatCount,
    @Default(BaseState.initial()) BaseState<int> unreadEmailCount,
    @Default(BaseState.initial()) BaseState<List<Announcement>> announcements,
  }) = _HomeState;
}
