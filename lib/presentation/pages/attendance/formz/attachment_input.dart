import 'package:file_picker/file_picker.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum AttachmentValidationError { max, invalidExtension }

class AttachmentInput
    extends AppFormzInput<List<PlatformFile>, AttachmentValidationError>
    with MaxLengthListValidator<PlatformFile>, FileExtensionValidator {
  const AttachmentInput.pure() : super.pure(const []);

  const AttachmentInput.dirty(super.value) : super.dirty();

  static const int maxFile = 5;
  static const allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf'];

  @override
  AttachmentValidationError? validator(List<PlatformFile> value) {
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
      case AttachmentValidationError.max:
        return 'Maksimal $maxFile file';
      case AttachmentValidationError.invalidExtension:
        return 'Format file harus: ${allowedExtensions.join(', ')}';
      default:
        return null;
    }
  }
}
