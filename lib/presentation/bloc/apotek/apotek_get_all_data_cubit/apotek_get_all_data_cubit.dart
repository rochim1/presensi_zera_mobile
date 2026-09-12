import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'apotek_get_all_data_state.dart';

class ApotekGetAllDataCubit extends Cubit<ApotekGetAllDataState> {
  final ApotekGetAllData apotekGetAllData;

  ApotekGetAllDataCubit(this.apotekGetAllData)
    : super(const ApotekGetAllDataState());

  Future<void> getAllData() async {
    if (state.hasMax!) return;

    if (state.status.isInitial) emit(state.copyWith(status: TypeState.loading));

    if (state.status.isLoading) return initLoadAllData();

    final params = ApotekFilterEntity(
      pagination: GlobalPaginationEntity(
        page: (state.filter?.pagination?.page ?? 0) + 1,
      ),
    );

    final Either<Failure, List<ApotekEntity>> data = await apotekGetAllData
        .call(params);

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          filter: params,
        ),
      ),
      (value) => emit(
        state.copyWith(
          status: TypeState.loaded,
          apoteks: [...state.apoteks ?? [], ...value],
          filter: params,
          hasMax: value.isEmpty,
        ),
      ),
    );
  }

  Future<void> initLoadAllData({String? query, String? status}) async {
    final params = ApotekFilterEntity(namaApotek: query, status: status);

    final Either<Failure, List<ApotekEntity>> data = await apotekGetAllData
        .call(params);

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          filter: params,
          apoteks: [],
        ),
      ),
      (value) {
        emit(
          state.copyWith(
            status: TypeState.loaded,
            apoteks: value,
            filter: params,
            hasMax: value.length < LIMIT,
          ),
        );
      },
    );
  }

  Future<void> filterByStatus(String? status) async {
    final currentQuery = state.filter?.namaApotek;
    emit(state.copyWith(status: TypeState.loading));
    await initLoadAllData(query: currentQuery, status: status);
  }

  Future<void> onSearchData(String? query) async {
    if (state.hasMax!) return;

    final params = ApotekFilterEntity(
      namaApotek: query,
      pagination: GlobalPaginationEntity(
        page: (state.filter?.pagination?.page ?? 0) + 1,
      ),
    );

    final Either<Failure, List<ApotekEntity>> data = await apotekGetAllData
        .call(params);

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          filter: params,
        ),
      ),
      (value) => emit(
        state.copyWith(
          status: TypeState.loaded,
          apoteks: [...state.apoteks ?? [], ...value],
          filter: params,
          hasMax: value.isEmpty,
        ),
      ),
    );
  }
}
