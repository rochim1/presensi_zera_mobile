import 'package:equatable/equatable.dart';
import 'kpi_indicator_ref.dart';

class KpiScore extends Equatable {
  final KpiIndicatorRef? indicator;
  final double? bobot;
  final double? target;
  final double? targetMinimum;
  final double? targetMax;
  final double? nilaiAktual;
  final String? sumber;
  final double? selfRating;
  final String? catatanKaryawan;
  final double? managerRating;
  final String? catatanReviewer;
  final double? nilaiRating;
  final double? nilaiTerbobot;
  final String? autoData;

  const KpiScore({
    this.indicator,
    this.bobot,
    this.target,
    this.targetMinimum,
    this.targetMax,
    this.nilaiAktual,
    this.sumber,
    this.selfRating,
    this.catatanKaryawan,
    this.managerRating,
    this.catatanReviewer,
    this.nilaiRating,
    this.nilaiTerbobot,
    this.autoData,
  });

  @override
  List<Object?> get props => [
        indicator,
        bobot,
        target,
        targetMinimum,
        targetMax,
        nilaiAktual,
        sumber,
        selfRating,
        catatanKaryawan,
        managerRating,
        catatanReviewer,
        nilaiRating,
        nilaiTerbobot,
        autoData,
      ];
}
