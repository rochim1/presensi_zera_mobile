import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'loan_list_state.dart';

class LoanListCubit extends Cubit<LoanListState> {
  final Logger logger;
  final GetEmployeeLoans getEmployeeLoansUseCase;

  LoanListCubit({required this.logger, required this.getEmployeeLoansUseCase})
    : super(const LoanListState());

  static const int _limit = 10;

  GetEmployeeLoansParams _params({int page = 1}) {
    return GetEmployeeLoansParams(
      page: page,
      limit: _limit,
      approvalStatus: state.approvalStatus,
      loanType: state.loanType,
      search: state.search,
    );
  }

  Future<void> getEmployeeLoans() async {
    if (state.loans.isLoading) return;

    emit(state.copyWith(loans: const BasePaginatedState.loading()));

    final result = await getEmployeeLoansUseCase.call(_params());

    result.fold(
      (failure) {
        emit(state.copyWith(loans: BasePaginatedState.failure(failure)));
      },
      (value) {
        emit(
          state.copyWith(
            loans: BasePaginatedState.success(
              data: value,
              page: 1,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchNextPage() async {
    final current = state.loans;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        loans: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final result = await getEmployeeLoansUseCase.call(_params(page: nextPage));

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            loans: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<EmployeeLoan>.from(current.data)..addAll(value);
        emit(
          state.copyWith(
            loans: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void applyFilters({
    String? approvalStatus,
    String? loanType,
    String? search,
  }) {
    emit(
      state.copyWith(
        approvalStatus: approvalStatus,
        loanType: loanType,
        search: search,
      ),
    );
    getEmployeeLoans();
  }

  void init() {
    getEmployeeLoans();
  }

  Future<void> onRefresh() async {
    await getEmployeeLoans();
  }
}
