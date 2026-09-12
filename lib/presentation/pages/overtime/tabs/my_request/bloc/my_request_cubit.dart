import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'my_request_state.dart';

class MyOvertimeRequestCubit extends Cubit<MyOvertimeRequestState> {
  final GetOvertimeRequests getOvertimeRequestsUseCase;
  final DeleteOvertimeRequest deleteOvertimeRequestUseCase;
  final Logger logger;

  MyOvertimeRequestCubit({
    required this.getOvertimeRequestsUseCase,
    required this.deleteOvertimeRequestUseCase,
    required this.logger,
  }) : super(MyOvertimeRequestState());

  static const int _limit = 10;

  GetOvertimeRequestsParams _getOvertimeRequestsParams({int page = 0}) =>
      GetOvertimeRequestsParams(
        startDate: state.filterDate?.startOfMonth,
        endDate: state.filterDate?.endOfMonth,
        status: state.filterStatus,
        page: page,
        limit: _limit,
      );

  Future<void> getAttendanceRequests() async {
    if (state.overtimeRequests.isLoading) return;

    emit(state.copyWith(overtimeRequests: const BasePaginatedState.loading()));

    final params = _getOvertimeRequestsParams();
    final result = await getOvertimeRequestsUseCase.call(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(overtimeRequests: BasePaginatedState.failure(failure)),
        );
      },
      (value) {
        emit(
          state.copyWith(
            overtimeRequests: BasePaginatedState.success(
              data: value,
              page: 0,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void fetchNextPage() async {
    final current = state.overtimeRequests;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        overtimeRequests: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final params = _getOvertimeRequestsParams(page: nextPage);
    final result = await getOvertimeRequestsUseCase.call(params);

    result.fold(
      (failure) {
        // Revert to success without advancing the page
        emit(
          state.copyWith(
            overtimeRequests: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<OvertimeRequest>.from(current.data)..addAll(value);
        emit(
          state.copyWith(
            overtimeRequests: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void onChangeFilterStatus(OvertimeRequestStatus? value) {
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

  Future<void> onRefresh() async {
    await getAttendanceRequests();
  }

  Future<String?> deleteRequest(String id) async {
    final result = await deleteOvertimeRequestUseCase.call(id);
    return result.fold((failure) => failure.message, (_) {
      onRefresh();
      return null;
    });
  }
}
