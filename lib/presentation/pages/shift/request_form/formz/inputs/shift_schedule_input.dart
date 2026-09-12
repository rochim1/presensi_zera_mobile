import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum ShiftScheduleValidationError { empty }

class ShiftScheduleInput
    extends AppFormzInput<ShiftSchedule?, ShiftScheduleValidationError>
    with RequiredNullableValidator {
  const ShiftScheduleInput.pure() : super.pure(null);

  const ShiftScheduleInput.dirty(super.value) : super.dirty();

  @override
  ShiftScheduleValidationError? validator(ShiftSchedule? value) {
    if (isNull(value)) {
      return ShiftScheduleValidationError.empty;
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case ShiftScheduleValidationError.empty:
        return 'Jadwal Shift wajib dipilih';
      default:
        return null;
    }
  }
}
