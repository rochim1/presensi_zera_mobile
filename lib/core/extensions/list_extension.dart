import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

extension ListPresensiAktivitasExtension on List<PresensiAktivitasEntity> {
  PresensiAktivitasEntity? findActivityByStatusKerja(StatusKerja statusKerja) {
    try {
      return firstWhere(
        (element) => element.aktivitas?.toStatusKerja == statusKerja,
      );
    } catch (_) {
      return null;
    }
  }
}
