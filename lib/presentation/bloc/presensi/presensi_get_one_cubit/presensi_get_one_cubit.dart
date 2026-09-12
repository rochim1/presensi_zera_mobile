import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'presensi_get_one_state.dart';

class PresensiGetOneCubit extends Cubit<PresensiGetOneState> {
  final PresensiGetOne presensiGetOne;

  PresensiGetOneCubit(this.presensiGetOne) : super(const PresensiGetOneState());

  Future<void> getOne(PresensiGetOneParams params) async {
    emit(state.copyWith(status: TypeState.loading));

    final Either<Failure, PresensiEntity> data = await presensiGetOne.call(
      params,
    );

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          data: const PresensiModel(),
        ),
      ),
      (value) {
        emit(state.copyWith(status: TypeState.loaded, data: value));
      },
    );
  }
}
