import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'reimbursement_response.freezed.dart';
part 'reimbursement_response.g.dart';

@freezed
abstract class ReimbursementResponse with _$ReimbursementResponse {
  const factory ReimbursementResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'user_id') UserResponse? user,
    @JsonKey(name: 'kategori') String? kategori,
    @JsonKey(name: 'judul') String? judul,
    @JsonKey(name: 'deskripsi') String? deskripsi,
    @JsonKey(name: 'tanggal') @DateConverter() DateTime? tanggal,
    @JsonKey(name: 'nominal') double? nominal,
    @JsonKey(name: 'mata_uang', unknownEnumValue: CurrencySymbol.IDR)
    CurrencySymbol? mataUang,
    @JsonKey(name: 'bukti_pembayaran') String? buktiPembayaran,
    @JsonKey(name: 'filename') String? filename,
    @JsonKey(name: 'catatan_pengaju') String? catatanPengaju,
    @JsonKey(name: 'status_reimbursement') String? statusReimbursement,
    @JsonKey(name: 'tanggal_pengajuan') DateTime? tanggalPengajuan,
    @JsonKey(name: 'tanggal_aksi') DateTime? tanggalAksi,
    @JsonKey(name: 'aktor_aksi') UserResponse? aktorAksi,
    @JsonKey(name: 'catatan_finance') String? catatanFinance,
    @JsonKey(name: 'is_response_by_admin') bool? isResponseByAdmin,
    @JsonKey(name: 'approval_history') ApprovalHistoryResponse? approvalHistory,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'createdAt')
    @NullableStringTimestampConverter()
    DateTime? createdAt,
    @JsonKey(name: 'updatedAt')
    @NullableStringTimestampConverter()
    DateTime? updatedAt,
  }) = _ReimbursementResponse;

  factory ReimbursementResponse.fromJson(Map<String, dynamic> json) =>
      _$ReimbursementResponseFromJson(json);
}
