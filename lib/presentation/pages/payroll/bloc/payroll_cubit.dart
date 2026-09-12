import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'payroll_state.dart';

class PayrollCubit extends Cubit<PayrollState> {
  final GetPayrollSlips getPayrollSlipsUseCase;
  final TestWorkflowUserUseCase testWorkflowUserUseCase;
  final GetAuthSession getAuthSessionUseCase;
  final Logger logger;

  PayrollCubit({
    required this.getPayrollSlipsUseCase,
    required this.testWorkflowUserUseCase,
    required this.getAuthSessionUseCase,
    required this.logger,
  }) : super(const PayrollState());

  static const int _limit = 10;

  GetPayrollSlipsParams _getPayrollSlipsParams({int page = 1}) =>
      GetPayrollSlipsParams(
        month: state.filterDate?.month,
        year: state.filterDate?.year,
        status: state.filterStatus,
        page: page,
        limit: _limit,
      );

  Future<void> getPayrollSlips() async {
    if (state.payrollSlips.isLoading) return;

    emit(state.copyWith(payrollSlips: const BasePaginatedState.loading()));

    final result = await getPayrollSlipsUseCase.call(_getPayrollSlipsParams());

    result.fold(
      (failure) {
        emit(state.copyWith(payrollSlips: BasePaginatedState.failure(failure)));
      },
      (value) {
        emit(
          state.copyWith(
            payrollSlips: BasePaginatedState.success(
              data: value,
              page: 1,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void fetchNextPage() async {
    final current = state.payrollSlips;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        payrollSlips: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final result = await getPayrollSlipsUseCase.call(
      _getPayrollSlipsParams(page: nextPage),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            payrollSlips: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<PayrollSlip>.from(current.data)..addAll(value);
        emit(
          state.copyWith(
            payrollSlips: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void onChangeFilterStatus(PayrollSlipStatus? value) {
    emit(state.copyWith(filterStatus: value));
    getPayrollSlips();
  }

  void onChangeFilterDate(DateTime? value) {
    emit(state.copyWith(filterDate: value));
    getPayrollSlips();
  }

  Future<void> onRefresh() async {
    await getPayrollSlips();
  }

  void init() {
    emit(state.copyWith(filterDate: null, filterStatus: null));
    getPayrollSlips();
    _checkIfApprover();
  }

  Future<void> _checkIfApprover() async {
    try {
      final sessionResult = await getAuthSessionUseCase.call(NoParams());
      sessionResult.fold((l) => null, (session) async {
        if (session.userId == null) return;
        final result = await testWorkflowUserUseCase.call(
          TestWorkflowUserParams(
            module: 'payroll_batch',
            testUserId: session.userId,
          ),
        );

        result.fold((l) => null, (res) {
          final isApprover =
              res.levels?.any((l) => l.userIsApprover == true) ?? false;
          if (isApprover) {
            emit(state.copyWith(isApprover: true));
          }
        });
      });
    } catch (e) {
      logger.e("Error checking approver status", error: e);
    }
  }
}
