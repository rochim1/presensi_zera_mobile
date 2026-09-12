import 'package:presensi_domain/presensi_domain.dart';

class Approver {
  final String id;
  final User user;
  final int level;
  final String levelName;
  final String? catatan;
  final ApprovalStatus status;
  final DateTime? actedAt;

  const Approver({
    required this.id,
    required this.user,
    required this.level,
    required this.levelName,
    this.catatan,
    required this.status,
    this.actedAt,
  });
}
