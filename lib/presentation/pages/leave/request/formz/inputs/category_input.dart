import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum LeaveCategoryValidationError { empty }

class LeaveCategoryInput
    extends AppFormzInput<LeaveCategory?, LeaveCategoryValidationError>
    with RequiredNullableValidator {
  const LeaveCategoryInput.pure() : super.pure(null);

  const LeaveCategoryInput.dirty(super.value) : super.dirty();

  @override
  LeaveCategoryValidationError? validator(LeaveCategory? value) {
    if (isNull(value)) return LeaveCategoryValidationError.empty;

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case LeaveCategoryValidationError.empty:
        return 'Kategori Cuti wajib diisi';
      default:
        return null;
    }
  }
}
