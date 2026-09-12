import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'announcement_response.g.dart';

part 'announcement_response.freezed.dart';

@freezed
abstract class AnnouncementResponse with _$AnnouncementResponse {
  const factory AnnouncementResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'judul') required String judul,
    @JsonKey(name: 'isi') required String isi,
    @JsonKey(name: 'kategori') required String kategori,

    @JsonKey(
      name: 'prioritas',
      unknownEnumValue: AnnouncementPriority.rendah,
      defaultValue: AnnouncementPriority.rendah,
    )
    required AnnouncementPriority prioritas,

    @JsonKey(name: 'tanggal_mulai')
    @NullableStringTimestampConverter()
    DateTime? tanggalMulai,
    @JsonKey(name: 'tanggal_berakhir')
    @NullableStringTimestampConverter()
    DateTime? tanggalBerakhir,
    @JsonKey(name: 'is_pinned') required bool isPinned,
    @JsonKey(name: 'show_popup') required bool showPopup,

    @JsonKey(name: 'banner_image', defaultValue: '')
    required String bannerImage,

    @JsonKey(name: 'link_url', defaultValue: '') required String linkUrl,

    @JsonKey(name: 'lampiran', defaultValue: [])
    required List<AnnouncementAttachmentResponse> lampiran,
    @JsonKey(name: 'created_by') required UserResponse createdBy,

    @JsonKey(name: 'instansi_id') required String instansiId,
    @JsonKey(name: 'status') required String status,

    @JsonKey(name: 'createdAt')
    @NullableStringTimestampConverter()
    DateTime? createdAt,
    @JsonKey(name: 'updatedAt')
    @NullableStringTimestampConverter()
    DateTime? updatedAt,
  }) = _AnnouncementResponse;

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementResponseFromJson(json);
}

@freezed
abstract class AnnouncementAttachmentResponse
    with _$AnnouncementAttachmentResponse {
  const factory AnnouncementAttachmentResponse({
    @JsonKey(name: 'nama_file', defaultValue: 'File') required String namaFile,
    @JsonKey(name: 'url', defaultValue: '') required String url,
  }) = _AnnouncementAttachmentResponse;

  factory AnnouncementAttachmentResponse.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementAttachmentResponseFromJson(json);
}
