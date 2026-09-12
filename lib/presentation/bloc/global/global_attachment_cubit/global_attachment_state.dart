part of 'global_attachment_cubit.dart';

class GlobalAttachmentState extends Equatable {
  final TypeState typeState;
  final Failure? failure;
  final List<PlatformFile>? files;

  const GlobalAttachmentState({
    this.typeState = TypeState.initial,
    this.failure,
    this.files,
  });

  GlobalAttachmentState copyWith({
    TypeState? typeState,
    Failure? failure,
    List<PlatformFile>? files,
  }) {
    return GlobalAttachmentState(
      typeState: typeState ?? this.typeState,
      failure: failure ?? this.failure,
      files: files ?? this.files,
    );
  }

  @override
  List<Object?> get props => [typeState, failure, files];
}
