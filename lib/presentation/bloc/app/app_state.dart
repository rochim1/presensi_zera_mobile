import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const AppState._();
  const factory AppState({
    @Default(BaseState.initial()) BaseState<Attendance> activeAttendance,
    @Default(BaseState.initial()) BaseState<AuthSession> session,
    @Default(BaseState.initial()) BaseState<Setting> setting,
    @Default(BaseState.initial()) BaseState<User> user,
    @Default(BaseState.initial())
    BaseState<EffectiveSchedule> effectiveSchedule,
    String? overtimeStartTime,
    String? checkedOutDate,
  }) = _AppState;

  bool get isOvertimeActive =>
      overtimeStartTime != null && overtimeStartTime!.isNotEmpty;
  bool get hasCheckedOutToday {
    if (checkedOutDate == null) return false;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return checkedOutDate == today;
  }

  /// Overtime may only be offered after the active-attendance lookup has
  /// completed successfully and the server-synchronised checkout marker exists.
  bool get canStartOvertime {
    final attendance = activeAttendance.data;
    final hasOngoingAttendance =
        attendance != null && attendance.jamPulang == null;
    return activeAttendance.isSuccess &&
        hasCheckedOutToday &&
        !hasOngoingAttendance;
  }
}
