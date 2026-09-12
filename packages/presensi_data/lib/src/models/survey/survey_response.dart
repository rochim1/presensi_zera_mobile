import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_response.g.dart';
part 'survey_response.freezed.dart';

@freezed
abstract class SurveyResponse with _$SurveyResponse {
  const factory SurveyResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'survey_code', defaultValue: '') required String surveyCode,
    @JsonKey(name: 'title', defaultValue: '') required String title,
    @JsonKey(name: 'description', defaultValue: '') required String description,
    @JsonKey(name: 'start_date', fromJson: _parseDateTime) DateTime? startDate,
    @JsonKey(name: 'end_date', fromJson: _parseDateTime) DateTime? endDate,
    @JsonKey(name: 'is_required', defaultValue: false) required bool isRequired,
    @JsonKey(name: 'is_anonymous', defaultValue: false)
    required bool isAnonymous,
    @JsonKey(name: 'total_responses', defaultValue: 0, fromJson: _parseInt)
    required int totalResponses,
    @JsonKey(name: 'createdAt', fromJson: _parseDateTime) DateTime? createdAt,
  }) = _SurveyResponse;

  factory SurveyResponse.fromJson(Map<String, dynamic> json) =>
      _$SurveyResponseFromJson(json);
}

DateTime? _parseDateTime(Object? value) {
  if (value == null) return null;

  if (value is int) {
    if (value <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(
      value < 1000000000000 ? value * 1000 : value,
    );
  }

  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    final parsedNumber = int.tryParse(trimmed);
    if (parsedNumber != null) {
      if (parsedNumber <= 0) return null;
      return DateTime.fromMillisecondsSinceEpoch(
        parsedNumber < 1000000000000 ? parsedNumber * 1000 : parsedNumber,
      );
    }

    return DateTime.tryParse(trimmed);
  }

  return null;
}

int _parseInt(Object? value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
