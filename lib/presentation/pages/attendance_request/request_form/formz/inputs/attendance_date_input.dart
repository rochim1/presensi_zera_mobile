import 'package:presensi_mobile/core/formz/_formz.dart';

enum AttendanceDateValidationError { empty }

class AttendanceDateInput
    extends AppFormzInput<DateTime?, AttendanceDateValidationError>
    with RequiredNullableValidator {
  const AttendanceDateInput.pure() : super.pure(null);

  const AttendanceDateInput.dirty(super.value) : super.dirty();

  @override
  AttendanceDateValidationError? validator(DateTime? value) {
    if (isNull(value)) return AttendanceDateValidationError.empty;

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case AttendanceDateValidationError.empty:
        return 'Tanggal Presensi wajib diisi';
      default:
        return null;
    }
  }
}
