import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'payroll_state.freezed.dart';

@freezed
abstract class PayrollState with _$PayrollState {
  const factory PayrollState({
    DateTime? filterDate,
    PayrollSlipStatus? filterStatus,
    @Default(BasePaginatedState.initial())
    BasePaginatedState<PayrollSlip> payrollSlips,
    @Default(false) bool isApprover,
  }) = _PayrollState;
}
