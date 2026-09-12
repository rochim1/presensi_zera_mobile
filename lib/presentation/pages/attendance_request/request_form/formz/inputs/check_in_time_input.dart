import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum CheckInTimeValidationError { empty }

class CheckInTimeInput
    extends AppFormzInput<DateTime?, CheckInTimeValidationError>
    with RequiredNullableValidator {
  final AttendanceRequestType? attendanceRequestType;

  const CheckInTimeInput.pure({this.attendanceRequestType}) : super.pure(null);

  const CheckInTimeInput.dirty(super.value, {this.attendanceRequestType})
    : super.dirty();

  @override
  CheckInTimeValidationError? validator(DateTime? value) {
    if (isRequired && isNull(value)) {
      return CheckInTimeValidationError.empty;
    }
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case CheckInTimeValidationError.empty:
        return 'Jam Check In wajib diisi';
      default:
        return null;
    }
  }

  bool get isRequired => [
    AttendanceRequestType.lupa_presensi_masuk,
    AttendanceRequestType.lupa_presensi_pulang,
  ].contains(attendanceRequestType);
}
