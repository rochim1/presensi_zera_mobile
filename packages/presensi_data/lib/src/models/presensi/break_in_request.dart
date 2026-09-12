import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'break_in_request.freezed.dart';

part 'break_in_request.g.dart';

@freezed
abstract class BreakInRequest with _$BreakInRequest {
  const factory BreakInRequest({
    @JsonKey(name: 'status_kerja') required StatusKerja statusKerja,
    @JsonKey(name: 'jam_mulai') required DateTime jamMulai,
  }) = _BreakInRequest;

  factory BreakInRequest.fromJson(Map<String, dynamic> json) =>
      _$BreakInRequestFromJson(json);
}
