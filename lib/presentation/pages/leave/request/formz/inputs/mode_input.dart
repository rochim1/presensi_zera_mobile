import 'package:presensi_mobile/core/formz/_formz.dart';

enum LeaveMode { fullDay, halfDayPagi, halfDaySiang }

enum LeaveModeValidationError { empty }

class LeaveModeInput extends AppFormzInput<LeaveMode?, LeaveModeValidationError>
    with RequiredNullableValidator {
  final bool isRequired;

  const LeaveModeInput.pure({this.isRequired = true}) : super.pure(null);

  const LeaveModeInput.dirty(super.value, {this.isRequired = true})
    : super.dirty();

  @override
  LeaveModeValidationError? validator(LeaveMode? value) {
    if (!isRequired) return null;
    if (isNull(value)) return LeaveModeValidationError.empty;
    return null;
  }

  @override
  String? get errorMessage {
    if (isPure) return null;
    switch (error) {
      case LeaveModeValidationError.empty:
        return 'Mode Cuti wajib dipilih';
      default:
        return null;
    }
  }
}

extension LeaveModeExtension on LeaveMode {
  String get label {
    switch (this) {
      case LeaveMode.fullDay:
        return 'Full Day';
      case LeaveMode.halfDayPagi:
        return 'Half Day Pagi (07:00 - 12:00)';
      case LeaveMode.halfDaySiang:
        return 'Half Day Siang (13:00 - 17:00)';
    }
  }

  bool get isHalfDay => this != LeaveMode.fullDay;

  String? toHalfDayType() {
    switch (this) {
      case LeaveMode.halfDayPagi:
        return 'pagi';
      case LeaveMode.halfDaySiang:
        return 'siang';
      case LeaveMode.fullDay:
        return null;
    }
  }
}
