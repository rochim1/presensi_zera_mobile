import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/reason_input.dart';

part 'approval_state.freezed.dart';

@freezed
abstract class OvertimeRequestApprovalState
    with _$OvertimeRequestApprovalState {
  const factory OvertimeRequestApprovalState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<OvertimeRequest> overtimeRequests,
    @Default(null) DateTime? filterDate,
    @Default(AttendanceRequestApprovalAction.none)
    AttendanceRequestApprovalAction approvalAction,
    @Default(ReasonInput.pure()) ReasonInput reasonInput,
    @Default(BaseState.initial()) BaseState<void> approvalSubmit,
  }) = _OvertimeRequestApprovalState;
}
