import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/formz/_formz.dart';

enum ShiftScheduleValidationError { empty }

class ShiftScheduleInput
    extends AppFormzInput<ShiftSchedule?, ShiftScheduleValidationError>
    with RequiredNullableValidator {
  final AttendanceType? attendanceType;
  final DateTime? attendanceDate;

  const ShiftScheduleInput.pure({this.attendanceType, this.attendanceDate})
    : super.pure(null);

  const ShiftScheduleInput.dirty(
    super.value, {
    this.attendanceType,
    this.attendanceDate,
  }) : super.dirty();

  @override
  ShiftScheduleValidationError? validator(ShiftSchedule? value) {
    if (isRequired && isNull(value)) {
      return ShiftScheduleValidationError.empty;
    }

    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case ShiftScheduleValidationError.empty:
        return 'Jadwal Shift wajib dipilih';
      default:
        return null;
    }
  }

  bool get isRequired =>
      attendanceType == AttendanceType.shift && attendanceDate != null;
}
