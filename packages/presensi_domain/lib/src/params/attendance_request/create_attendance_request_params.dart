import 'package:http/http.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CreateAttendanceRequestParams {
  final AttendanceType? attendanceType;
  final AttendanceRequestType? attendanceRequestType;
  final String? shiftId;
  final DateTime? attendanceDate;
  final String? attendanceTime;
  final String? reason;
  final List<MultipartFile?> attachments;

  const CreateAttendanceRequestParams({
    this.attendanceType,
    this.attendanceRequestType,
    this.shiftId,
    this.attendanceDate,
    this.attendanceTime,
    this.reason,
    this.attachments = const [],
  });
}
