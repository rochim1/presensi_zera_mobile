import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';

part 'get_attendances_request.freezed.dart';
part 'get_attendances_request.g.dart';

@freezed
abstract class GetAttendancesRequest with _$GetAttendancesRequest {
  const factory GetAttendancesRequest({
    @JsonKey(name: 'user_id', includeIfNull: false) String? userId,
    @JsonKey(name: 'tanggal_presensi') String? tanggalPresensi,
    @JsonKey(name: 'nama') String? nama,
    @JsonKey(name: 'status_kerja') String? statusKerja,
    @JsonKey(name: 'rentang', includeIfNull: false) int? rentang,
    @DateConverter() @JsonKey(name: 'pilih_tanggal') DateTime? pilihTanggal,
    @JsonKey(name: 'tipe_laporan') String? tipeLaporan,
    @DateConverter()
    @JsonKey(name: 'start_date', includeIfNull: false)
    DateTime? startDate,
    @DateConverter()
    @JsonKey(name: 'end_date', includeIfNull: false)
    DateTime? endDate,
    @JsonKey(name: 'type_presensi') String? typePresensi,
  }) = _GetAttendancesRequest;

  factory GetAttendancesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetAttendancesRequestFromJson(json);
}
