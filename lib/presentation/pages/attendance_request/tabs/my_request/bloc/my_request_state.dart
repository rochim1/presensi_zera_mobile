import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'my_request_state.freezed.dart';

@freezed
abstract class MyAttendanceRequestState with _$MyAttendanceRequestState {
  const factory MyAttendanceRequestState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<AttendanceRequest> attendanceRequests,
    @Default(null) AttendanceRequestStatus? filterStatus,
    @Default(null) DateTime? filterDate,
  }) = _MyAttendanceRequestState;
}
