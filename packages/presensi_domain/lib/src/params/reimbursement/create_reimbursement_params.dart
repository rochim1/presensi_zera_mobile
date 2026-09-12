import 'package:http/http.dart';

class CreateReimbursementParams {
  final String kategori;
  final String judul;
  final String? deskripsi;
  final DateTime? tanggal;
  final double? nominal;
  final String? mataUang;
  final String? catatanPengaju;
  final List<MultipartFile?> attachments;

  const CreateReimbursementParams({
    required this.kategori,
    required this.judul,
    this.deskripsi,
    this.tanggal,
    this.nominal,
    this.mataUang,
    this.catatanPengaju,
    this.attachments = const [],
  });
}
