import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/reason_input.dart';

part 'approval_state.freezed.dart';

@freezed
abstract class LeaveApprovalState with _$LeaveApprovalState {
  const factory LeaveApprovalState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<LeaveRequest> leaveRequests,
    @Default(null) DateTime? filterDate,
    @Default(LeaveApprovalAction.none) LeaveApprovalAction approvalAction,
    @Default(ReasonInput.pure()) ReasonInput reasonInput,
    @Default(BaseState.initial()) BaseState<void> approvalSubmit,
  }) = _LeaveApprovalState;
}
