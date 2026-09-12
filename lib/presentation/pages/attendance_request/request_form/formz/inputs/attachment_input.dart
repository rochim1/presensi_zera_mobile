import 'package:file_picker/file_picker.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum AttachmentsValidationError { max, invalidExtension }

class AttachmentsInput
    extends AppFormzInput<List<PlatformFile>, AttachmentsValidationError>
    with MaxLengthListValidator<PlatformFile>, FileExtensionValidator {
  const AttachmentsInput.pure() : super.pure(const []);

  const AttachmentsInput.dirty(super.value) : super.dirty();

  static const int maxFile = 5;
  static const allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf'];

  @override
  AttachmentsValidationError? validator(List<PlatformFile> value) {
    if (value.isEmpty) return null;

    if (!hasMaxLength(value, maxFile)) {
      return AttachmentsValidationError.max;
    }

    for (final file in value) {
      if (!hasValidExtension(file.extension, allowedExtensions)) {
        return AttachmentsValidationError.invalidExtension;
      }
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case AttachmentsValidationError.max:
        return 'Maksimal $maxFile file';
      case AttachmentsValidationError.invalidExtension:
        return 'Format file harus: ${allowedExtensions.join(', ')}';
      default:
        return null;
    }
  }
}
