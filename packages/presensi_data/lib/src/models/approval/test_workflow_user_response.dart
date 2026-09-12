import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_workflow_user_response.freezed.dart';
part 'test_workflow_user_response.g.dart';

@freezed
abstract class TestWorkflowUserResponse with _$TestWorkflowUserResponse {
  const factory TestWorkflowUserResponse({
    @JsonKey(name: 'is_auto_approved') bool? isAutoApproved,
    @JsonKey(name: 'levels') List<TestWorkflowLevelResponse>? levels,
  }) = _TestWorkflowUserResponse;

  factory TestWorkflowUserResponse.fromJson(Map<String, dynamic> json) =>
      _$TestWorkflowUserResponseFromJson(json);
}

@freezed
abstract class TestWorkflowLevelResponse with _$TestWorkflowLevelResponse {
  const factory TestWorkflowLevelResponse({
    @JsonKey(name: 'user_is_approver') bool? userIsApprover,
  }) = _TestWorkflowLevelResponse;

  factory TestWorkflowLevelResponse.fromJson(Map<String, dynamic> json) =>
      _$TestWorkflowLevelResponseFromJson(json);
}
