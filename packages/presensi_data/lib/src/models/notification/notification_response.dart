import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'notification_response.g.dart';

part 'notification_response.freezed.dart';

@freezed
abstract class NotificationResponse with _$NotificationResponse {
  const factory NotificationResponse({
    @JsonKey(name: '_id') required String id,

    @JsonKey(name: 'is_read', defaultValue: false) required bool isRead,

    @JsonKey(
      name: 'tipe_notif',
      unknownEnumValue: NotificationNewType.unknown,
      defaultValue: NotificationNewType.unknown,
    )
    required NotificationNewType type,

    @JsonKey(name: 'title', defaultValue: 'Notifikasi') required String title,

    @JsonKey(name: 'body', defaultValue: '') required String body,

    @JsonKey(name: 'createdAt')
    @NullableStringTimestampConverter()
    DateTime? createdAt,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);
}
