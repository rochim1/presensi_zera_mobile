import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'attendance_request_response.g.dart';

part 'attendance_request_response.freezed.dart';

@freezed
abstract class AttendanceRequestResponse with _$AttendanceRequestResponse {
  const factory AttendanceRequestResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(
      name: 'jenis_request',
      defaultValue: AttendanceRequestType.lupa_presensi_masuk,
      unknownEnumValue: AttendanceRequestType.lupa_presensi_masuk,
    )
    required AttendanceRequestType type,
    @JsonKey(name: 'user') UserResponse? user,

    @JsonKey(name: 'tanggal_presensi')
    @DateConverter()
    DateTime? tanggalPresensi,

    @JsonKey(name: 'waktu_yang_diminta', defaultValue: '')
    required String waktuYangDiminta,
    @JsonKey(name: 'catatan_reviewer', defaultValue: '') required String alasan,
    @JsonKey(name: 'bukti_pendukung', defaultValue: [])
    required List<String> buktiPendukung,
    @JsonKey(name: 'alasan') String? catatanReviewer,
    @JsonKey(
      name: 'status',
      defaultValue: AttendanceRequestStatus.pending,
      unknownEnumValue: AttendanceRequestStatus.pending,
    )
    required AttendanceRequestStatus status,
    @JsonKey(name: 'approval_history') ApprovalHistoryResponse? approvalHistory,

    @JsonKey(name: 'createdAt', defaultValue: null)
    @NullableStringTimestampConverter()
    DateTime? createdAt,

    @JsonKey(name: 'updatedAt', defaultValue: null)
    @NullableStringTimestampConverter()
    DateTime? updatedAt,
  }) = _AttendanceRequestResponse;

  factory AttendanceRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRequestResponseFromJson(json);
}
