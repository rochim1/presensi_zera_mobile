import 'package:presensi_mobile/presentation/interaction_gate.dart';

/// Keeps the confirmed visit when an order needs to be retried.
class DeliverySubmissionController extends InteractionGate {
  bool visitCompleted = false;
  bool isComplete = false;

  Future<bool> submit({
    required Future<bool> Function() submitVisit,
    Future<bool> Function()? submitOrder,
  }) async {
    if (isComplete || !tryAcquire()) return false;
    try {
      if (!visitCompleted) {
        if (!await submitVisit()) return false;
        visitCompleted = true;
      }
      if (submitOrder != null && !await submitOrder()) return false;
      isComplete = true;
      return true;
    } finally {
      release();
    }
  }
}
