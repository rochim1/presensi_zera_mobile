import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/core/_core.dart';

part 'create_reimbursement_request.freezed.dart';
part 'create_reimbursement_request.g.dart';

@freezed
abstract class CreateReimbursementRequest with _$CreateReimbursementRequest {
  const factory CreateReimbursementRequest({
    required String kategori,
    required String judul,
    String? deskripsi,
    @DateConverter() DateTime? tanggal,
    double? nominal,
    @JsonKey(name: 'mata_uang') String? mataUang,
    @JsonKey(name: 'catatan_pengaju') String? catatanPengaju,
  }) = _CreateReimbursementRequest;

  factory CreateReimbursementRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReimbursementRequestFromJson(json);
}
