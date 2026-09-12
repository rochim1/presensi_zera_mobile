import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/utils/_utils.dart';
import 'package:presensi_mobile/core/values/_values.dart';

part 'global_attachment_state.dart';

class GlobalAttachmentCubit extends Cubit<GlobalAttachmentState> {
  GlobalAttachmentCubit() : super(const GlobalAttachmentState());

  void initial(PlatformFile? file) {
    if (file == null) return emit(const GlobalAttachmentState());

    emit(state.copyWith(typeState: TypeState.loaded, files: [file]));
  }

  void uploadFile([
    bool? multiple = false,
    List<String>? extensions,
    FileType? type,
  ]) async {
    try {
      List<PlatformFile> result = await AppUtility.fileAttachment(
        multiple!,
        extensions,
        type,
      );

      if (multiple && state.files != null) {
        emit(
          state.copyWith(
            typeState: TypeState.loaded,
            files: [...state.files!, ...result],
          ),
        );
      } else {
        emit(state.copyWith(typeState: TypeState.loaded, files: result));
      }
    } catch (e) {
      if (state.files != null) {
        emit(state.copyWith(typeState: TypeState.loaded, files: state.files));
      } else {
        if (e is ProsessFailure) {
          emit(state.copyWith(typeState: TypeState.notLoaded, failure: e));
        } else {
          emit(
            state.copyWith(
              typeState: TypeState.notLoaded,
              failure: const UnknownFailure(),
            ),
          );
        }
      }
    }
  }

  void deleteFiles(PlatformFile file) async {
    if (state.files != null) {
      final newBenefitsList = state.files!;
      newBenefitsList.remove(file);

      if (state.files!.isEmpty) {
        emit(const GlobalAttachmentState());
      } else {
        emit(
          state.copyWith(typeState: TypeState.loaded, files: newBenefitsList),
        );
      }
    } else {
      emit(
        state.copyWith(
          typeState: TypeState.notLoaded,
          failure: const ProsessFailure(message: FAILURE_UNKNOWN),
        ),
      );
      emit(const GlobalAttachmentState());
    }
  }
}
