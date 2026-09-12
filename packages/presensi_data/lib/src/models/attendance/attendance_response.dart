import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'attendance_response.freezed.dart';

part 'attendance_response.g.dart';

@freezed
abstract class AttendanceResponse with _$AttendanceResponse {
  const factory AttendanceResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'keterangan') String? keterangan,
    @JsonKey(
      name: 'type_presensi',
      defaultValue: AttendanceType.daily,
      unknownEnumValue: AttendanceType.daily,
    )
    required AttendanceType type,
    @JsonKey(
      name: 'status_kerja',
      defaultValue: StatusKerja.galat,
      unknownEnumValue: StatusKerja.galat,
    )
    required StatusKerja status,
    @JsonKey(name: 'jam_masuk') @TimeConverter() DateTime? jamMasuk,
    @JsonKey(name: 'jam_pulang') @TimeConverter() DateTime? jamPulang,
    @JsonKey(name: 'tanggal_presensi') @DateConverter() DateTime? date,
    @JsonKey(name: 'location_check_in') LocationResponse? locationCheckIn,
    @JsonKey(name: 'location_check_out') LocationResponse? locationCheckOut,
    @JsonKey(name: 'user_id') UserResponse? user,
    @JsonKey(name: 'total_kerja', defaultValue: null)
    @DurationSecondsConverter()
    required Duration? totalKerja,
    @JsonKey(name: 'total_istirahat', defaultValue: null)
    @DurationSecondsConverter()
    required Duration? totalIstirahat,
    @JsonKey(name: 'aktivitas', defaultValue: [])
    required List<AttendanceActivityResponse> activities,
    @JsonKey(name: 'foto_presensi') AttendancePhotoResponse? fotoPresensi,
    @JsonKey(name: 'foto_pendukung') AttendancePhotoResponse? fotoPendukung,
    @JsonKey(name: 'jarak_checkIn_toStandar') String? jarakCheckInToStandar,
    @JsonKey(name: 'jarak_checkOut_toStandar') String? jarakCheckOutToStandar,
    @JsonKey(name: 'current_setting')
    AttendanceCurrentSettingResponse? currentSetting,
  }) = _AttendanceResponse;

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceResponseFromJson(json);
}

@freezed
abstract class AttendancePhotoResponse with _$AttendancePhotoResponse {
  const factory AttendancePhotoResponse({
    @JsonKey(name: 'filePath_In') String? checkIn,
    @JsonKey(name: 'filePath_Out') String? checkOut,
  }) = _AttendancePhotoResponse;

  factory AttendancePhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendancePhotoResponseFromJson(json);
}

@freezed
abstract class AttendanceActivityResponse with _$AttendanceActivityResponse {
  const factory AttendanceActivityResponse({
    @JsonKey(name: 'aktivitas', defaultValue: '') required String name,
    @JsonKey(name: 'jam_mulai') @TimeConverter() DateTime? jamMulai,
    @JsonKey(name: 'is_late', defaultValue: false) required bool isLate,
    @JsonKey(name: 'keterangan') String? keterangan,
    @JsonKey(name: 'format_local')
    AttendanceActivityFormatLocalResponse? formatLocal,
  }) = _AttendanceActivityResponse;

  factory AttendanceActivityResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceActivityResponseFromJson(json);
}

@freezed
abstract class AttendanceActivityFormatLocalResponse
    with _$AttendanceActivityFormatLocalResponse {
  const factory AttendanceActivityFormatLocalResponse({String? full}) =
      _AttendanceActivityFormatLocalResponse;

  factory AttendanceActivityFormatLocalResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$AttendanceActivityFormatLocalResponseFromJson(json);
}

@freezed
abstract class AttendanceCurrentSettingResponse
    with _$AttendanceCurrentSettingResponse {
  const factory AttendanceCurrentSettingResponse({
    @JsonKey(name: 'jam_masuk') String? jamMasuk,
    @JsonKey(name: 'jam_pulang') String? jamPulang,
  }) = _AttendanceCurrentSettingResponse;

  factory AttendanceCurrentSettingResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$AttendanceCurrentSettingResponseFromJson(json);
}
