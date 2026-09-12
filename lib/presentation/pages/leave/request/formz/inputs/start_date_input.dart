import 'package:presensi_mobile/core/formz/_formz.dart';

enum StartDateValidationError { empty, invalidPast }

class StartDateInput extends AppFormzInput<DateTime?, StartDateValidationError>
    with RequiredNullableValidator {
  const StartDateInput.pure() : super.pure(null);

  const StartDateInput.dirty(super.value) : super.dirty();

  @override
  StartDateValidationError? validator(DateTime? value) {
    if (isNull(value)) return StartDateValidationError.empty;

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(value!.year, value.month, value.day);

    if (inputDate.isBefore(today)) {
      return StartDateValidationError.invalidPast;
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;

    switch (error) {
      case StartDateValidationError.empty:
        return 'Tanggal mulai wajib diisi';
      case StartDateValidationError.invalidPast:
        return 'Tanggal mulai tidak boleh sebelum hari ini';
      default:
        return null;
    }
  }
}
