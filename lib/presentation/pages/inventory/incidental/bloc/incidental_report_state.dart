import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

import 'package:presensi_mobile/core/_core.dart';

part 'incidental_report_state.freezed.dart';

@freezed
abstract class IncidentalReportState with _$IncidentalReportState {
  const factory IncidentalReportState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<IncidentalReport> reports,
    String? search,
  }) = _IncidentalReportState;
}
