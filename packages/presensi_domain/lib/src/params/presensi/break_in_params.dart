import 'package:presensi_domain/presensi_domain.dart';

class BreakInParams {
  final StatusKerja statusKerja;
  final DateTime jamMulai;

  BreakInParams({
    this.statusKerja = StatusKerja.istirahat,
    required this.jamMulai,
  });
}
