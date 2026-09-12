import 'package:equatable/equatable.dart';

class PresensiPhotoEntity extends Equatable {
  final String? filePathIn;
  final String? filePathOut;
  final String? keteranganCheckIn;
  final String? keteranganCheckOut;

  const PresensiPhotoEntity({
    this.filePathIn,
    this.filePathOut,
    this.keteranganCheckIn,
    this.keteranganCheckOut,
  });

  @override
  List<Object?> get props => [
    filePathIn,
    filePathOut,
    keteranganCheckIn,
    keteranganCheckOut,
  ];
}
