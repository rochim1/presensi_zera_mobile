import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'incidental_report_state.dart';

class IncidentalReportCubit extends Cubit<IncidentalReportState> {
  final GetIncidentalReportsUseCase getIncidentalReportsUseCase;

  IncidentalReportCubit(this.getIncidentalReportsUseCase) : super(const IncidentalReportState());

  static const int _limit = 15;

  GetIncidentalReportsParams _params({int page = 0}) {
    return GetIncidentalReportsParams(
      search: state.search,
      page: page,
      limit: _limit,
    );
  }

  Future<void> loadData({String? search}) async {
    if (state.reports.isLoading) return;

    if (search != null) {
      emit(state.copyWith(search: search));
    }

    emit(state.copyWith(reports: const BasePaginatedState.loading()));

    final result = await getIncidentalReportsUseCase(_params(page: 0));

    result.fold(
      (failure) => emit(state.copyWith(reports: BasePaginatedState.failure(failure))),
      (data) => emit(
        state.copyWith(
          reports: BasePaginatedState.success(
            data: data,
            page: 0,
            hasReachedMax: data.length < _limit,
          ),
        ),
      ),
    );
  }

  Future<void> fetchNextPage() async {
    final current = state.reports;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) return;
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(state.copyWith(
      reports: BasePaginatedState.loadingNext(
        data: current.data,
        page: nextPage,
        hasReachedMax: current.hasReachedMax,
      ),
    ));

    final result = await getIncidentalReportsUseCase(_params(page: nextPage));

    result.fold(
      (failure) {
        emit(state.copyWith(
          reports: BasePaginatedState.success(
            data: current.data,
            page: current.currentPage,
            hasReachedMax: current.hasReachedMax,
          ),
        ));
      },
      (value) {
        final newList = List<IncidentalReport>.from(current.data)..addAll(value);
        emit(state.copyWith(
          reports: BasePaginatedState.success(
            data: newList,
            page: nextPage,
            hasReachedMax: value.length < _limit,
          ),
        ));
      },
    );
  }
}
