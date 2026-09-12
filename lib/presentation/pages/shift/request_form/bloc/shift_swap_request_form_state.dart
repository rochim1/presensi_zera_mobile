import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/_formz.dart';

part 'shift_swap_request_form_state.freezed.dart';

@freezed
abstract class ShiftSwapRequestFormState with _$ShiftSwapRequestFormState {
  const factory ShiftSwapRequestFormState({
    @Default(ShiftSwapRequestFormInputs()) ShiftSwapRequestFormInputs form,
    @Default(BaseState.initial()) BaseState<ShiftSchedule> shiftSchedule,
    @Default(BaseState.initial())
    BaseState<List<AvailableShiftForSwap>> targetShiftSchedules,
    @Default(BaseState.initial()) BaseState<void> submit,
    @Default('') String shiftScheduleId,
  }) = _ShiftSwapRequestFormState;
}
