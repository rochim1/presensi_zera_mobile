import 'package:equatable/equatable.dart';

class EffectiveSchedule extends Equatable {
  final bool isShift;
  final bool isRegular;
  final String? effectiveJamMasuk;
  final String? effectiveJamPulang;
  final String? effectiveJadwalName;

  const EffectiveSchedule({
    this.isShift = false,
    this.isRegular = false,
    this.effectiveJamMasuk,
    this.effectiveJamPulang,
    this.effectiveJadwalName,
  });

  @override
  List<Object?> get props => [
        isShift,
        isRegular,
        effectiveJamMasuk,
        effectiveJamPulang,
        effectiveJadwalName,
      ];
}
