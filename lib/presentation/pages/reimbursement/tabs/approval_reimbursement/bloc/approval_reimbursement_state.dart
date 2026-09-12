import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/reason_input.dart';

part 'approval_reimbursement_state.freezed.dart';

@freezed
abstract class ApprovalReimbursementState with _$ApprovalReimbursementState {
  const factory ApprovalReimbursementState({
    DateTime? filterDate,
    @Default(BasePaginatedState.initial())
    BasePaginatedState<Reimbursement> reimbursements,
    Reimbursement? selectedReimbursement,
    @Default(AttendanceRequestApprovalAction.none)
    AttendanceRequestApprovalAction approvalAction,
    @Default(ReasonInput.pure()) ReasonInput reasonInput,
    @Default(BaseState.initial()) BaseState<Object?> approvalSubmit,
  }) = _ApprovalReimbursementState;
}
