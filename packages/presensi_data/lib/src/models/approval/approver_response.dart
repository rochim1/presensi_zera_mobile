import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'approver_response.g.dart';

part 'approver_response.freezed.dart';

@freezed
abstract class ApproverResponse with _$ApproverResponse {
  const factory ApproverResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'user_id') required UserResponse user,
    @JsonKey(
      name: 'status',
      defaultValue: ApprovalStatus.pending,
      unknownEnumValue: ApprovalStatus.pending,
    )
    required ApprovalStatus status,
    @JsonKey(name: 'level', defaultValue: 0) required int level,
    @JsonKey(name: 'level_name', defaultValue: '') required String levelName,
    @JsonKey(name: 'catatan') String? catatan,

    @JsonKey(name: 'acted_at', defaultValue: null)
    @NullableStringTimestampConverter()
    DateTime? actedAt,
  }) = _ApproverResponse;

  factory ApproverResponse.fromJson(Map<String, dynamic> json) =>
      _$ApproverResponseFromJson(json);
}
