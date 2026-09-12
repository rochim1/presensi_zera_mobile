part of 'global_pdf_viewer_cubit.dart';

class GlobalPdfViewerState extends Equatable {
  final TypeState status;
  final bool isStorageGranted;
  final String? message;
  final Uint8List? uInt8;
  final File? file;

  const GlobalPdfViewerState({
    this.status = TypeState.initial,
    this.isStorageGranted = false,
    this.message,
    this.uInt8,
    this.file,
  });

  @override
  List<Object?> get props => [status, message, isStorageGranted, file, uInt8];

  GlobalPdfViewerState copyWith({
    TypeState? status,
    File? file,
    bool? isStorageGranted,
    String? message,
    Uint8List? uInt8,
  }) {
    return GlobalPdfViewerState(
      status: status ?? this.status,
      file: file ?? this.file,
      isStorageGranted: isStorageGranted ?? this.isStorageGranted,
      message: message ?? this.message,
      uInt8: uInt8 ?? this.uInt8,
    );
  }
}
