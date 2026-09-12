import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/reason_input.dart';

part 'approval_state.freezed.dart';

@freezed
abstract class AttendanceRequestApprovalState
    with _$AttendanceRequestApprovalState {
  const factory AttendanceRequestApprovalState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<ApprovalHistory> approvals,
    @Default(null) DateTime? filterDate,
    @Default(AttendanceRequestApprovalAction.none)
    AttendanceRequestApprovalAction approvalAction,
    @Default(ReasonInput.pure()) ReasonInput reasonInput,
    @Default(BaseState.initial()) BaseState<void> approvalSubmit,
  }) = _AttendanceRequestApprovalState;
}
