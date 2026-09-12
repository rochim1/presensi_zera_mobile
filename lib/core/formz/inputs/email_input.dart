import '../_formz.dart';

enum EmailValidationError { empty, invalid }

class EmailInput extends AppFormzInput<String, EmailValidationError>
    with RequiredValidator, EmailValidator {
  EmailInput.pure() : super.pure('');

  EmailInput.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    if (isEmpty(value)) return EmailValidationError.empty;
    if (!isValidEmail(value)) return EmailValidationError.invalid;
    return null;
  }

  @override
  String? get errorMessage {
    switch (error) {
      case EmailValidationError.empty:
        return 'Email wajib diisi';
      case EmailValidationError.invalid:
        return 'Email tidak valid';
      default:
        return null;
    }
  }
}
