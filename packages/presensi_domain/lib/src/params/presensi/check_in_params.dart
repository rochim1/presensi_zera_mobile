import 'package:http/http.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CheckInParams {
  final MultipartFile? fotoPresensi;
  final List<MultipartFile> fotoPendukung;
  final CheckInInputParams input;

  const CheckInParams({
    required this.fotoPresensi,
    this.fotoPendukung = const [],
    required this.input,
  });
}

class CheckInInputParams {
  final StatusKerja statusKerja;
  final String? keterangan;
  final AppLocation location;
  final AttendanceType type;
  final DateTime jamMulai;

  CheckInInputParams({
    this.statusKerja = StatusKerja.kerja,
    required this.keterangan,
    required this.location,
    required this.type,
    required this.jamMulai,
  });
}
