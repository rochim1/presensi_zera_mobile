import 'package:presensi_mobile/core/formz/_formz.dart';

enum EmergencyContactValidationError { empty, invalid }

class EmergencyContactInput
    extends AppFormzInput<String?, EmergencyContactValidationError> {
  const EmergencyContactInput.pure() : super.pure('');

  const EmergencyContactInput.dirty(super.value) : super.dirty();

  @override
  EmergencyContactValidationError? validator(String? value) {
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case EmergencyContactValidationError.invalid:
        return 'Format kontak tidak valid';
      default:
        return null;
    }
  }
}
