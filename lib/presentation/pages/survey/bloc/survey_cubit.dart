import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'survey_state.dart';

class SurveyCubit extends Cubit<SurveyState> {
  final GetMySurveys getMySurveysUseCase;
  final Logger logger;

  SurveyCubit({required this.getMySurveysUseCase, required this.logger})
    : super(const SurveyState());

  static const int _limit = 10;

  GetMySurveysParams _getMySurveysParams({int page = 0}) =>
      GetMySurveysParams(page: page, limit: _limit);

  Future<void> getMySurveys() async {
    if (state.surveys.isLoading) return;

    emit(state.copyWith(surveys: const BasePaginatedState.loading()));

    final result = await getMySurveysUseCase.call(_getMySurveysParams());

    result.fold(
      (failure) {
        emit(state.copyWith(surveys: BasePaginatedState.failure(failure)));
      },
      (value) {
        emit(
          state.copyWith(
            surveys: BasePaginatedState.success(
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
    final current = state.surveys;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        surveys: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final result = await getMySurveysUseCase.call(
      _getMySurveysParams(page: nextPage),
    );

    result.fold(
      (_) {
        emit(
          state.copyWith(
            surveys: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<Survey>.from(current.data)..addAll(value);
        emit(
          state.copyWith(
            surveys: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void init() {
    getMySurveys();
  }

  Future<void> onRefresh() async {
    await getMySurveys();
  }
}
