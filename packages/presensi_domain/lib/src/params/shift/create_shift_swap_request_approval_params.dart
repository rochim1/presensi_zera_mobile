import 'package:presensi_domain/presensi_domain.dart';

class CreateShiftSwapRequestApprovalParams {
  final String swapRequestId;
  final RequestStatus? status;
  final String? rejectedReason;

  const CreateShiftSwapRequestApprovalParams({
    required this.swapRequestId,
    this.status,
    this.rejectedReason,
  });
}
