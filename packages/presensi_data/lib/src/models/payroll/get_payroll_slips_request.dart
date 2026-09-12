import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'get_payroll_slips_request.freezed.dart';
part 'get_payroll_slips_request.g.dart';

@freezed
abstract class GetPayrollSlipsRequest with _$GetPayrollSlipsRequest {
  const factory GetPayrollSlipsRequest({
    @JsonKey(name: 'bulan', includeIfNull: false) int? month,
    @JsonKey(name: 'tahun', includeIfNull: false) int? year,
    @JsonKey(name: 'status', includeIfNull: false) PayrollSlipStatus? status,
    @JsonKey(name: 'user_id', includeIfNull: false) String? userId,
  }) = _GetPayrollSlipsRequest;

  factory GetPayrollSlipsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetPayrollSlipsRequestFromJson(json);
}
