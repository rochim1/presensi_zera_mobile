import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'my_request_state.dart';

class MyAttendanceRequestCubit extends Cubit<MyAttendanceRequestState> {
  final GetAttendanceRequests getAttendanceRequestsUseCase;
  final Logger logger;
  final AttendanceRequestRepository repository;

  MyAttendanceRequestCubit({
    required this.getAttendanceRequestsUseCase,
    required this.logger,
    required this.repository,
  }) : super(MyAttendanceRequestState());

  static const int _limit = 10;

  void getAttendanceRequests() async {
    if (state.attendanceRequests.isLoading) return;

    emit(
      state.copyWith(attendanceRequests: const BasePaginatedState.loading()),
    );

    final params = GetAttendanceRequestsParams(
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
      status: state.filterStatus,
      page: 1,
      limit: _limit,
    );
    final result = await getAttendanceRequestsUseCase.call(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            attendanceRequests: BasePaginatedState.failure(failure),
          ),
        );
      },
      (value) {
        emit(
          state.copyWith(
            attendanceRequests: BasePaginatedState.success(
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
    final current = state.attendanceRequests;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        attendanceRequests: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final params = GetAttendanceRequestsParams(
      startDate: state.filterDate?.startOfMonth,
      endDate: state.filterDate?.endOfMonth,
      status: state.filterStatus,
      page: nextPage,
      limit: _limit,
    );
    final result = await getAttendanceRequestsUseCase.call(params);

    result.fold(
      (failure) {
        // Revert to success without advancing the page
        emit(
          state.copyWith(
            attendanceRequests: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<AttendanceRequest>.from(current.data)
          ..addAll(value);
        emit(
          state.copyWith(
            attendanceRequests: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void onChangeFilterStatus(AttendanceRequestStatus? value) {
    emit(state.copyWith(filterStatus: value));
    getAttendanceRequests();
  }

  void onChangeFilterDate(DateTime? date) {
    emit(state.copyWith(filterDate: date));
    getAttendanceRequests();
  }

  void init() {
    onChangeFilterDate(DateTime.now());
  }

  void onRefresh() {
    getAttendanceRequests();
  }

  Future<String?> deleteRequest(String id) async {
    final result = await repository.deleteAttendanceRequest(id);
    return result.fold((failure) => failure.message, (_) {
      onRefresh();
      return null;
    });
  }
}
