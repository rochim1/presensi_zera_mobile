import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'global_get_version_state.dart';

class GlobalGetVersionCubit extends Cubit<GlobalGetVersionState> {
  final GlobalGetVersion globalGetVersion;
  GlobalGetVersionCubit(this.globalGetVersion)
    : super(const GlobalGetVersionState());

  Future<void> getData() async {
    emit(state.copyWith(status: TypeState.loading));
    Either<Failure, String?> data = await globalGetVersion.call(NoParams());

    data.fold(
      (failure) =>
          emit(state.copyWith(status: TypeState.notLoaded, failure: failure)),
      (value) => emit(state.copyWith(status: TypeState.loaded, version: value)),
    );
  }
}
