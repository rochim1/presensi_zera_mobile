class StartOvertimeSessionParams {
  final DateTime date;
  final DateTime startTime;
  final String reason;

  const StartOvertimeSessionParams({
    required this.date,
    required this.startTime,
    required this.reason,
  });
}
