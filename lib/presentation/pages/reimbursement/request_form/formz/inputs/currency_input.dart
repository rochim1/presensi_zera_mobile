import 'package:presensi_mobile/core/formz/_formz.dart';
import 'package:presensi_domain/presensi_domain.dart';

enum CurrencyValidationError { empty }

class CurrencyInput
    extends AppFormzInput<CurrencySymbol?, CurrencyValidationError>
    with RequiredNullableValidator {
  const CurrencyInput.pure() : super.pure(null);

  const CurrencyInput.dirty(super.value) : super.dirty();

  @override
  CurrencyValidationError? validator(CurrencySymbol? value) {
    if (isNull(value)) return CurrencyValidationError.empty;
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case CurrencyValidationError.empty:
        return 'Mata Uang wajib diisi';
      default:
        return null;
    }
  }
}
