import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'user_get_local_state.dart';

class UserGetLocalCubit extends Cubit<UserGetLocalState> {
  final UserGetLocal getUserLocal;
  UserGetLocalCubit(this.getUserLocal) : super(const UserGetLocalState());

  Future<void> getData([bool hasLoading = true]) async {
    if (hasLoading) emit(state.copyWith(status: TypeState.loading));

    final data = await getUserLocal.call(NoParams());

    data.fold(
      (failure) =>
          emit(state.copyWith(status: TypeState.notLoaded, failure: failure)),
      (value) => emit(
        state.copyWith(
          status: TypeState.loaded,
          data: value,
          isMarketing:
              value.user?.divisiId?.namaDivisi?.toDivisiType?.isMarketing,
        ),
      ),
    );
  }
}
