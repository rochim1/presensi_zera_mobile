import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'setting_response.g.dart';

part 'setting_response.freezed.dart';

@freezed
abstract class SettingResponse with _$SettingResponse {
  const factory SettingResponse({
    @JsonKey(name: '_id') required String id,

    @JsonKey(name: 'jam_masuk') @TimeConverter() DateTime? jamMasuk,
    @JsonKey(name: 'jam_pulang') @TimeConverter() DateTime? jamPulang,
    @JsonKey(
      name: 'mode_presensi',
      defaultValue: SettingAttendanceMode.tanpa_foto,
      unknownEnumValue: SettingAttendanceMode.tanpa_foto,
    )
    required SettingAttendanceMode attendanceMode,
    @JsonKey(name: 'mode_order_sales', defaultValue: 'full')
    @Default('full')
    String modeOrderSales,
    @JsonKey(name: 'allow_mobile_change_visit_vehicle', defaultValue: false)
    @Default(false)
    bool allowMobileChangeVisitVehicle,
    @JsonKey(name: 'allow_overtime_cross_day', defaultValue: false)
    @Default(false)
    bool allowOvertimeCrossDay,
    @JsonKey(name: 'overtime_auto_close_next_day', defaultValue: true)
    @Default(true)
    bool overtimeAutoCloseNextDay,
    @JsonKey(name: 'overtime_auto_close_time', defaultValue: '23:59')
    @Default('23:59')
    String overtimeAutoCloseTime,
    @JsonKey(name: 'max_overtime_active_hours', defaultValue: 8)
    @Default(8)
    int maxOvertimeActiveHours,
    @JsonKey(name: 'is_mandatory_foto_pendukung_presensi', defaultValue: false)
    @Default(false)
    bool isMandatorySupportingEvidence,
    @JsonKey(name: 'allow_presensi_on_call', defaultValue: false)
    @Default(false)
    bool allowPresensiOnCall,
    @JsonKey(name: 'on_call_require_location_policy', defaultValue: true)
    @Default(true)
    bool onCallRequireLocationPolicy,
    @JsonKey(name: 'on_call_require_location', defaultValue: true)
    @Default(true)
    bool onCallRequireLocation,
    @JsonKey(name: 'allow_on_call_after_checkout', defaultValue: true)
    @Default(true)
    bool allowOnCallAfterCheckout,
    @JsonKey(name: 'allow_on_call_cross_day', defaultValue: true)
    @Default(true)
    bool allowOnCallCrossDay,
    @JsonKey(name: 'on_call_auto_close_next_day', defaultValue: false)
    @Default(false)
    bool onCallAutoCloseNextDay,
    @JsonKey(name: 'on_call_auto_close_time', defaultValue: '23:59')
    @Default('23:59')
    String onCallAutoCloseTime,
    @JsonKey(name: 'max_on_call_active_hours', defaultValue: 24)
    @Default(24)
    int maxOnCallActiveHours,
    @JsonKey(name: 'attendance_types', defaultValue: ['reguler'])
    @Default(['reguler'])
    List<String> attendanceTypes,
    @JsonKey(name: 'logbook_required_for_checkout', defaultValue: false)
    @Default(false)
    bool logbookRequiredForCheckout,
    @JsonKey(name: 'logbook_require_start_end_time', defaultValue: true)
    @Default(true)
    bool logbookRequireStartEndTime,
    @JsonKey(name: 'logbook_require_description', defaultValue: false)
    @Default(false)
    bool logbookRequireDescription,
    @JsonKey(name: 'logbook_require_category', defaultValue: false)
    @Default(false)
    bool logbookRequireCategory,
    @JsonKey(name: 'logbook_use_default_time_when_empty', defaultValue: false)
    @Default(false)
    bool logbookUseDefaultTimeWhenEmpty,
    @JsonKey(name: 'logbook_default_start_time', defaultValue: '09:00')
    @Default('09:00')
    String logbookDefaultStartTime,
    @JsonKey(name: 'logbook_default_end_time', defaultValue: '17:00')
    @Default('17:00')
    String logbookDefaultEndTime,
    @JsonKey(name: 'logbook_default_duration_minutes', defaultValue: 30)
    @Default(30)
    int logbookDefaultDurationMinutes,
  }) = _SettingResponse;

  factory SettingResponse.fromJson(Map<String, dynamic> json) =>
      _$SettingResponseFromJson(json);
}
