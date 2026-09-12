import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'overtime_request_response.g.dart';

part 'overtime_request_response.freezed.dart';

@freezed
abstract class OvertimeRequestResponse with _$OvertimeRequestResponse {
  const factory OvertimeRequestResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'tanggal') @DateConverter() DateTime? date,
    @JsonKey(name: 'jam_mulai') @TimeConverter() DateTime? startTime,
    @JsonKey(name: 'user') required UserResponse user,
    @JsonKey(name: 'jam_selesai') @TimeConverter() DateTime? endTime,
    @JsonKey(name: 'durasi_jam', defaultValue: 0) required int durationInHours,
    @JsonKey(name: 'alasan') String? reason,
    @JsonKey(
      name: 'status',
      defaultValue: OvertimeRequestStatus.pending,
      unknownEnumValue: OvertimeRequestStatus.pending,
    )
    required OvertimeRequestStatus status,
    @JsonKey(name: 'approval_history') ApprovalHistoryResponse? approvalHistory,
    @JsonKey(name: 'createdAt')
    @NullableStringTimestampConverter()
    DateTime? createdAt,
  }) = _OvertimeRequestResponse;

  factory OvertimeRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$OvertimeRequestResponseFromJson(json);
}
