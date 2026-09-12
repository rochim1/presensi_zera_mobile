import 'package:presensi_mobile/core/formz/_formz.dart';
import 'package:presensi_domain/presensi_domain.dart';

enum CategoryValidationError { empty }

class CategoryInput
    extends AppFormzInput<ReimbursementCategory?, CategoryValidationError>
    with RequiredNullableValidator {
  const CategoryInput.pure() : super.pure(null);

  const CategoryInput.dirty(super.value) : super.dirty();

  @override
  CategoryValidationError? validator(ReimbursementCategory? value) {
    if (isNull(value)) return CategoryValidationError.empty;
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case CategoryValidationError.empty:
        return 'Kategori wajib diisi';
      default:
        return null;
    }
  }
}
