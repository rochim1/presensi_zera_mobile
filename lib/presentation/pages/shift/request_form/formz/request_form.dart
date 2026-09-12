import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '_formz.dart';

part 'request_form.freezed.dart';

@freezed
abstract class ShiftSwapRequestFormInputs
    with _$ShiftSwapRequestFormInputs, FormzMixin {
  const ShiftSwapRequestFormInputs._();

  const factory ShiftSwapRequestFormInputs({
    @Default(ShiftScheduleInput.pure()) ShiftScheduleInput shiftSchedule,
    @Default(DateInput.pure()) DateInput date,
    @Default(TargetShiftScheduleInput.pure())
    TargetShiftScheduleInput targetShiftSchedule,
    @Default(ReasonInput.pure()) ReasonInput reason,
  }) = _ShiftSwapRequestFormInputs;

  @override
  List<FormzInput> get inputs => [
    shiftSchedule,
    date,
    targetShiftSchedule,
    reason,
  ];
}
