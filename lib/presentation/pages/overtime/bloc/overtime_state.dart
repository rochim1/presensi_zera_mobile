import 'package:freezed_annotation/freezed_annotation.dart';

part 'overtime_state.freezed.dart';

@freezed
abstract class OvertimeState with _$OvertimeState {
  const factory OvertimeState({
    DateTime? filterDate,
    DateTime? startDate,
    DateTime? endDate,
    String? filterStatus,
    @Default(0) int refreshCounter,
  }) = _OvertimeState;
}
