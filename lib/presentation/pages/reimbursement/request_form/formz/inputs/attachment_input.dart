import 'package:file_picker/file_picker.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';
import 'package:presensi_mobile/presentation/pages/overtime/request_form/formz/inputs/attachment_input.dart';

enum ReimbursementAttachmentsValidationError { empty, max, invalidExtension }

class ReimbursementAttachmentsInput
    extends
        AppFormzInput<
          List<PlatformFile>,
          ReimbursementAttachmentsValidationError
        >
    with MaxLengthListValidator<PlatformFile>, FileExtensionValidator {
  const ReimbursementAttachmentsInput.pure()
    : isRequired = true,
      super.pure(const []);

  final bool isRequired;

  const ReimbursementAttachmentsInput.dirty(
    super.value, {
    this.isRequired = true,
  }) : super.dirty();

  static const int maxFile = 1;
  static const allowedExtensions = AttachmentsInput.allowedExtensions;

  @override
  ReimbursementAttachmentsValidationError? validator(List<PlatformFile> value) {
    if (value.isEmpty) {
      return isRequired ? ReimbursementAttachmentsValidationError.empty : null;
    }

    if (!hasMaxLength(value, maxFile)) {
      return ReimbursementAttachmentsValidationError.max;
    }

    for (final file in value) {
      if (!hasValidExtension(file.extension, allowedExtensions)) {
        return ReimbursementAttachmentsValidationError.invalidExtension;
      }
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case ReimbursementAttachmentsValidationError.empty:
        return 'Bukti Pembayaran wajib diisi';
      case ReimbursementAttachmentsValidationError.max:
        return 'Maksimal $maxFile file';
      case ReimbursementAttachmentsValidationError.invalidExtension:
        return 'Format file harus: ${allowedExtensions.join(', ')}';
      default:
        return null;
    }
  }
}
