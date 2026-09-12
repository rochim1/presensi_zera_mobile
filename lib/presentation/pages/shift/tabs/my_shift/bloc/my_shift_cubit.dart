import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'my_shift_state.dart';

class MyShiftCubit extends Cubit<MyShiftState> {
  final Logger logger;
  final GetMyShiftSchedules getMyShiftSchedulesUseCase;

  MyShiftCubit({required this.logger, required this.getMyShiftSchedulesUseCase})
    : super(const MyShiftState());

  static const int _limit = 10;
  DateTime _currentMonth = DateTime.now();

  GetMyShiftSchedulesParams _params({int page = 1}) {
    return GetMyShiftSchedulesParams(
      date: _currentMonth,
      page: page,
      limit: _limit,
    );
  }

  Future<void> getMyShiftSchedules() async {
    if (state.shiftSchedules.isLoading) return;

    emit(state.copyWith(shiftSchedules: const BasePaginatedState.loading()));

    final result = await getMyShiftSchedulesUseCase.call(_params());

    result.fold(
      (failure) {
        emit(
          state.copyWith(shiftSchedules: BasePaginatedState.failure(failure)),
        );
      },
      (value) {
        emit(
          state.copyWith(
            shiftSchedules: BasePaginatedState.success(
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
    final current = state.shiftSchedules;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        shiftSchedules: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final result = await getMyShiftSchedulesUseCase.call(
      _params(page: nextPage),
    );

    result.fold(
      (failure) {
        // Revert to success without advancing the page
        emit(
          state.copyWith(
            shiftSchedules: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<ShiftSchedule>.from(current.data)..addAll(value);
        emit(
          state.copyWith(
            shiftSchedules: BasePaginatedState.success(
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
    final oldDate = state.filterDate;
    
    if (oldDate != null && value != null && oldDate.year == value.year && oldDate.month == value.month && oldDate.day == value.day) {
      value = null;
    }
    
    emit(state.copyWith(filterDate: value));

    if (value != null) {
      if (_currentMonth.month != value.month || _currentMonth.year != value.year) {
        _currentMonth = value;
        getMyShiftSchedules();
      }
    }
  }

  void onChangeFocusedMonth(DateTime value) {
    if (_currentMonth.month != value.month || _currentMonth.year != value.year) {
      _currentMonth = value;
      emit(state.copyWith(filterDate: null));
      getMyShiftSchedules();
    }
  }

  void init() {
    emit(state.copyWith(filterDate: null));
    getMyShiftSchedules();
  }

  Future<void> onRefresh() async {
    await getMyShiftSchedules();
  }
}
