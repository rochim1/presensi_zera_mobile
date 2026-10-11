import 'package:bloc/bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';

import 'loan_form_state.dart';

class LoanFormCubit extends Cubit<LoanFormState> {
  bool _isSubmittingAction = false;

  final CreateEmployeeLoan createEmployeeLoanUseCase;

  LoanFormCubit({required this.createEmployeeLoanUseCase})
    : super(const LoanFormState());

  Future<void> submitLoan({
    required String employeeId,
    required String loanType,
    required double principalAmount,
    required int loanTermMonths,
    required String purpose,
  }) async {
    if (_isSubmittingAction || isClosed || state.isSuccess) {
      return;
    }
    _isSubmittingAction = true;
    try {
      emit(
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false),
      );

      final params = CreateEmployeeLoanParams(
        employeeId: employeeId,
        loanType: loanType,
        principalAmount: principalAmount,
        loanTermMonths: loanTermMonths,
        purpose: purpose,
      );

      final result = await createEmployeeLoanUseCase.call(params);

      if (isClosed) return;
      result.fold(
        (failure) => emit(
          state.copyWith(isLoading: false, errorMessage: failure.message),
        ),
        (loan) => emit(state.copyWith(isLoading: false, isSuccess: true)),
      );
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Pengajuan gagal diproses, silakan coba lagi',
          ),
        );
      }
    } finally {
      _isSubmittingAction = false;
    }
  }
}
