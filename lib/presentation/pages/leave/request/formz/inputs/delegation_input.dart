import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum DelegationValidationError { invalid }

class DelegationInput extends AppFormzInput<User?, DelegationValidationError> {
  const DelegationInput.pure() : super.pure(null);

  const DelegationInput.dirty(super.value) : super.dirty();

  @override
  DelegationValidationError? validator(User? value) {
    return null;
  }

  @override
  String? get errorMessage {
    return null;
  }
}
