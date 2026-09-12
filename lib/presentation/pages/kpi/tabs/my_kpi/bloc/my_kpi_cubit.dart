import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'my_kpi_state.dart';

class MyKpiCubit extends Cubit<MyKpiState> {
  final Logger logger;
  final GetMyKpiAssignments getMyAssignments;
  final AcknowledgeKpiUseCase acknowledgeKpi;

  MyKpiCubit({
    required this.logger,
    required this.getMyAssignments,
    required this.acknowledgeKpi,
  }) : super(const MyKpiState());

  Future<void> init() async {
    await fetchAssignments();
  }

  static const int _limit = 15;
  int _fetchGeneration = 0;

  Future<void> fetchAssignments() async {
    final generation = ++_fetchGeneration;
    emit(state.copyWith(assignmentState: const BasePaginatedState.loading()));

    final params = KpiFilterParams(
      page: 0,
      limit: _limit,
      status: state.filterStatus,
    );
    final result = await getMyAssignments(params);
    if (generation != _fetchGeneration || isClosed) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(assignmentState: BasePaginatedState.failure(failure)),
        );
      },
      (data) {
        emit(
          state.copyWith(
            assignmentState: BasePaginatedState.success(
              data: data,
              page: 0,
              hasReachedMax: data.length < _limit,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchNextPage() async {
    final current = state.assignmentState;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading)
      return;
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        assignmentState: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final params = KpiFilterParams(
      page: nextPage,
      limit: _limit,
      status: state.filterStatus,
    );
    final result = await getMyAssignments(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            assignmentState: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (data) {
        final newList = List<KpiAssignment>.from(current.data)..addAll(data);
        emit(
          state.copyWith(
            assignmentState: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: data.length < _limit,
            ),
          ),
        );
      },
    );
  }

  Future<void> doAcknowledge(String id) async {
    if (id.isEmpty || state.actionState.isLoading) return;
    emit(state.copyWith(actionState: const BaseState.loading()));
    final result = await acknowledgeKpi(id);

    result.fold(
      (failure) {
        emit(state.copyWith(actionState: BaseState.failure(failure)));
      },
      (success) {
        emit(state.copyWith(actionState: const BaseState.success(null)));
        fetchAssignments();
      },
    );
  }

  Future<void> setFilterStatus(String? status) async {
    if (state.filterStatus == status) return;
    emit(state.copyWith(filterStatus: status));
    await fetchAssignments();
  }
}
