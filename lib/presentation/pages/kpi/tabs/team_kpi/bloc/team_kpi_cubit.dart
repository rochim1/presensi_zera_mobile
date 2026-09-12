import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'team_kpi_state.dart';

class TeamKpiCubit extends Cubit<TeamKpiState> {
  final Logger logger;
  final GetTeamKpiAssignments getTeamAssignments;
  final GetTeamKpiSummary getTeamSummary;

  TeamKpiCubit({
    required this.logger,
    required this.getTeamAssignments,
    required this.getTeamSummary,
  }) : super(const TeamKpiState());

  Future<void> init() async {
    await Future.wait([fetchSummary(), fetchAssignments()]);
  }

  Future<void> fetchSummary() async {
    emit(state.copyWith(summaryState: const BaseState.loading()));
    final params = KpiFilterParams();
    final result = await getTeamSummary(params);

    result.fold(
      (failure) {
        emit(state.copyWith(summaryState: BaseState.failure(failure)));
      },
      (data) {
        emit(state.copyWith(summaryState: BaseState.success(data)));
      },
    );
  }

  static const int _limit = 15;

  Future<void> fetchAssignments() async {
    if (state.assignmentState.isLoading) return;
    emit(state.copyWith(assignmentState: const BasePaginatedState.loading()));

    final params = KpiFilterParams(page: 0, limit: _limit);
    final result = await getTeamAssignments(params);

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

    final params = KpiFilterParams(page: nextPage, limit: _limit);
    final result = await getTeamAssignments(params);

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
}
