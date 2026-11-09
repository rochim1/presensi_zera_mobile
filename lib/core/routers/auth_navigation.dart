import 'package:auto_route/auto_route.dart';
import 'app_router.dart';

/// Intro is removed, so its pending guard callback must not follow Login.
/// Successful login starts fresh navigation using the persisted session.
void openPantooLogin(StackRouter router) {
  router.pushAndPopUntil(LoginPageRoute(), predicate: (_) => false);
}

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
