import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'my_shift_swap_state.freezed.dart';

@freezed
abstract class MyShiftSwapState with _$MyShiftSwapState {
  const factory MyShiftSwapState({
    DateTime? filterDate,
    @Default(BasePaginatedState.initial())
    BasePaginatedState<ShiftSwapRequest> swapRequests,
  }) = _MyShiftSwapState;
}
