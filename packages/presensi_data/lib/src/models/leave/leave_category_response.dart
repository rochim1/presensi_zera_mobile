import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_category_response.freezed.dart';

part 'leave_category_response.g.dart';

String? _toString(dynamic value) => value?.toString();

@freezed
abstract class LeaveCategoryResponse with _$LeaveCategoryResponse {
  const factory LeaveCategoryResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'nama_kategori_cuti', defaultValue: '') required String name,
    @JsonKey(name: 'is_special', fromJson: _toString) String? isSpecial,
    @JsonKey(name: 'sugested_day_off', defaultValue: 0)
    required int suggestedDayOff,
    @JsonKey(name: 'allow_half_day', defaultValue: false)
    required bool isAllowHalfDay,
    @JsonKey(name: 'allow_exceed_annually', fromJson: _toString)
    String? isAllowExceedAnnually,
    @JsonKey(name: 'number_of_exceed', defaultValue: 0)
    required int numberOfExceed,
    @JsonKey(name: 'max_duration_days', defaultValue: 0)
    required int maxDurationInDays,
    @JsonKey(name: 'keterangan', defaultValue: '') required String keterangan,
    @JsonKey(name: 'need_upload_file', defaultValue: false)
    required bool isNeedAttachment,
    @JsonKey(name: 'allow_min_gap', fromJson: _toString) String? isAllowMinGap,
    @JsonKey(name: 'min_gap_before_cuti', defaultValue: 0)
    required int minGapBeforeCuti,
    @JsonKey(name: 'status', defaultValue: '') required String status,
  }) = _LeaveCategoryResponse;

  factory LeaveCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$LeaveCategoryResponseFromJson(json);
}
