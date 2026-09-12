import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum AttendanceRequestTypeValidationError { empty }

class AttendanceRequestTypeInput
    extends
        AppFormzInput<
          AttendanceRequestType?,
          AttendanceRequestTypeValidationError
        >
    with RequiredNullableValidator {
  const AttendanceRequestTypeInput.pure() : super.pure(null);

  const AttendanceRequestTypeInput.dirty(super.value) : super.dirty();

  @override
  AttendanceRequestTypeValidationError? validator(
    AttendanceRequestType? value,
  ) {
    if (isNull(value)) return AttendanceRequestTypeValidationError.empty;

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case AttendanceRequestTypeValidationError.empty:
        return 'Jenis Presensi wajib diisi';
      default:
        return null;
    }
  }
}
