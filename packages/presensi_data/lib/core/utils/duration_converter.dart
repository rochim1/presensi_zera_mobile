import 'package:json_annotation/json_annotation.dart';

class DurationConverter implements JsonConverter<Duration, String> {
  const DurationConverter();

  @override
  Duration fromJson(String json) {
    final parts = json.split(':');

    final numbers = parts.map((e) => int.tryParse(e) ?? 0).toList();

    if (numbers.length == 3) {
      return Duration(
        hours: numbers[0],
        minutes: numbers[1],
        seconds: numbers[2],
      );
    } else if (numbers.length == 2) {
      return Duration(minutes: numbers[0], seconds: numbers[1]);
    } else if (numbers.length == 1) {
      return Duration(seconds: numbers[0]);
    }

    return Duration.zero;
  }

  @override
  String toJson(Duration object) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final h = twoDigits(object.inHours);
    final m = twoDigits(object.inMinutes.remainder(60));
    final s = twoDigits(object.inSeconds.remainder(60));

    return "$h:$m:$s";
  }
}

class DurationSecondsConverter implements JsonConverter<Duration, String?> {
  const DurationSecondsConverter();

  @override
  Duration fromJson(String? json) {
    if (json == null || json.isEmpty) return Duration.zero;

    final seconds = double.tryParse(json);
    if (seconds == null) return Duration.zero;

    return Duration(milliseconds: (seconds * 1000).round());
  }

  @override
  String toJson(Duration object) {
    final seconds = object.inMilliseconds / 1000;
    return seconds.toString();
  }
}
