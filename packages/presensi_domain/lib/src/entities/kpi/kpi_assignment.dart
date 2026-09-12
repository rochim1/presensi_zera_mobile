import 'package:equatable/equatable.dart';
import 'kpi_assignment_user.dart';
import 'kpi_assignment_template.dart';
import 'kpi_score.dart';

class KpiAssignment extends Equatable {
  final String? id;
  final KpiAssignmentUser? user;
  final KpiAssignmentTemplate? template;
  final String? periodeLabel;
  final String? tanggalMulai;
  final String? tanggalSelesai;
  final String? status;
  final double? finalScore;
  final String? finalGrade;
  final String? catatanKaryawanGlobal;
  final String? catatanReviewerGlobal;
  final String? selfSubmittedAt;
  final String? managerReviewedAt;
  final String? acknowledgedAt;
  final List<KpiScore>? scores;
  final String? createdAt;
  final String? updatedAt;

  const KpiAssignment({
    this.id,
    this.user,
    this.template,
    this.periodeLabel,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.status,
    this.finalScore,
    this.finalGrade,
    this.catatanKaryawanGlobal,
    this.catatanReviewerGlobal,
    this.selfSubmittedAt,
    this.managerReviewedAt,
    this.acknowledgedAt,
    this.scores,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        user,
        template,
        periodeLabel,
        tanggalMulai,
        tanggalSelesai,
        status,
        finalScore,
        finalGrade,
        catatanKaryawanGlobal,
        catatanReviewerGlobal,
        selfSubmittedAt,
        managerReviewedAt,
        acknowledgedAt,
        scores,
        createdAt,
        updatedAt,
      ];
}
