import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'presensi_get_all_data_state.dart';

class PresensiGetAllDataCubit extends Cubit<PresensiGetAllDataState> {
  final PresensiGetAllData presensiGetAllData;

  PresensiGetAllDataCubit(this.presensiGetAllData)
    : super(
        PresensiGetAllDataState(
          filter: PresensiFilterEntity(
            tanggalPresensi: DateTime.now().toIso8601String(),
          ),
        ),
      );

  Future<void> getAllData([PresensiFilterEntity? params]) async {
    emit(state.copyWith(status: TypeState.loading, hasReachedMax: false));

    final Either<Failure, List<PresensiEntity>> data = await presensiGetAllData
        .call(params ?? state.filter!);

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          filter: params ?? state.filter,
          data: const PresensiModel(),
          lstData: [],
          hasReachedMax: false,
        ),
      ),
      (value) {
        // Note: page start from 0
        final isNextPage =
            (params?.pagination?.page ?? state.filter?.pagination?.page ?? 0) >
            0;
        final currentList = state.lstData ?? [];
        final newList = isNextPage ? [...currentList, ...value] : value;

        // reached max: if returned items are less than limit
        final limit =
            params?.pagination?.limit ?? state.filter?.pagination?.limit;
        final reachedMax = (limit != null)
            ? value.length < limit
            : value.isEmpty;

        emit(
          state.copyWith(
            status: TypeState.loaded,
            lstData: newList,
            data: newList.isNotEmpty ? newList.first : null,
            filter: params ?? state.filter,
            hasReachedMax: reachedMax,
          ),
        );
      },
    );
  }

  void fetchNextPage() async {
    emit(state.copyWith(status: TypeState.loading));
    if (state.hasReachedMax) return;

    final currentPage = state.filter?.pagination?.page ?? 0;
    final nextPage = currentPage + 1;

    final updatedFilter = state.filter?.copyWith(
      pagination: state.filter?.pagination?.copyWith(page: nextPage),
    );

    updateFilter(updatedFilter!);
    getAllData();
  }

  void updateFilter(PresensiFilterEntity newFilter) {
    emit(state.copyWith(filter: newFilter));
  }
}
