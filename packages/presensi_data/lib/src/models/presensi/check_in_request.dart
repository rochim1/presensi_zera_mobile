import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'check_in_request.freezed.dart';

part 'check_in_request.g.dart';

@freezed
abstract class CheckInRequest with _$CheckInRequest {
  const factory CheckInRequest({
    @JsonKey(name: 'status_kerja') required StatusKerja statusKerja,
    @JsonKey(name: 'keterangan') String? keterangan,
    @JsonKey(name: 'jam_mulai') required DateTime jamMulai,
    @JsonKey(name: 'location') required LocationModel location,
    @JsonKey(name: 'type_presensi') required AttendanceType type,
  }) = _CheckInRequest;

  factory CheckInRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckInRequestFromJson(json);
}
