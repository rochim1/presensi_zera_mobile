import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'my_reimbursement_state.freezed.dart';

@freezed
abstract class MyReimbursementState with _$MyReimbursementState {
  const factory MyReimbursementState({
    DateTime? filterDate,
    @Default(BasePaginatedState.initial())
    BasePaginatedState<Reimbursement> reimbursements,
  }) = _MyReimbursementState;
}
