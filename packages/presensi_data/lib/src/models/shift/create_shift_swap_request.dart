import 'package:intl/intl.dart';
import 'package:presensi_domain/presensi_domain.dart';

class CreateShiftSwapRequestRequest {
  final CreateShiftSwapRequestParams params;

  const CreateShiftSwapRequestRequest(this.params);

  Map<String, dynamic> toJson() => {
    'shift_schedule_id': params.shiftScheduleId,
    'target_user_id': params.targetUserId,
    if (params.targetScheduleId != null)
      'target_schedule_id': params.targetScheduleId,
    'shift_date': DateFormat('yyyy-MM-dd').format(params.shiftDate),
    if (params.targetShiftDate != null)
      'target_shift_date': DateFormat(
        'yyyy-MM-dd',
      ).format(params.targetShiftDate!),
    'alasan': params.reason,
  };
}
