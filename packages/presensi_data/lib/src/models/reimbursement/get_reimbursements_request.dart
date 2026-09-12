import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';

part 'get_reimbursements_request.freezed.dart';

part 'get_reimbursements_request.g.dart';

@freezed
abstract class GetReimbursementsRequest with _$GetReimbursementsRequest {
  const factory GetReimbursementsRequest({
    @JsonKey(name: 'user_id', includeIfNull: false) String? userId,
    @JsonKey(name: 'tanggal_start', includeIfNull: false)
    @DateConverter()
    DateTime? startDate,
    @JsonKey(name: 'tanggal_end', includeIfNull: false)
    @DateConverter()
    DateTime? endDate,
  }) = _GetReimbursementsRequest;

  factory GetReimbursementsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetReimbursementsRequestFromJson(json);
}
