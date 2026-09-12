import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/values/_values.dart';

part 'user_get_all_inventaris_state.dart';

class UserGetAllInventarisCubit extends Cubit<UserGetAllInventarisState> {
  final UserGetAllInventaris userGetAllInventaris;

  UserGetAllInventarisCubit(this.userGetAllInventaris)
    : super(const UserGetAllInventarisState());

  Future<void> getAllData([InventarisFilterEntity? params]) async {
    emit(state.copyWith(status: TypeState.loading));

    final Either<Failure, List<InventarisEntity>> data =
        await userGetAllInventaris.call(
          params ?? const InventarisFilterEntity(),
        );

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: failure,
          lstInventaris: [],
        ),
      ),
      (value) =>
          emit(state.copyWith(status: TypeState.loaded, lstInventaris: value)),
    );
  }
}
