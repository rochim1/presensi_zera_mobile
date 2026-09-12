import 'package:presensi_mobile/core/formz/_formz.dart';

enum ReasonValidationError { max, empty }

class ReasonInput extends AppFormzInput<String?, ReasonValidationError>
    with MaxLengthValidator, RequiredNullableValidator {
  const ReasonInput.pure() : super.pure('');

  const ReasonInput.dirty(super.value) : super.dirty();

  static const int maxLength = 2480;

  @override
  ReasonValidationError? validator(String? value) {
    final trimValue = value?.trim() ?? '';

    if (isNull(value) || trimValue.isEmpty) {
      return ReasonValidationError.empty;
    }

    if (!hasMaxLength(trimValue, maxLength)) {
      return ReasonValidationError.max;
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case ReasonValidationError.max:
        return 'Alasan tidak boleh lebih dari $maxLength karakter';
      case ReasonValidationError.empty:
        return 'Alasan wajib diisi';
      default:
        return null;
    }
  }
}
