import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'user_post_state.dart';

class UserPostCubit extends Cubit<UserPostState> {
  final UserPost userPost;
  final UserPostAccount userPostAccount;

  UserPostCubit({required this.userPost, required this.userPostAccount})
    : super(const UserPostState());

  Future<void> update(UserParamsEntity params) async {
    emit(state.copyWith(typeState: TypeState.loading));
    Either<Failure, String?> data = await userPost.call(params);

    data.fold(
      (failure) => emit(
        state.copyWith(typeState: TypeState.notLoaded, failure: failure),
      ),
      (value) =>
          emit(state.copyWith(typeState: TypeState.loaded, message: value)),
    );
  }

  Future<void> updateAccount(UserParamsEntity params) async {
    emit(state.copyWith(typeState: TypeState.loading));
    Either<Failure, String?> data = await userPostAccount.call(params);

    data.fold(
      (failure) => emit(
        state.copyWith(typeState: TypeState.notLoaded, failure: failure),
      ),
      (value) =>
          emit(state.copyWith(typeState: TypeState.loaded, message: value)),
    );
  }
}
