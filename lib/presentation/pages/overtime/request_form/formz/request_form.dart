import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '_formz.dart';

part 'request_form.freezed.dart';

@freezed
abstract class OvertimeRequestFormInputs
    with _$OvertimeRequestFormInputs, FormzMixin {
  const OvertimeRequestFormInputs._();

  const factory OvertimeRequestFormInputs({
    @Default(DateInput.pure()) DateInput date,
    @Default(StartTimeInput.pure()) StartTimeInput startTime,
    @Default(EndTimeInput.pure()) EndTimeInput endTime,
    @Default(ReasonInput.pure()) ReasonInput reason,
    @Default(AttachmentsInput.pure()) AttachmentsInput attachments,
  }) = _OvertimeRequestFormInputs;

  @override
  List<FormzInput> get inputs => [
    date,
    startTime,
    endTime,
    reason,
    attachments,
  ];
}
