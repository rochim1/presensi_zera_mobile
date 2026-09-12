import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum TargetShiftScheduleValidationError { empty }

class TargetShiftScheduleInput
    extends
        AppFormzInput<
          AvailableShiftForSwap?,
          TargetShiftScheduleValidationError
        >
    with RequiredNullableValidator {
  const TargetShiftScheduleInput.pure() : super.pure(null);

  const TargetShiftScheduleInput.dirty(super.value) : super.dirty();

  @override
  TargetShiftScheduleValidationError? validator(AvailableShiftForSwap? value) {
    if (isNull(value)) {
      return TargetShiftScheduleValidationError.empty;
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case TargetShiftScheduleValidationError.empty:
        return 'Jadwal Shift Tujuan wajib dipilih';
      default:
        return null;
    }
  }
}
