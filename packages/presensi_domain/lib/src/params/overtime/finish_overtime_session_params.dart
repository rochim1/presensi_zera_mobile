import 'package:http/http.dart';

class FinishOvertimeSessionParams {
  final String? overtimeId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String reason;
  final List<MultipartFile?> attachments;

  const FinishOvertimeSessionParams({
    this.overtimeId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reason,
    this.attachments = const [],
  });
}
