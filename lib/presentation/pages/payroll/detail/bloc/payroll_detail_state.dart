import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'payroll_detail_state.freezed.dart';

@freezed
abstract class PayrollDetailState with _$PayrollDetailState {
  const factory PayrollDetailState({
    @Default(BaseState.initial()) BaseState<PayrollSlip> payrollSlip,
    @Default(BaseState.initial()) BaseState<String> downloadSlipPdf,
  }) = _PayrollDetailState;
}
