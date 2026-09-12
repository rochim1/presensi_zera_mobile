import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'my_attendance_state.freezed.dart';

@freezed
abstract class MyAttendanceState with _$MyAttendanceState {
  const factory MyAttendanceState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<Attendance> attendances,
    DateTime? startDate,
    DateTime? endDate,
    String? typePresensi,
    String? searchName,
  }) = _MyAttendanceState;
}
