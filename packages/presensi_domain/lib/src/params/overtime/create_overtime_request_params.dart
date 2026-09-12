import 'package:http/http.dart';

class CreateOvertimeRequestParams {
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String reason;
  final List<MultipartFile?> attachments;

  const CreateOvertimeRequestParams({
    this.date,
    this.startTime,
    this.endTime,
    required this.reason,
    this.attachments = const [],
  });
}
