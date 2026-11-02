import 'package:auto_route/auto_route.dart';
import 'app_router.dart';

/// Logout can dispose the calling tab while clearing account state.
/// Capture the root before awaiting, and replace the entire private stack.
Future<void> finishPantooSignOut(
  StackRouter router,
  Future<void> Function() clearSession,
) async {
  final root = router.root;
  await clearSession();
  await root.replaceAll([LoginPageRoute()]);
}
