import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'user_get_data_state.dart';

class UserGetDataCubit extends Cubit<UserGetDataState> {
  final UserGetData getUserData;
  UserGetDataCubit(this.getUserData) : super(const UserGetDataState());

  Future<void> getData([bool hasLoading = true]) async {
    if (hasLoading) emit(state.copyWith(status: TypeState.loading));

    final Either<Failure, LoginUserEntity> data = await getUserData.call(
      NoParams(),
    );

    data.fold(
      (failure) =>
          emit(state.copyWith(status: TypeState.notLoaded, failure: failure)),
      (value) => emit(
        state.copyWith(
          status: TypeState.loaded,
          data: value,
          divisiType: value.user?.divisiId?.namaDivisi?.toDivisiType,
        ),
      ),
    );
  }
}
