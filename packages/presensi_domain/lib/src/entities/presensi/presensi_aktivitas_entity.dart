import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class PresensiAktivitasEntity extends Equatable {
  final String? aktivitas;
  final String? jamMulai;
  final LocationEntity? lokasi;
  final bool? isLate;

  const PresensiAktivitasEntity({
    this.aktivitas,
    this.jamMulai,
    this.lokasi,
    this.isLate,
  });

  @override
  List<Object?> get props => [aktivitas, jamMulai, lokasi, isLate];
}
