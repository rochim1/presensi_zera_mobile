import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'my_shift_swap_state.dart';

class MyShiftSwapCubit extends Cubit<MyShiftSwapState> {
  final Logger logger;
  final GetMyShiftSwapRequests getMyShiftSwapRequestUseCase;
  final ShiftRepository repository;

  MyShiftSwapCubit({
    required this.logger,
    required this.getMyShiftSwapRequestUseCase,
    required this.repository,
  }) : super(const MyShiftSwapState());

  static const int _limit = 10;

  GetMyShiftSwapRequestsParams _params({int page = 1}) {
    return GetMyShiftSwapRequestsParams(
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
      page: page,
      limit: _limit,
    );
  }

  Future<void> getMyShiftSwapSchedules() async {
    if (state.swapRequests.isLoading) return;

    emit(state.copyWith(swapRequests: const BasePaginatedState.loading()));

    final result = await getMyShiftSwapRequestUseCase.call(_params());

    result.fold(
      (failure) {
        emit(state.copyWith(swapRequests: BasePaginatedState.failure(failure)));
      },
      (value) {
        emit(
          state.copyWith(
            swapRequests: BasePaginatedState.success(
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
    final current = state.swapRequests;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        swapRequests: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final result = await getMyShiftSwapRequestUseCase.call(
      _params(page: nextPage),
    );

    result.fold(
      (failure) {
        // Revert to success without advancing the page
        emit(
          state.copyWith(
            swapRequests: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<ShiftSwapRequest>.from(current.data)
          ..addAll(value);
        emit(
          state.copyWith(
            swapRequests: BasePaginatedState.success(
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
    getMyShiftSwapSchedules();
  }

  void init() {
    emit(state.copyWith(filterDate: DateTime.now()));
    getMyShiftSwapSchedules();
  }

  Future<void> onRefresh() async {
    await getMyShiftSwapSchedules();
  }

  Future<String?> cancelRequest(String id) async {
    final result = await repository.cancelShiftSwapRequest(id);
    return result.fold((failure) => failure.message, (_) async {
      await onRefresh();
      return null;
    });
  }
}
