import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'attendance_state.freezed.dart';

@freezed
abstract class AttendanceState with _$AttendanceState {
  const factory AttendanceState({
    DateTime? startDate,
    DateTime? endDate,
    String? typePresensi,
    String? searchName,
    @Default(BaseState.initial())
    BaseState<List<AttendanceStatistic>> statistics,
  }) = _AttendanceState;
}
