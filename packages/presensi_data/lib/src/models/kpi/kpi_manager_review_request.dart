import 'package:freezed_annotation/freezed_annotation.dart';

part 'kpi_manager_review_request.freezed.dart';
part 'kpi_manager_review_request.g.dart';

@freezed
abstract class ManagerScoreInputRequest with _$ManagerScoreInputRequest {
  const factory ManagerScoreInputRequest({
    required String indicator_id,
    required double manager_rating,
    String? catatan_reviewer,
  }) = _ManagerScoreInputRequest;

  factory ManagerScoreInputRequest.fromJson(Map<String, dynamic> json) => _$ManagerScoreInputRequestFromJson(json);
}

@freezed
abstract class KpiManagerReviewRequest with _$KpiManagerReviewRequest {
  const factory KpiManagerReviewRequest({
    required String assignment_id,
    required List<ManagerScoreInputRequest> scores,
    String? catatan_reviewer_global,
  }) = _KpiManagerReviewRequest;

  factory KpiManagerReviewRequest.fromJson(Map<String, dynamic> json) => _$KpiManagerReviewRequestFromJson(json);
}
