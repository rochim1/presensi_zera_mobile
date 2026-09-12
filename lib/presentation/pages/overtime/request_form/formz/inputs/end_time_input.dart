import 'package:presensi_mobile/core/formz/_formz.dart';

enum EndTimeValidationError { empty }

class EndTimeInput extends AppFormzInput<DateTime?, EndTimeValidationError>
    with RequiredNullableValidator {
  const EndTimeInput.pure() : super.pure(null);

  const EndTimeInput.dirty(super.value) : super.dirty();

  @override
  EndTimeValidationError? validator(DateTime? value) {
    if (isNull(value)) {
      return EndTimeValidationError.empty;
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case EndTimeValidationError.empty:
        return 'Jam Selesai wajib diisi';
      default:
        return null;
    }
  }
}
