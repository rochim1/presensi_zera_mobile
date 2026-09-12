import 'package:presensi_domain/presensi_domain.dart';

class AttendanceRequest {
  final String id;
  final AttendanceRequestType type;
  final DateTime? tanggalPresensi;
  final String waktuYangDiminta;
  final String alasan;
  final User? user;
  final AttendanceRequestStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ApprovalHistory? approvalHistory;
  final List<String> buktiPendukung;
  final String? catatanReviewer;

  const AttendanceRequest({
    required this.id,
    required this.type,
    required this.status,
    this.tanggalPresensi,
    required this.waktuYangDiminta,
    required this.alasan,
    this.user,
    this.createdAt,
    this.approvalHistory,
    this.updatedAt,
    this.buktiPendukung = const [],
    this.catatanReviewer,
  });
}
