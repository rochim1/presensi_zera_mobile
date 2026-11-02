import 'package:auto_route/auto_route.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/injections.dart';

import 'app_router.dart';

class AppGuard extends AutoRouteGuard {
  final LoginCheck loginCheck;

  AppGuard(this.loginCheck);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final data = await loginCheck.call(NoParams());

    data.fold(
      (failure) => resolver.redirectUntil(
        IntroPageRoute(
          onLoginResult: (validate, user) {
            if (validate ?? false) {
              if (user?.user?.instansiId == null) {
                resolver.next(false);
                router.root.replaceAll([
                  InstansiSetupPageRoute(initialEmail: user?.user?.email),
                ]);
                return;
              }
              fl.token = user!.token;
              _recordUser(user.userId);
              resolver.next();
            }
          },
        ),
      ),
      (value) {
        fl.token = value?.token;
        if (value != null) _recordUser(value.userId);
        return resolver.next(true);
      },
    );
  }

  void _recordUser(String userId) {
    if (kIsWeb || kDebugMode) return;
    unawaited(() async {
      try {
        await fs.setUserIdentifier(userId);
        await fa.setUserId(id: userId);
      } catch (error) {
        debugPrint('Auth telemetry unavailable: $error');
      }
    }());
  }
}

/// Prevents an authenticated user from returning to the login screen, for
/// example by using the browser's Back button on web.
class GuestOnlyGuard extends AutoRouteGuard {
  final LoginCheck loginCheck;

  GuestOnlyGuard(this.loginCheck);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final data = await loginCheck.call(NoParams());

    data.fold(
      (_) => resolver.next(),
      (user) => user == null ? resolver.next() : null,
    );

    final user = data.fold((_) => null, (user) => user);
    if (user != null) {
      resolver.next(false);
      await router.replaceAll(const [
        MainPageRoute(children: [HomePageRoute()]),
      ]);
    }
  }
}
