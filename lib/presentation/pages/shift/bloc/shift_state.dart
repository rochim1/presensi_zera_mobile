import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_state.freezed.dart';

@freezed
abstract class ShiftState with _$ShiftState {
  const factory ShiftState({
    DateTime? filterDate,
    DateTime? startDate,
    DateTime? endDate,
    @Default(0) int refreshCounter,
  }) = _ShiftState;
}
