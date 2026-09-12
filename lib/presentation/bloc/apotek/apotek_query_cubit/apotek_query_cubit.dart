import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'apotek_query_state.dart';

class ApotekQueryCubit extends Cubit<ApotekQueryState> {
  final ApotekGetQuery getQuery;
  final ApotekPostQuery postQuery;

  ApotekQueryCubit({required this.getQuery, required this.postQuery})
    : super(const ApotekQueryState(queries: []));

  Future<void> getAllData() async {
    final Either<Failure, List<GlobalQueryEntity>> data = await getQuery.call(
      NoParams(),
    );

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          queries: [],
        ),
      ),
      (value) {
        value.sort((a, b) => b.createAt.compareTo(a.createAt));
        emit(state.copyWith(status: TypeState.loaded, queries: value));
      },
    );
  }

  Future<void> postData(String query) async {
    if (query.isEmpty) return;

    final cpQuery = GlobalQueryEntity(
      query: query,
      createAt: DateTime.now().millisecondsSinceEpoch,
      boxKey: KEY_QUERY_APOTEK,
    );

    final Either<Failure, String?> data = await postQuery.call(cpQuery);

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          queries: state.queries,
        ),
      ),
      (value) {
        emit(
          state.copyWith(
            status: TypeState.loaded,
            queries: state.queries,
            message: value,
          ),
        );
      },
    );
  }
}
