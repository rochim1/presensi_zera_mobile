import 'package:presensi_mobile/core/formz/_formz.dart';

enum DateValidationError { empty }

class DateInput extends AppFormzInput<DateTime?, DateValidationError>
    with RequiredNullableValidator {
  const DateInput.pure() : super.pure(null);

  const DateInput.dirty(super.value) : super.dirty();

  @override
  DateValidationError? validator(DateTime? value) {
    if (isNull(value)) return DateValidationError.empty;

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case DateValidationError.empty:
        return 'Tanggal wajib diisi';
      default:
        return null;
    }
  }
}
