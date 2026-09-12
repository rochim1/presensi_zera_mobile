import 'package:equatable/equatable.dart';

class PresensiFormatWaktuEntity extends Equatable {
  final String? jamMasukKerja;
  final String? jamIstirahatKerja;
  final String? jamKembaliKerja;
  final String? jamPulangKerja;

  const PresensiFormatWaktuEntity({
    this.jamMasukKerja,
    this.jamIstirahatKerja,
    this.jamKembaliKerja,
    this.jamPulangKerja,
  });

  @override
  List<Object?> get props => [
    jamMasukKerja,
    jamIstirahatKerja,
    jamKembaliKerja,
    jamPulangKerja,
  ];
}
