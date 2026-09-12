import 'package:presensi_domain/presensi_domain.dart';

class Setting {
  final String id;
  final DateTime? jamMasuk;
  final DateTime? jamPulang;
  final SettingAttendanceMode? attendanceMode;
  final String modeOrderSales;
  final bool allowMobileChangeVisitVehicle;
  final bool allowOvertimeCrossDay;
  final bool overtimeAutoCloseNextDay;
  final String overtimeAutoCloseTime;
  final int maxOvertimeActiveHours;
  final bool isMandatorySupportingEvidence;
  final bool allowPresensiOnCall;
  final bool onCallRequireLocationPolicy;
  final bool onCallRequireLocation;
  final bool allowOnCallAfterCheckout;
  final bool allowOnCallCrossDay;
  final bool onCallAutoCloseNextDay;
  final String onCallAutoCloseTime;
  final int maxOnCallActiveHours;
  final List<String> attendanceTypes;
  final bool logbookRequiredForCheckout;
  final bool logbookRequireStartEndTime;
  final bool logbookRequireDescription;
  final bool logbookRequireCategory;
  final bool logbookUseDefaultTimeWhenEmpty;
  final String logbookDefaultStartTime;
  final String logbookDefaultEndTime;
  final int logbookDefaultDurationMinutes;

  const Setting({
    this.jamMasuk,
    this.jamPulang,
    required this.id,
    this.attendanceMode,
    this.modeOrderSales = 'full',
    this.allowMobileChangeVisitVehicle = false,
    this.allowOvertimeCrossDay = false,
    this.overtimeAutoCloseNextDay = true,
    this.overtimeAutoCloseTime = '23:59',
    this.maxOvertimeActiveHours = 8,
    this.isMandatorySupportingEvidence = false,
    this.allowPresensiOnCall = false,
    this.onCallRequireLocationPolicy = true,
    this.onCallRequireLocation = true,
    this.allowOnCallAfterCheckout = true,
    this.allowOnCallCrossDay = true,
    this.onCallAutoCloseNextDay = false,
    this.onCallAutoCloseTime = '23:59',
    this.maxOnCallActiveHours = 24,
    this.attendanceTypes = const ['reguler'],
    this.logbookRequiredForCheckout = false,
    this.logbookRequireStartEndTime = true,
    this.logbookRequireDescription = false,
    this.logbookRequireCategory = false,
    this.logbookUseDefaultTimeWhenEmpty = false,
    this.logbookDefaultStartTime = '09:00',
    this.logbookDefaultEndTime = '17:00',
    this.logbookDefaultDurationMinutes = 30,
  });

  bool get isHybridMode => modeOrderSales == 'hybrid';

  List<String> get normalizedAttendanceTypes =>
      attendanceTypes.map(_normalizeAttendanceType).toList();

  bool get allowDailyAttendance =>
      normalizedAttendanceTypes.contains('reguler');
  bool get allowShiftAttendance => normalizedAttendanceTypes.contains('shift');
  bool get allowOnCallAttendance =>
      allowPresensiOnCall && normalizedAttendanceTypes.contains('oncall');

  String _normalizeAttendanceType(String type) {
    switch (type.trim().toLowerCase()) {
      case 'daily':
      case 'regular':
      case 'reguler':
        return 'reguler';
      case 'on_call':
      case 'on-call':
      case 'on call':
      case 'oncall':
        return 'oncall';
      default:
        return type.trim().toLowerCase();
    }
  }
}
