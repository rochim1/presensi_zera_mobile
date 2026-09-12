import 'package:presensi_mobile/core/formz/_formz.dart';

enum StartTimeValidationError { empty }

class StartTimeInput extends AppFormzInput<DateTime?, StartTimeValidationError>
    with RequiredNullableValidator {
  const StartTimeInput.pure() : super.pure(null);

  const StartTimeInput.dirty(super.value) : super.dirty();

  @override
  StartTimeValidationError? validator(DateTime? value) {
    if (isNull(value)) {
      return StartTimeValidationError.empty;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case StartTimeValidationError.empty:
        return 'Jam Mulai wajib diisi';
      default:
        return null;
    }
  }
}
