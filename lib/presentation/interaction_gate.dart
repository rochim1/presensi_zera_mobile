import 'package:flutter/foundation.dart';

/// Shared by every entry point to the same user interaction.
class InteractionGate extends ValueNotifier<bool> {
  InteractionGate() : super(false);
  bool _disposed = false;

  bool tryAcquire() {
    if (_disposed || value) return false;
    value = true;
    return true;
  }

  void release() {
    if (!_disposed) value = false;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
