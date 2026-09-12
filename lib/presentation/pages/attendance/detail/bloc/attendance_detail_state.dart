import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'attendance_detail_state.freezed.dart';

@freezed
abstract class AttendanceDetailState with _$AttendanceDetailState {
  const factory AttendanceDetailState({
    @Default('') String attendanceId,
    @Default(BaseState.initial()) BaseState<Attendance> attendance,
    @Default(BaseState.initial()) BaseState<AppAddress> checkInAddress,
    @Default(BaseState.initial()) BaseState<AppAddress> checkOutAddress,
  }) = _AttendanceDetailState;
}
