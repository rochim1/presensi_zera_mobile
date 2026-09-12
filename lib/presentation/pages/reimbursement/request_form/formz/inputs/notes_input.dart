import 'package:presensi_mobile/core/formz/_formz.dart';

enum NotesValidationError { max }

class NotesInput extends AppFormzInput<String?, NotesValidationError>
    with MaxLengthValidator {
  const NotesInput.pure() : super.pure('');

  const NotesInput.dirty(super.value) : super.dirty();

  static const int maxLength = 500;

  @override
  NotesValidationError? validator(String? value) {
    final trimValue = value?.trim() ?? '';

    if (trimValue.isEmpty) return null;

    if (!hasMaxLength(trimValue, maxLength)) {
      return NotesValidationError.max;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case NotesValidationError.max:
        return 'Catatan tidak boleh lebih dari $maxLength karakter';
      default:
        return null;
    }
  }
}
