import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'my_leave_state.dart';

class MyLeaveCubit extends Cubit<MyLeaveState> {
  final GetLeaveRequests getLeaveRequestsUseCase;
  final Logger logger;
  final LeaveRepository repository;

  MyLeaveCubit({
    required this.getLeaveRequestsUseCase,
    required this.logger,
    required this.repository,
  }) : super(MyLeaveState());

  static const int _limit = 10;

  Future<void> getLeaveRequests() async {
    emit(state.copyWith(leaveRequests: const BasePaginatedState.loading()));

    final params = GetLeaveRequestsParams(
      startDate: state.filterDate,
      statusIzin: state.filterLeaveStatus?.name,
      detailCuti: true,
      page: 0,
      limit: _limit,
    );
    final result = await getLeaveRequestsUseCase.call(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(leaveRequests: BasePaginatedState.failure(failure)),
        );
      },
      (value) {
        emit(
          state.copyWith(
            leaveRequests: BasePaginatedState.success(
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
    final current = state.leaveRequests;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        leaveRequests: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final params = GetLeaveRequestsParams(
      startDate: state.filterDate,
      statusIzin: state.filterLeaveStatus?.name,
      detailCuti: true,
      page: nextPage,
      limit: _limit,
    );
    final result = await getLeaveRequestsUseCase.call(params);

    result.fold(
      (failure) {
        // Revert to success without advancing the page
        emit(
          state.copyWith(
            leaveRequests: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<LeaveRequest>.from(current.data)..addAll(value);
        emit(
          state.copyWith(
            leaveRequests: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void onChangeFilterLeaveStatus(LeaveStatus? value) {
    emit(state.copyWith(filterLeaveStatus: value));
    getLeaveRequests();
  }

  void onChangeFilterDate(DateTime? date) {
    emit(state.copyWith(filterDate: date));
    getLeaveRequests();
  }

  void onParentFilterChanged({
    DateTime? filterDate,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    emit(state.copyWith(filterDate: filterDate));
    getLeaveRequests();
  }

  void init() {
    onChangeFilterDate(DateTime.now());
  }

  Future<void> onRefresh() async {
    await getLeaveRequests();
  }

  Future<String?> deleteRequest(String id) async {
    final result = await repository.deleteLeaveRequest(id);
    return result.fold((failure) => failure.message, (_) async {
      await onRefresh();
      return null;
    });
  }
}
