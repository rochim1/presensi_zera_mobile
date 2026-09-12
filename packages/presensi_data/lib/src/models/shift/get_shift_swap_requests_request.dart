import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'get_shift_swap_requests_request.freezed.dart';

part 'get_shift_swap_requests_request.g.dart';

@freezed
abstract class GetShiftSwapRequestsRequest with _$GetShiftSwapRequestsRequest {
  const factory GetShiftSwapRequestsRequest({
    @DateConverter()
    @JsonKey(name: 'startDate', includeIfNull: false)
    DateTime? startDate,
    @DateConverter()
    @JsonKey(name: 'endDate', includeIfNull: false)
    DateTime? endDate,
    @JsonKey(name: 'status', includeIfNull: false) RequestStatus? status,
    @JsonKey(name: 'page', includeIfNull: false) int? page,
    @JsonKey(name: 'limit', includeIfNull: false) int? limit,
  }) = _GetShiftSwapRequestsRequest;

  factory GetShiftSwapRequestsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetShiftSwapRequestsRequestFromJson(json);
}
