import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import '../form/check_in_form.dart';

part 'check_in_state.freezed.dart';

@freezed
abstract class CheckInState with _$CheckInState {
  const factory CheckInState({
    @Default(CheckInForm()) CheckInForm form,
    @Default(BaseState.initial()) BaseState<void> checkIn,
    @Default(BaseState.initial()) BaseState<AppAddress> currentAddress,
    @Default(AttendanceType.daily) AttendanceType presenceType,
    @Default('') String currentTime,
    @Default(SettingAttendanceMode.foto) SettingAttendanceMode attendanceMode,
  }) = _CheckInState;
}
