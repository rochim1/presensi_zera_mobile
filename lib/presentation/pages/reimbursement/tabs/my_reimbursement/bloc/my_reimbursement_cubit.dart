import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'my_reimbursement_state.dart';

class MyReimbursementCubit extends Cubit<MyReimbursementState> {
  final Logger logger;
  final GetMyReimbursements getMyReimbursementsUseCase;
  final ReimbursementRepository repository;

  MyReimbursementCubit({
    required this.logger,
    required this.getMyReimbursementsUseCase,
    required this.repository,
  }) : super(const MyReimbursementState());

  static const int _limit = 10;

  GetReimbursementsParams _params({int page = 0}) {
    return GetReimbursementsParams(
      page: page,
      limit: _limit,
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
    );
  }

  Future<void> getReimbursements() async {
    if (state.reimbursements.isLoading) return;

    emit(state.copyWith(reimbursements: const BasePaginatedState.loading()));

    final result = await getMyReimbursementsUseCase.call(_params());

    result.fold(
      (failure) {
        emit(
          state.copyWith(reimbursements: BasePaginatedState.failure(failure)),
        );
      },
      (value) {
        emit(
          state.copyWith(
            reimbursements: BasePaginatedState.success(
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
    final current = state.reimbursements;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        reimbursements: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final result = await getMyReimbursementsUseCase.call(
      _params(page: nextPage),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            reimbursements: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<Reimbursement>.from(current.data)..addAll(value);
        emit(
          state.copyWith(
            reimbursements: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void onChangeFilterDate(DateTime? value) {
    emit(state.copyWith(filterDate: value));
    getReimbursements();
  }

  void init() {
    emit(state.copyWith(filterDate: DateTime.now()));
    getReimbursements();
  }

  Future<void> onRefresh() async {
    await getReimbursements();
  }

  Future<String?> deleteRequest(String id) async {
    final result = await repository.deleteReimbursement(id);
    return result.fold((failure) => failure.message, (_) async {
      await onRefresh();
      return null;
    });
  }
}
