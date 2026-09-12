import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum CheckOutTimeValidationError { empty }

class CheckOutTimeInput
    extends AppFormzInput<DateTime?, CheckOutTimeValidationError>
    with RequiredNullableValidator {
  final AttendanceRequestType? attendanceRequestType;

  const CheckOutTimeInput.pure({this.attendanceRequestType}) : super.pure(null);

  const CheckOutTimeInput.dirty(super.value, {this.attendanceRequestType})
    : super.dirty();

  @override
  CheckOutTimeValidationError? validator(DateTime? value) {
    if (isRequired && isNull(value)) {
      return CheckOutTimeValidationError.empty;
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case CheckOutTimeValidationError.empty:
        return 'Jam Check Out wajib diisi';
      default:
        return null;
    }
  }

  bool get isRequired => [
    AttendanceRequestType.lupa_presensi_pulang,
  ].contains(attendanceRequestType);
}
