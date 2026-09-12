class CreateShiftSwapRequestParams {
  final String shiftScheduleId;
  final String targetUserId;
  final String? targetScheduleId;
  final DateTime shiftDate;
  final DateTime? targetShiftDate;
  final String reason;

  const CreateShiftSwapRequestParams({
    required this.shiftScheduleId,
    required this.targetUserId,
    this.targetScheduleId,
    required this.shiftDate,
    this.targetShiftDate,
    required this.reason,
  });
}
