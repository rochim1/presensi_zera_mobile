import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum AttendanceTypeValidationError { empty }

class AttendanceTypeInput
    extends AppFormzInput<AttendanceType?, AttendanceTypeValidationError>
    with RequiredNullableValidator {
  const AttendanceTypeInput.pure() : super.pure(null);

  const AttendanceTypeInput.dirty(super.value) : super.dirty();

  @override
  AttendanceTypeValidationError? validator(AttendanceType? value) {
    if (isNull(value)) return AttendanceTypeValidationError.empty;

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case AttendanceTypeValidationError.empty:
        return 'Jenis Presensi wajib diisi';
      default:
        return null;
    }
  }
}
