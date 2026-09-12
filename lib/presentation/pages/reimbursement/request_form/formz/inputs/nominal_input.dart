import 'package:presensi_mobile/core/formz/_formz.dart';

enum NominalValidationError { empty }

class NominalInput extends AppFormzInput<double?, NominalValidationError>
    with RequiredNullableValidator {
  const NominalInput.pure() : super.pure(null);

  const NominalInput.dirty(super.value) : super.dirty();

  @override
  NominalValidationError? validator(double? value) {
    if (isNull(value)) return NominalValidationError.empty;
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case NominalValidationError.empty:
        return 'Nominal wajib diisi';
      default:
        return null;
    }
  }
}
