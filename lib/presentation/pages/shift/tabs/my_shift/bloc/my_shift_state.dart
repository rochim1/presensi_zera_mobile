import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'my_shift_state.freezed.dart';

@freezed
abstract class MyShiftState with _$MyShiftState {
  const factory MyShiftState({
    DateTime? filterDate,
    @Default(BasePaginatedState.initial())
    BasePaginatedState<ShiftSchedule> shiftSchedules,
  }) = _MyShiftState;
}
