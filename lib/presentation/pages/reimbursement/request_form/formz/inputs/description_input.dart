import 'package:presensi_mobile/core/formz/_formz.dart';

enum DescriptionValidationError { empty, max }

class DescriptionInput
    extends AppFormzInput<String?, DescriptionValidationError>
    with RequiredNullableValidator, MaxLengthValidator {
  const DescriptionInput.pure() : super.pure('');

  const DescriptionInput.dirty(super.value) : super.dirty();

  static const int maxLength = 2000;

  @override
  DescriptionValidationError? validator(String? value) {
    if (isNull(value) || value!.isEmpty) {
      return DescriptionValidationError.empty;
    }
    if (!hasMaxLength(value, maxLength)) {
      return DescriptionValidationError.max;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case DescriptionValidationError.empty:
        return 'Deskripsi wajib diisi';
      case DescriptionValidationError.max:
        return 'Deskripsi tidak boleh lebih dari $maxLength karakter';
      default:
        return null;
    }
  }
}
