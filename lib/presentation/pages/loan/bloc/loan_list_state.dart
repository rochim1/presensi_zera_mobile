import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'loan_list_state.freezed.dart';

@freezed
abstract class LoanListState with _$LoanListState {
  const factory LoanListState({
    @Default(BasePaginatedState.initial())
    BasePaginatedState<EmployeeLoan> loans,
    String? approvalStatus,
    String? loanType,
    String? search,
  }) = _LoanListState;
}
