import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'my_attendance_state.dart';

class MyAttendanceCubit extends Cubit<MyAttendanceState> {
  final Logger logger;
  final GetMyAttendances getMyAttendancesUseCase;

  MyAttendanceCubit({
    required this.logger,
    required this.getMyAttendancesUseCase,
  }) : super(const MyAttendanceState());

  static const int _limit = 10;

  GetAttendancesParams _params({int page = 0}) {
    return GetAttendancesParams(
      startDate: state.startDate,
      endDate: state.endDate,
      typePresensi: state.typePresensi,
      searchName: state.searchName,
      page: page,
      limit: _limit,
    );
  }

  Future<void> getMyAttendances() async {
    if (state.attendances.isLoading) return;

    emit(state.copyWith(attendances: const BasePaginatedState.loading()));

    final result = await getMyAttendancesUseCase.call(_params());

    result.fold(
      (failure) {
        emit(state.copyWith(attendances: BasePaginatedState.failure(failure)));
      },
      (value) {
        emit(
          state.copyWith(
            attendances: BasePaginatedState.success(
              data: value,
              page: 0,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchNextPage() async {
    final current = state.attendances;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        attendances: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final result = await getMyAttendancesUseCase.call(_params(page: nextPage));

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            attendances: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<Attendance>.from(current.data)..addAll(value);
        emit(
          state.copyWith(
            attendances: BasePaginatedState.success(
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
    DateTime? startDate,
    DateTime? endDate,
    String? typePresensi,
    String? searchName,
  }) {
    emit(
      state.copyWith(
        startDate: startDate,
        endDate: endDate,
        typePresensi: typePresensi,
        searchName: searchName,
      ),
    );
    getMyAttendances();
  }

  void init() {
    getMyAttendances();
  }

  Future<void> onRefresh() async {
    await getMyAttendances();
  }
}
