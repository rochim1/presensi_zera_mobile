import 'package:presensi_domain/presensi_domain.dart';

class AvailableShiftForSwap {
  final String id;
  final ShiftSchedule currentShift;
  final User user;

  const AvailableShiftForSwap({
    required this.id,
    required this.currentShift,
    required this.user,
  });
}
