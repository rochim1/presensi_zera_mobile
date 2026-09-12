import 'package:presensi_domain/presensi_domain.dart';

class BreakOutParams {
  final StatusKerja statusKerja;
  final bool isJoinAgain;
  final DateTime jamMulai;

  BreakOutParams({
    this.statusKerja = StatusKerja.kerja,
    this.isJoinAgain = true,
    required this.jamMulai,
  });
}
