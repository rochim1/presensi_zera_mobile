import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_state.freezed.dart';

@freezed
abstract class LeaveState with _$LeaveState {
  const factory LeaveState({
    DateTime? filterDate,
    DateTime? startDate,
    DateTime? endDate,
    @Default(0) int refreshCounter,
    @Default(false) bool? isApprover,
  }) = _LeaveState;
}
