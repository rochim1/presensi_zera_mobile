import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'kpi_review_state.freezed.dart';

@freezed
abstract class KpiReviewState with _$KpiReviewState {
  const factory KpiReviewState({
    @Default('') String assignmentId,
    @Default(BaseState.initial()) BaseState<KpiAssignment> detailState,
    @Default(BaseState.initial()) BaseState<void> submitState,
    @Default({}) Map<String, double> ratings,
    @Default({}) Map<String, String> comments,
    @Default('') String globalComment,
  }) = _KpiReviewState;
}
