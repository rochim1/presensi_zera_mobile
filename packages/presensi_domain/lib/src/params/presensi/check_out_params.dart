import 'package:http/http.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CheckOutParams {
  final MultipartFile? fotoPresensi;
  final List<MultipartFile> fotoPendukung;
  final CheckOutInputParams input;

  const CheckOutParams({
    required this.fotoPresensi,
    this.fotoPendukung = const [],
    required this.input,
  });
}

class CheckOutInputParams {
  final StatusKerja statusKerja;
  final String? keterangan;
  final AppLocation location;
  final DateTime jamMulai;
  final Map<String, dynamic> emotionalReport;

  CheckOutInputParams({
    this.statusKerja = StatusKerja.pulang,
    required this.keterangan,
    required this.location,
    required this.jamMulai,
    required this.emotionalReport,
  });
}
