import 'package:presensi_domain/presensi_domain.dart';

class ShiftSchedule {
  final String id;
  final Shift shift;
  final DateTime? assignedDate;
  final ShiftScheduleStatus status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  const ShiftSchedule({
    required this.id,
    required this.shift,
    this.assignedDate,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.user,
  });
}
