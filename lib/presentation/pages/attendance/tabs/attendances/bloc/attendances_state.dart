import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'attendances_state.freezed.dart';

@freezed
abstract class AttendancesState with _$AttendancesState {
  const factory AttendancesState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<Attendance> attendances,
    DateTime? startDate,
    DateTime? endDate,
    String? typePresensi,
    String? searchName,
  }) = _AttendancesState;
}
