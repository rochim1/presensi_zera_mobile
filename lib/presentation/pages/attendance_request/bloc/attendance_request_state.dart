import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_request_state.freezed.dart';

@freezed
abstract class AttendanceRequestState with _$AttendanceRequestState {
  const factory AttendanceRequestState({
    DateTime? filterDate,
    DateTime? startDate,
    DateTime? endDate,
    String? filterStatus,
    String? filterJenisRequest,
    @Default(0) int refreshCounter,
  }) = _AttendanceRequestState;
}
