class TestWorkflowUserResult {
  final bool? isAutoApproved;
  final List<TestWorkflowLevelResult>? levels;

  TestWorkflowUserResult({
    this.isAutoApproved,
    this.levels,
  });
}

class TestWorkflowLevelResult {
  final bool? userIsApprover;

  TestWorkflowLevelResult({
    this.userIsApprover,
  });
}
