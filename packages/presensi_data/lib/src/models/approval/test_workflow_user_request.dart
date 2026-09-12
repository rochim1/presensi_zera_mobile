import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_workflow_user_request.freezed.dart';
part 'test_workflow_user_request.g.dart';

@freezed
abstract class TestWorkflowUserRequest with _$TestWorkflowUserRequest {
  const factory TestWorkflowUserRequest({
    @JsonKey(name: 'module') String? module,
    @JsonKey(name: 'testUserId') required String testUserId,
  }) = _TestWorkflowUserRequest;

  factory TestWorkflowUserRequest.fromJson(Map<String, dynamic> json) =>
      _$TestWorkflowUserRequestFromJson(json);
}
