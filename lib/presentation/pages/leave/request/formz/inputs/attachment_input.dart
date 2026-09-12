import 'package:file_picker/file_picker.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum AttachmentValidationError { max, invalidExtension, empty }

class AttachmentInput
    extends AppFormzInput<List<PlatformFile>, AttachmentValidationError>
    with MaxLengthListValidator<PlatformFile>, FileExtensionValidator {
  final bool isRequired;

  const AttachmentInput.pure({this.isRequired = false}) : super.pure(const []);

  const AttachmentInput.dirty(super.value, {this.isRequired = false})
    : super.dirty();

  static const int maxFile = 1;
  static const allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf'];

  @override
  AttachmentValidationError? validator(List<PlatformFile> value) {
    if (isRequired && value.isEmpty) {
      return AttachmentValidationError.empty;
    }

    if (value.isEmpty) return null;

    if (!hasMaxLength(value, maxFile)) {
      return AttachmentValidationError.max;
    }

    for (final file in value) {
      if (!hasValidExtension(file.extension, allowedExtensions)) {
        return AttachmentValidationError.invalidExtension;
      }
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case AttachmentValidationError.empty:
        return 'Bukti pendukung wajib diunggah';
      case AttachmentValidationError.max:
        return 'Maksimal $maxFile file';
      case AttachmentValidationError.invalidExtension:
        return 'Format file harus: ${allowedExtensions.join(', ')}';
      default:
        return null;
    }
  }
}
