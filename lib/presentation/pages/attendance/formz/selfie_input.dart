import 'package:image_picker/image_picker.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum SelfieValidationError { empty }

class SelfieInput extends AppFormzInput<XFile?, SelfieValidationError>
    with RequiredNullableValidator<XFile> {
  final SettingAttendanceMode mode;

  const SelfieInput.pure({this.mode = SettingAttendanceMode.foto})
    : super.pure(null);

  const SelfieInput.dirty(super.value, {required this.mode}) : super.dirty();

  @override
  SelfieValidationError? validator(XFile? value) {
    if (mode == SettingAttendanceMode.tanpa_foto) return null;
    if (isNull(value)) return SelfieValidationError.empty;
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case SelfieValidationError.empty:
        return 'Foto Selfie wajib diambil';
      default:
        return null;
    }
  }
}
