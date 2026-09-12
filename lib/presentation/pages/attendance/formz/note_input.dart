import 'package:presensi_mobile/core/formz/_formz.dart';

enum NoteValidationError { max }

class NoteInput extends AppFormzInput<String, NoteValidationError>
    with MaxLengthValidator {
  const NoteInput.pure() : super.pure('');

  const NoteInput.dirty(super.value) : super.dirty();

  static const int maxLength = 2480;

  @override
  NoteValidationError? validator(String value) {
    final trimValue = value.trim();

    if (trimValue.isEmpty) return null;

    if (!hasMaxLength(trimValue, maxLength)) {
      return NoteValidationError.max;
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case NoteValidationError.max:
        return 'Catatan tidak boleh lebih dari $maxLength karakter';
      default:
        return null;
    }
  }
}
