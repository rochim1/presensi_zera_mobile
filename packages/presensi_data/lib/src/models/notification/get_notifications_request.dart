import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_notifications_request.freezed.dart';

part 'get_notifications_request.g.dart';

@freezed
abstract class GetNotificationsRequest with _$GetNotificationsRequest {
  const factory GetNotificationsRequest({
    @JsonKey(name: 'is_myNotif') required bool isMyNotif,
  }) = _GetNotificationsRequest;

  factory GetNotificationsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetNotificationsRequestFromJson(json);
}
