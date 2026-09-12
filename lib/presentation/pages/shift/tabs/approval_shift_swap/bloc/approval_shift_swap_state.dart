import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/reason_input.dart';

part 'approval_shift_swap_state.freezed.dart';

@freezed
abstract class ApprovalShiftSwapState with _$ApprovalShiftSwapState {
  const factory ApprovalShiftSwapState({
    DateTime? filterDate,
    @Default(BasePaginatedState.initial())
    BasePaginatedState<ShiftSwapRequest> swapRequests,
    @Default(null) RequestStatus? approvalAction,
    @Default(ReasonInput.pure()) ReasonInput reasonInput,
    @Default(BaseState.initial()) BaseState<void> approvalSubmit,
  }) = _ApprovalShiftSwapState;
}
