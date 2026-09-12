import 'package:presensi_mobile/core/formz/_formz.dart';

enum EndDateValidationError { empty, invalidPast, beforeStart }

class EndDateInput extends AppFormzInput<DateTime?, EndDateValidationError>
    with RequiredNullableValidator {
  final DateTime? startDate;
  final bool isRequired;

  const EndDateInput.pure({this.startDate, this.isRequired = true})
    : super.pure(null);

  const EndDateInput.dirty(
    super.value, {
    this.startDate,
    this.isRequired = true,
  }) : super.dirty();

  @override
  EndDateValidationError? validator(DateTime? value) {
    if (!isRequired) return null;
    if (isNull(value)) return EndDateValidationError.empty;

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(value!.year, value.month, value.day);

    if (inputDate.isBefore(today)) {
      return EndDateValidationError.invalidPast;
    }

    if (startDate != null) {
      final start = DateTime(startDate!.year, startDate!.month, startDate!.day);

      if (inputDate.isBefore(start)) {
        return EndDateValidationError.beforeStart;
      }
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;

    switch (error) {
      case EndDateValidationError.empty:
        return 'Tanggal selesai wajib diisi';
      case EndDateValidationError.invalidPast:
        return 'Tanggal selesai tidak boleh sebelum hari ini';
      case EndDateValidationError.beforeStart:
        return 'Tanggal selesai tidak boleh sebelum tanggal mulai';
      default:
        return null;
    }
  }
}
