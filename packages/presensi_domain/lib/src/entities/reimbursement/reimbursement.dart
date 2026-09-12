import 'package:presensi_domain/presensi_domain.dart';

class Reimbursement {
  final String id;
  final User? user;
  final String? kategori;
  final String? judul;
  final String? deskripsi;
  final DateTime? tanggal;
  final double? nominal;
  final CurrencySymbol? mataUang;
  final String? buktiPembayaran;
  final String? filename;
  final String? catatanPengaju;
  final String? statusReimbursement;
  final DateTime? tanggalPengajuan;
  final DateTime? tanggalAksi;
  final User? aktorAksi;
  final String? catatanFinance;
  final bool? isResponseByAdmin;
  final ApprovalHistory? approvalHistory;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Reimbursement({
    required this.id,
    this.user,
    this.kategori,
    this.judul,
    this.deskripsi,
    this.tanggal,
    this.nominal,
    this.mataUang,
    this.buktiPembayaran,
    this.filename,
    this.catatanPengaju,
    this.statusReimbursement,
    this.tanggalPengajuan,
    this.tanggalAksi,
    this.aktorAksi,
    this.catatanFinance,
    this.isResponseByAdmin,
    this.approvalHistory,
    this.status,
    this.createdAt,
    this.updatedAt,
  });
}
