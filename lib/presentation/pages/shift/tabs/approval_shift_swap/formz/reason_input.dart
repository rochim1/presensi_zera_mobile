import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum ReasonValidationError { max, empty }

class ReasonInput extends AppFormzInput<String?, ReasonValidationError>
    with MaxLengthValidator, RequiredNullableValidator {
  final RequestStatus? action;

  const ReasonInput.pure({this.action}) : super.pure('');

  const ReasonInput.dirty(super.value, {required this.action}) : super.dirty();

  static const int maxLength = 2480;

  @override
  ReasonValidationError? validator(String? value) {
    final trimValue = value?.trim() ?? '';

    if (action == RequestStatus.rejected) {
      if (isNull(value) || trimValue.isEmpty) {
        return ReasonValidationError.empty;
      }
    }

    if (!hasMaxLength(trimValue, maxLength)) {
      return ReasonValidationError.max;
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case ReasonValidationError.max:
        return 'Alasan tidak boleh lebih dari $maxLength karakter';
      case ReasonValidationError.empty:
        return 'Alasan Penolakan wajib diisi';
      default:
        return null;
    }
  }
}
