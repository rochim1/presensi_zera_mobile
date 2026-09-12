class PayrollDeductionSummary {
  final double bpjsKesehatan;
  final double bpjsKetenagakerjaanJht;
  final double bpjsKetenagakerjaanJp;
  final double pajakPph21;
  final double punishmentKeterlambatan;
  final double punishmentAbsenTanpaIjin;
  final double punishmentPulangAwal;
  final double punishmentLupaPresensi;

  const PayrollDeductionSummary({
    this.bpjsKesehatan = 0,
    this.bpjsKetenagakerjaanJht = 0,
    this.bpjsKetenagakerjaanJp = 0,
    this.pajakPph21 = 0,
    this.punishmentKeterlambatan = 0,
    this.punishmentAbsenTanpaIjin = 0,
    this.punishmentPulangAwal = 0,
    this.punishmentLupaPresensi = 0,
  });
}
