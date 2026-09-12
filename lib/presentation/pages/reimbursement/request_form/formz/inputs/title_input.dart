import 'package:presensi_mobile/core/formz/_formz.dart';

enum TitleValidationError { empty, max }

class TitleInput extends AppFormzInput<String?, TitleValidationError>
    with RequiredNullableValidator, MaxLengthValidator {
  const TitleInput.pure() : super.pure('');

  const TitleInput.dirty(super.value) : super.dirty();

  static const int maxLength = 255;

  @override
  TitleValidationError? validator(String? value) {
    if (isNull(value) || value!.isEmpty) {
      return TitleValidationError.empty;
    }
    if (!hasMaxLength(value, maxLength)) {
      return TitleValidationError.max;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case TitleValidationError.empty:
        return 'Judul wajib diisi';
      case TitleValidationError.max:
        return 'Judul tidak boleh lebih dari $maxLength karakter';
      default:
        return null;
    }
  }
}
