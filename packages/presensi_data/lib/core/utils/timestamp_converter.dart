import 'package:json_annotation/json_annotation.dart';

class StringTimestampConverter implements JsonConverter<DateTime, String> {
  const StringTimestampConverter();

  @override
  DateTime fromJson(String json) {
    final timestamp = int.tryParse(json);

    if (timestamp == null) {
      throw FormatException('Invalid timestamp format: $json');
    }

    // Handle seconds vs milliseconds
    if (timestamp < 1000000000000) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    }

    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  @override
  String toJson(DateTime object) {
    return object.millisecondsSinceEpoch.toString();
  }
}

class NullableStringTimestampConverter
    implements JsonConverter<DateTime?, String?> {
  const NullableStringTimestampConverter();

  @override
  DateTime? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;

    final timestamp = int.tryParse(json);
    if (timestamp == null) return null;

    // handle seconds vs milliseconds
    if (timestamp < 1000000000000) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    }

    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  @override
  String? toJson(DateTime? object) {
    return object?.millisecondsSinceEpoch.toString();
  }
}
