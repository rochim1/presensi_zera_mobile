import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'leave_request_response.freezed.dart';

part 'leave_request_response.g.dart';

@freezed
abstract class LeaveRequestResponse with _$LeaveRequestResponse {
  const factory LeaveRequestResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'user_id') required UserResponse user,
    @JsonKey(name: 'tipe_cuti') LeaveCategoryResponse? category,
    @JsonKey(
      name: 'status_izin',
      defaultValue: LeaveStatus.diajukan,
      unknownEnumValue: LeaveStatus.diajukan,
    )
    required LeaveStatus status,
    @JsonKey(name: 'alasan') required String alasan,
    @JsonKey(name: 'tanggal_izin') @DateConverter() DateTime? tanggalIzin,
    @JsonKey(name: 'tanggal_masuk') @DateConverter() DateTime? tanggalMasuk,
    @JsonKey(name: 'tanggal_pengajuan')
    @DateConverter()
    DateTime? tanggalPengajuan,
    @JsonKey(name: 'is_half_day', defaultValue: false) bool? isHalfDay,
    @JsonKey(name: 'half_day_type') String? halfDayType,
    @JsonKey(name: 'file_izin') String? fileIzin,
    @JsonKey(name: 'approval_history') ApprovalHistoryResponse? approvalHistory,
  }) = _LeaveRequestResponse;

  factory LeaveRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestResponseFromJson(json);
}
