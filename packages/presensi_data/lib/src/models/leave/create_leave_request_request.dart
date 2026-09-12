import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/core/_core.dart';

part 'create_leave_request_request.freezed.dart';
part 'create_leave_request_request.g.dart';

@freezed
abstract class CreateLeaveRequestRequest with _$CreateLeaveRequestRequest {
  const factory CreateLeaveRequestRequest({
    @JsonKey(name: 'tipe_cuti') required String tipeCuti,
    @JsonKey(name: 'alasan') required String alasan,
    @JsonKey(name: 'tanggal_izin')
    @DateConverter()
    required DateTime tanggalIzin,
    @JsonKey(name: 'tanggal_masuk')
    @DateConverter()
    required DateTime tanggalMasuk,
    @JsonKey(name: 'status_izin', includeIfNull: false) String? statusIzin,
    @JsonKey(name: 'is_half_day', includeIfNull: false)
    @Default(false)
    bool isHalfDay,
    @JsonKey(name: 'half_day_type', includeIfNull: false) String? halfDayType,
    @JsonKey(name: 'delegasi_kepada', includeIfNull: false)
    String? delegasiKepada,
  }) = _CreateLeaveRequestRequest;

  factory CreateLeaveRequestRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateLeaveRequestRequestFromJson(json);
}
