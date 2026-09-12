import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, String> {
  final String pattern;

  const DateTimeConverter([this.pattern = 'yyyy-MM-dd HH:mm:ss']);

  @override
  DateTime fromJson(String json) {
    if (json.toLowerCase() == 'invalid date') return DateTime.now();
    try {
      return DateFormat(pattern).parse(json);
    } catch (_) {
      try {
        return DateTime.parse(json).toLocal();
      } catch (_) {
        return DateTime.now();
      }
    }
  }

  @override
  String toJson(DateTime object) {
    return DateFormat(pattern).format(object);
  }
}

class NullableDateTimeConverter implements JsonConverter<DateTime?, String?> {
  final String pattern;

  const NullableDateTimeConverter([this.pattern = 'yyyy-MM-dd HH:mm:ss']);

  @override
  DateTime? fromJson(String? json) {
    if (json == null || json.isEmpty || json.toLowerCase() == 'invalid date' || json == '0000-00-00 00:00:00') return null;
    try {
      if (pattern == 'HH:mm' && json.split(':').length >= 3) {
        return DateFormat('HH:mm:ss').parse(json);
      }
      return DateFormat(pattern).parse(json);
    } catch (_) {
      try {
        return DateTime.parse(json).toLocal();
      } catch (_) {
        return null;
      }
    }
  }

  @override
  String? toJson(DateTime? object) {
    if (object == null) return null;
    return DateFormat(pattern).format(object);
  }
}

class TimeConverter extends NullableDateTimeConverter {
  const TimeConverter() : super('HH:mm');
}

class DateConverter extends NullableDateTimeConverter {
  const DateConverter() : super('yyyy-MM-dd');
}

class MonthConverter extends NullableDateTimeConverter {
  const MonthConverter() : super('yyyy-MM');
}
