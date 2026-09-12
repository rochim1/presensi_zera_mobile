import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'payroll_slip_response.freezed.dart';
part 'payroll_slip_response.g.dart';

@freezed
abstract class PayrollSlipResponse with _$PayrollSlipResponse {
  const factory PayrollSlipResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'user_id') PayrollSlipUserResponse? user,
    @JsonKey(name: 'periode') String? period,
    @JsonKey(name: 'bulan') int? month,
    @JsonKey(name: 'tahun') int? year,
    @JsonKey(
      name: 'status',
      defaultValue: PayrollSlipStatus.unknown,
      unknownEnumValue: PayrollSlipStatus.unknown,
    )
    required PayrollSlipStatus status,
    @JsonKey(name: 'kehadiran') PayrollAttendanceSummaryResponse? attendance,
    @JsonKey(name: 'gaji_pokok', defaultValue: 0) required double baseSalary,
    @JsonKey(name: 'total_tunjangan', defaultValue: 0)
    required double totalAllowance,
    @JsonKey(name: 'total_lembur', defaultValue: 0)
    required double totalOvertime,
    @JsonKey(name: 'total_insentif', defaultValue: 0)
    required double totalIncentive,
    @JsonKey(name: 'total_pendapatan', defaultValue: 0)
    required double totalIncome,
    @JsonKey(name: 'total_potongan', defaultValue: 0)
    required double totalDeduction,
    @JsonKey(name: 'gaji_bersih', defaultValue: 0) required double netSalary,
    @JsonKey(name: 'total_adjustment_pendapatan', defaultValue: 0)
    required double totalIncomeAdjustment,
    @JsonKey(name: 'total_adjustment_potongan', defaultValue: 0)
    required double totalDeductionAdjustment,
    @JsonKey(name: 'potongan') PayrollDeductionSummaryResponse? deductions,
    @JsonKey(name: 'catatan') String? notes,
    @JsonKey(name: 'cancel_reason') String? cancelReason,
  }) = _PayrollSlipResponse;

  factory PayrollSlipResponse.fromJson(Map<String, dynamic> json) =>
      _$PayrollSlipResponseFromJson(json);
}

@freezed
abstract class PayrollSlipUserResponse with _$PayrollSlipUserResponse {
  const factory PayrollSlipUserResponse({
    @JsonKey(name: '_id', defaultValue: '') required String id,
    @JsonKey(name: 'name', defaultValue: '') required String name,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'divisi_id', fromJson: _departmentNameFromJson)
    String? departmentName,
    @JsonKey(name: 'jabatan_id', fromJson: _positionNameFromJson)
    String? positionName,
  }) = _PayrollSlipUserResponse;

  factory PayrollSlipUserResponse.fromJson(Map<String, dynamic> json) =>
      _$PayrollSlipUserResponseFromJson(json);
}

@freezed
abstract class PayrollAttendanceSummaryResponse
    with _$PayrollAttendanceSummaryResponse {
  const factory PayrollAttendanceSummaryResponse({
    @JsonKey(name: 'total_hari_kerja', defaultValue: 0)
    required int totalHariKerja,
    @JsonKey(name: 'total_hadir', defaultValue: 0) required int totalHadir,
    @JsonKey(name: 'total_izin', defaultValue: 0) required int totalIzin,
    @JsonKey(name: 'total_cuti', defaultValue: 0) required int totalCuti,
    @JsonKey(name: 'total_alpha', defaultValue: 0) required int totalAlpha,
    @JsonKey(name: 'total_terlambat', defaultValue: 0)
    required int totalTerlambat,
    @JsonKey(name: 'total_menit_terlambat', defaultValue: 0)
    required int totalMenitTerlambat,
    @JsonKey(name: 'total_pulang_awal', defaultValue: 0)
    required int totalPulangAwal,
    @JsonKey(name: 'total_lupa_presensi', defaultValue: 0)
    required int totalLupaPresensi,
  }) = _PayrollAttendanceSummaryResponse;

  factory PayrollAttendanceSummaryResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$PayrollAttendanceSummaryResponseFromJson(json);
}

@freezed
abstract class PayrollDeductionSummaryResponse
    with _$PayrollDeductionSummaryResponse {
  const factory PayrollDeductionSummaryResponse({
    @JsonKey(name: 'bpjs_kesehatan', defaultValue: 0)
    required double bpjsKesehatan,
    @JsonKey(name: 'bpjs_ketenagakerjaan_jht', defaultValue: 0)
    required double bpjsKetenagakerjaanJht,
    @JsonKey(name: 'bpjs_ketenagakerjaan_jp', defaultValue: 0)
    required double bpjsKetenagakerjaanJp,
    @JsonKey(name: 'pajak_pph21', defaultValue: 0) required double pajakPph21,
    @JsonKey(name: 'punishment_keterlambatan', defaultValue: 0)
    required double punishmentKeterlambatan,
    @JsonKey(name: 'punishment_absen_tanpa_ijin', defaultValue: 0)
    required double punishmentAbsenTanpaIjin,
    @JsonKey(name: 'punishment_pulang_awal', defaultValue: 0)
    required double punishmentPulangAwal,
    @JsonKey(name: 'punishment_lupa_presensi', defaultValue: 0)
    required double punishmentLupaPresensi,
  }) = _PayrollDeductionSummaryResponse;

  factory PayrollDeductionSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$PayrollDeductionSummaryResponseFromJson(json);
}

String? _departmentNameFromJson(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value['nama_divisi'] as String?;
  }
  return null;
}

String? _positionNameFromJson(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value['nama_jabatan'] as String?;
  }
  return null;
}
