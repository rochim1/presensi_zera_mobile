import 'package:equatable/equatable.dart';

class SubmitManagerReviewParams extends Equatable {
  final String assignmentId;
  final List<ManagerScoreInputParams> scores;
  final String? catatanReviewerGlobal;

  const SubmitManagerReviewParams({
    required this.assignmentId,
    required this.scores,
    this.catatanReviewerGlobal,
  });

  @override
  List<Object?> get props => [assignmentId, scores, catatanReviewerGlobal];
}

class ManagerScoreInputParams extends Equatable {
  final String indicatorId;
  final double managerRating;
  final String? catatanReviewer;

  const ManagerScoreInputParams({
    required this.indicatorId,
    required this.managerRating,
    this.catatanReviewer,
  });

  @override
  List<Object?> get props => [indicatorId, managerRating, catatanReviewer];
}
