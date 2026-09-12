import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'break_out_request.freezed.dart';

part 'break_out_request.g.dart';

@freezed
abstract class BreakOutRequest with _$BreakOutRequest {
  const factory BreakOutRequest({
    @JsonKey(name: 'status_kerja') required StatusKerja statusKerja,
    @JsonKey(name: 'is_join_again') required bool isJoinAgain,
    @JsonKey(name: 'jam_mulai') required DateTime jamMulai,
  }) = _BreakOutRequest;

  factory BreakOutRequest.fromJson(Map<String, dynamic> json) =>
      _$BreakOutRequestFromJson(json);
}
