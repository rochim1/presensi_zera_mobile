import 'package:json_annotation/json_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'presensi_photo_model.g.dart';

@JsonSerializable(includeIfNull: true, createToJson: false)
class PresensiPhotoModel extends PresensiPhotoEntity {
  @JsonKey(name: 'filePath_In')
  final String? filePathIn;
  @JsonKey(name: 'filePath_Out')
  final String? filePathOut;
  @JsonKey(name: 'keterangan_checkIn')
  final String? keteranganCheckIn;
  @JsonKey(name: 'keterangan_checkOut')
  final String? keteranganCheckOut;

  const PresensiPhotoModel({
    this.filePathIn,
    this.filePathOut,
    this.keteranganCheckIn,
    this.keteranganCheckOut,
  }) : super(
         filePathIn: filePathIn,
         filePathOut: filePathOut,
         keteranganCheckIn: keteranganCheckIn,
         keteranganCheckOut: keteranganCheckOut,
       );

  factory PresensiPhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PresensiPhotoModelFromJson(json);
}
