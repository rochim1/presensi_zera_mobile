import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import '../formz/_formz.dart';

part 'request_state.freezed.dart';

@freezed
abstract class AttendanceRequestFormState with _$AttendanceRequestFormState {
  const factory AttendanceRequestFormState({
    @Default(AttendanceRequestFormInputs()) AttendanceRequestFormInputs form,
    @Default(BaseState.initial()) BaseState<void> submit,
    @Default(BaseState.initial()) BaseState<List<ShiftSchedule>> shiftSchedules,
  }) = _AttendanceRequestFormState;
}
