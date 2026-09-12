import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'check_out_request.freezed.dart';

part 'check_out_request.g.dart';

@freezed
abstract class CheckOutRequest with _$CheckOutRequest {
  const factory CheckOutRequest({
    @JsonKey(name: 'status_kerja') required StatusKerja statusKerja,
    @JsonKey(name: 'keterangan') String? keterangan,
    @JsonKey(name: 'jam_mulai') required DateTime jamMulai,
    @JsonKey(name: 'location') required LocationModel location,
    @JsonKey(name: 'emotional_report')
    required Map<String, dynamic> emotionalReport,
  }) = _CheckOutRequest;

  factory CheckOutRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckOutRequestFromJson(json);
}
