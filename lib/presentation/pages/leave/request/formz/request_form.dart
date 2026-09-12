import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '_formz.dart';

part 'request_form.freezed.dart';

@freezed
abstract class LeaveRequestForm with _$LeaveRequestForm, FormzMixin {
  const LeaveRequestForm._();

  const factory LeaveRequestForm({
    @Default(LeaveCategoryInput.pure()) LeaveCategoryInput category,
    @Default(LeaveModeInput.pure()) LeaveModeInput mode,
    @Default(StartDateInput.pure()) StartDateInput startDate,
    @Default(EndDateInput.pure()) EndDateInput endDate,
    @Default(ReasonInput.pure()) ReasonInput reason,
    @Default(DelegationInput.pure()) DelegationInput delegation,
    @Default(EmergencyContactInput.pure())
    EmergencyContactInput emergencyContact,
    @Default(AttachmentInput.pure()) AttachmentInput attachment,
  }) = _LeaveRequestForm;

  bool get isHalfDay => mode.value?.isHalfDay ?? false;
  bool get needsAttachment => category.value?.isNeedAttachment ?? false;
  bool get needsMode => category.value?.isAllowHalfDay ?? false;

  @override
  List<FormzInput> get inputs {
    final baseInputs = <FormzInput>[
      category,
      startDate,
      reason,
      emergencyContact,
    ];

    if (needsMode) {
      baseInputs.add(mode);
    }

    if (!isHalfDay) {
      baseInputs.add(endDate);
    }

    if (needsAttachment) {
      baseInputs.add(attachment);
    }

    return baseInputs;
  }
}
