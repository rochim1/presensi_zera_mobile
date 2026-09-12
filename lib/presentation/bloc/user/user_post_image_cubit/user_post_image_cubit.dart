import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'package:presensi_data/core/_core.dart';

part 'user_post_image_state.dart';

class UserPostImageCubit extends Cubit<UserPostImageState> {
  final UserPostImage userPostImage;
  final UserDeleteImage userDeleteImage;

  UserPostImageCubit({
    required this.userPostImage,
    required this.userDeleteImage,
  }) : super(const UserPostImageState());

  Future<void> update(ImageSource imageSource) async {
    emit(state.copyWith(typeState: TypeState.loading, failed: false));

    try {
      final XFile file = await AppUtility.pickerImage(imageSource);

      Either<Failure, String?> data = await userPostImage.call(
        await file.toMultipart(),
      );

      data.fold(
        (failure) => emit(
          state.copyWith(
            typeState: TypeState.notLoaded,
            failure: failure,
            failed: false,
          ),
        ),
        (value) => emit(
          state.copyWith(
            typeState: TypeState.loaded,
            message: value,
            failed: false,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          typeState: TypeState.notLoaded,
          message: FAILURE_IMAGE_FILE,
          failed: true,
        ),
      );
    }
  }

  Future<void> delete() async {
    emit(state.copyWith(typeState: TypeState.loading));
    Either<Failure, String?> data = await userDeleteImage.call(NoParams());

    data.fold(
      (failure) => emit(
        state.copyWith(typeState: TypeState.notLoaded, failure: failure),
      ),
      (value) =>
          emit(state.copyWith(typeState: TypeState.loaded, message: value)),
    );
  }
}
