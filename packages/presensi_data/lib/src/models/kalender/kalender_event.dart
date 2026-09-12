import 'package:equatable/equatable.dart';

class KalenderEvent extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final bool allDay;
  final String? eventType;
  final String? color;
  final bool isRecurring;
  final String? recurringType;
  final String? status;
  final bool attendanceEnabled;
  final String? attendanceOpenAt;
  final String? attendanceCloseAt;
  final String? attendanceLocationName;
  final double? attendanceLatitude;
  final double? attendanceLongitude;
  final int? attendanceRadiusMeters;

  const KalenderEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.allDay = true,
    this.eventType,
    this.color,
    this.isRecurring = false,
    this.recurringType,
    this.status,
    this.attendanceEnabled = false,
    this.attendanceOpenAt,
    this.attendanceCloseAt,
    this.attendanceLocationName,
    this.attendanceLatitude,
    this.attendanceLongitude,
    this.attendanceRadiusMeters,
  });

  factory KalenderEvent.fromJson(Map<String, dynamic> json) {
    return KalenderEvent(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      allDay: json['all_day'] ?? true,
      eventType: json['event_type'],
      color: json['color'],
      isRecurring: json['is_recurring'] ?? false,
      recurringType: json['recurring_type'],
      status: json['status'],
      attendanceEnabled: json['attendance_enabled'] ?? false,
      attendanceOpenAt: json['attendance_open_at'],
      attendanceCloseAt: json['attendance_close_at'],
      attendanceLocationName: json['attendance_location_name'],
      attendanceLatitude: (json['attendance_latitude'] as num?)?.toDouble(),
      attendanceLongitude: (json['attendance_longitude'] as num?)?.toDouble(),
      attendanceRadiusMeters: (json['attendance_radius_meters'] as num?)
          ?.toInt(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    startDate,
    endDate,
    eventType,
    color,
    attendanceEnabled,
    attendanceOpenAt,
    attendanceCloseAt,
    attendanceLocationName,
    attendanceLatitude,
    attendanceLongitude,
    attendanceRadiusMeters,
  ];
}

class EventAttendance extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? employeeNumber;
  final String? checkInAt;

  const EventAttendance({
    required this.id,
    required this.userId,
    required this.userName,
    this.employeeNumber,
    this.checkInAt,
  });

  factory EventAttendance.fromJson(Map<String, dynamic> json) {
    final user = json['user_id'] is Map<String, dynamic>
        ? json['user_id'] as Map<String, dynamic>
        : <String, dynamic>{};
    return EventAttendance(
      id: json['_id']?.toString() ?? '',
      userId: user['_id']?.toString() ?? json['user_id']?.toString() ?? '',
      userName: user['name']?.toString() ?? user['username']?.toString() ?? '-',
      employeeNumber: (user['nip'] ?? user['no_identitas'])?.toString(),
      checkInAt: json['check_in_at']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, userId, userName, employeeNumber, checkInAt];
}
