import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'apotek_post_data_state.dart';

class ApotekPostDataCubit extends Cubit<ApotekPostDataState> {
  final ApotekPostData apotekPostData;
  ApotekPostDataCubit(this.apotekPostData) : super(const ApotekPostDataState());

  Future<void> postData(ApotekParamsEntity params) async {
    emit(state.copyWith(status: TypeState.loading));
    final Either<Failure, ApotekEntity> data = await apotekPostData.call(
      params,
    );

    data.fold(
      (failure) =>
          emit(state.copyWith(status: TypeState.notLoaded, failure: failure)),
      (value) => emit(state.copyWith(status: TypeState.loaded, data: value)),
    );
  }
}
