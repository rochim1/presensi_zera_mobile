import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'team_kpi_state.freezed.dart';

@freezed
abstract class TeamKpiState with _$TeamKpiState {
  const factory TeamKpiState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<KpiAssignment> assignmentState,
    @Default(BaseState.initial()) BaseState<KpiTeamSummary> summaryState,
  }) = _TeamKpiState;
}
