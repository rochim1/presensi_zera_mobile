import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_statistic_response.freezed.dart';
part 'attendance_statistic_response.g.dart';

@freezed
abstract class AttendanceStatisticResponse with _$AttendanceStatisticResponse {
  const factory AttendanceStatisticResponse({
    @JsonKey(name: 'type_presensi') String? typePresensi,
    @JsonKey(name: 'total_hari_kerja') @Default(0) int totalHariKerja,
    @JsonKey(name: 'total_hadir') @Default(0) int totalHadir,
    @JsonKey(name: 'total_terlambat') @Default(0) int totalTerlambat,
    @JsonKey(name: 'total_tidak_hadir') @Default(0) int totalTidakHadir,
    @JsonKey(name: 'total_cuti_izin') @Default(0) int totalCutiIzin,
    @JsonKey(name: 'total_libur') @Default(0) int totalLibur,
    @JsonKey(name: 'konsistensi') @Default(0.0) double konsistensi,
  }) = _AttendanceStatisticResponse;

  factory AttendanceStatisticResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceStatisticResponseFromJson(json);
}
