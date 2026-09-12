import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'my_leave_state.freezed.dart';

@freezed
abstract class MyLeaveState with _$MyLeaveState {
  const factory MyLeaveState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<LeaveRequest> leaveRequests,
    @Default(null) LeaveStatus? filterLeaveStatus,
    @Default(null) DateTime? filterDate,
  }) = _MyLeaveState;
}
