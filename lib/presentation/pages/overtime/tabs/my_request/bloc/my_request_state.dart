import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'my_request_state.freezed.dart';

@freezed
abstract class MyOvertimeRequestState with _$MyOvertimeRequestState {
  const factory MyOvertimeRequestState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<OvertimeRequest> overtimeRequests,
    @Default(null) OvertimeRequestStatus? filterStatus,
    @Default(null) DateTime? filterDate,
  }) = _MyOvertimeRequestState;
}
