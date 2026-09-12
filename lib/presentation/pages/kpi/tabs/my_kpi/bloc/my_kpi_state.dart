import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'my_kpi_state.freezed.dart';

@freezed
abstract class MyKpiState with _$MyKpiState {
  const factory MyKpiState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<KpiAssignment> assignmentState,
    @Default(BaseState.initial()) BaseState<void> actionState,
    @Default(null) String? filterStatus,
  }) = _MyKpiState;
}
