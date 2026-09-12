import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_users_request.freezed.dart';

part 'get_users_request.g.dart';

@freezed
abstract class GetUsersRequest with _$GetUsersRequest {
  const factory GetUsersRequest({
    @JsonKey(name: 'name', includeIfNull: false) String? name,
  }) = _GetUsersRequest;

  factory GetUsersRequest.fromJson(Map<String, dynamic> json) =>
      _$GetUsersRequestFromJson(json);
}
