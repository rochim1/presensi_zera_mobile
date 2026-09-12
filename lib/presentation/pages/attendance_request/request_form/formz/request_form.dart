import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '_formz.dart';

part 'request_form.freezed.dart';

@freezed
abstract class AttendanceRequestFormInputs
    with _$AttendanceRequestFormInputs, FormzMixin {
  const AttendanceRequestFormInputs._();

  const factory AttendanceRequestFormInputs({
    @Default(AttendanceTypeInput.pure()) AttendanceTypeInput attendanceType,
    @Default(AttendanceRequestTypeInput.pure())
    AttendanceRequestTypeInput attendanceRequestType,
    @Default(AttendanceDateInput.pure()) AttendanceDateInput attendanceDate,
    @Default(CheckInTimeInput.pure()) CheckInTimeInput checkInTime,
    @Default(CheckOutTimeInput.pure()) CheckOutTimeInput checkOutTime,
    @Default(ReasonInput.pure()) ReasonInput reason,
    @Default(AttachmentsInput.pure()) AttachmentsInput attachments,
    @Default(ShiftScheduleInput.pure()) ShiftScheduleInput shiftSchedule,
  }) = _AttendanceRequestFormInputs;

  @override
  List<FormzInput> get inputs => [attendanceType, attendanceRequestType];
}
