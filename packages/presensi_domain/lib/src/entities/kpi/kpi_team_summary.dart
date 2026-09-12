import 'package:equatable/equatable.dart';

class KpiGradeDistribution extends Equatable {
  final String? grade;
  final String? label;
  final int? count;
  final String? warna;

  const KpiGradeDistribution({
    this.grade,
    this.label,
    this.count,
    this.warna,
  });

  @override
  List<Object?> get props => [grade, label, count, warna];
}

class KpiTeamSummary extends Equatable {
  final int? totalKaryawan;
  final int? completed;
  final int? inProgress;
  final int? notStarted;
  final double? avgScore;
  final List<KpiGradeDistribution>? gradeDistribution;

  const KpiTeamSummary({
    this.totalKaryawan,
    this.completed,
    this.inProgress,
    this.notStarted,
    this.avgScore,
    this.gradeDistribution,
  });

  @override
  List<Object?> get props => [
        totalKaryawan,
        completed,
        inProgress,
        notStarted,
        avgScore,
        gradeDistribution,
      ];
}
