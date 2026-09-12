import 'package:presensi_mobile/core/formz/_formz.dart';

enum ReimbursementDateValidationError { empty }

class ReimbursementDateInput
    extends AppFormzInput<DateTime?, ReimbursementDateValidationError>
    with RequiredNullableValidator {
  const ReimbursementDateInput.pure() : super.pure(null);

  const ReimbursementDateInput.dirty(super.value) : super.dirty();

  @override
  ReimbursementDateValidationError? validator(DateTime? value) {
    if (isNull(value)) return ReimbursementDateValidationError.empty;
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case ReimbursementDateValidationError.empty:
        return 'Tanggal wajib diisi';
      default:
        return null;
    }
  }
}
