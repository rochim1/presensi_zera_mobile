import 'package:presensi_domain/presensi_domain.dart';

enum LeaveStatus { diterima, ditolak, diajukan }

class LeaveRequest {
  final String id;
  final LeaveCategory? category;
  final LeaveStatus status;
  final User user;
  final String alasan;
  final DateTime? tanggalIzin;
  final DateTime? tanggalMasuk;
  final DateTime? tanggalPengajuan;
  final bool? isHalfDay;
  final String? halfDayType;
  final String? fileIzin;
  final ApprovalHistory? approvalHistory;

  const LeaveRequest({
    required this.id,
    this.category,
    required this.status,
    required this.user,
    required this.alasan,
    this.tanggalIzin,
    this.tanggalMasuk,
    this.tanggalPengajuan,
    this.isHalfDay,
    this.halfDayType,
    this.fileIzin,
    this.approvalHistory,
  });
}
