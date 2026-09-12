import 'package:presensi_domain/presensi_domain.dart';

class Announcement {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final AnnouncementPriority prioritas;
  final DateTime? tanggalMulai;
  final DateTime? tanggalBerakhir;
  final bool isPinned;
  final bool showPopup;
  final String bannerImage;
  final String linkUrl;
  final List<AnnouncementAttachment> lampiran;
  final User createdBy;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Announcement({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.prioritas,
    this.tanggalMulai,
    this.tanggalBerakhir,
    required this.isPinned,
    required this.showPopup,
    required this.bannerImage,
    required this.linkUrl,
    required this.lampiran,
    required this.createdBy,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });
}

class AnnouncementAttachment {
  final String namaFile;
  final String url;

  AnnouncementAttachment({this.namaFile = 'File', this.url = ''});
}
