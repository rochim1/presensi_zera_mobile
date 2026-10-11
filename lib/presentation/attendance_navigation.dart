import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

import 'interaction_gate.dart';

/// Unlock the entry button when the destination is added, rather than waiting
/// for its pop future (which may never complete if the route is replaced).
Future<T?> pushAttendanceWithGate<T>(
  StackRouter router,
  PageRouteInfo route,
  InteractionGate gate,
) async {
  final root = router.root;
  var released = false;
  var releaseScheduled = false;
  late void Function() onNavigation;
  void release() {
    if (released) return;
    released = true;
    root.removeListener(onNavigation);
    gate.release();
  }

  onNavigation = () {
    if (!releaseScheduled && root.topRoute.name == route.routeName) {
      releaseScheduled = true;
      // Keep queued taps blocked until the destination has rendered.
      WidgetsBinding.instance.addPostFrameCallback((_) => release());
    }
  };
  root.addListener(onNavigation);
  try {
    final result = router.push<T>(route);
    onNavigation();
    return await result;
  } finally {
    release();
  }
}
