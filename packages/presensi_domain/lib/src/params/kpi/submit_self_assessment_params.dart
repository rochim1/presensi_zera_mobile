import 'package:equatable/equatable.dart';

class SubmitSelfAssessmentParams extends Equatable {
  final String assignmentId;
  final List<SelfScoreInputParams> scores;
  final String? catatanKaryawanGlobal;

  const SubmitSelfAssessmentParams({
    required this.assignmentId,
    required this.scores,
    this.catatanKaryawanGlobal,
  });

  @override
  List<Object?> get props => [assignmentId, scores, catatanKaryawanGlobal];
}

class SelfScoreInputParams extends Equatable {
  final String indicatorId;
  final double selfRating;
  final String? catatanKaryawan;

  const SelfScoreInputParams({
    required this.indicatorId,
    required this.selfRating,
    this.catatanKaryawan,
  });

  @override
  List<Object?> get props => [indicatorId, selfRating, catatanKaryawan];
}
