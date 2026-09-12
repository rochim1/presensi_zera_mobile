import 'package:auto_route/auto_route.dart';
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
      (failure) => router.pushAndPopUntil(
        IntroPageRoute(
          onLoginResult: (validate, user) {
            if (validate ?? false) {
              if (user?.user?.instansiId == null) {
                resolver.next(false);
                router.pushAndPopUntil(
                  InstansiSetupPageRoute(initialEmail: user?.user?.email),
                  predicate: (route) => true,
                );
                return;
              }
              if (!kIsWeb) {
                fs.setUserIdentifier(user!.userId);
                fa.setUserId(id: user.userId);
              }
              fl.token = user!.token;
              resolver.next();
              router.removeLast();
            }
          },
        ),
        predicate: (r) => true,
      ),
      (value) {
        if (!kIsWeb) {
          fs.setUserIdentifier(value!.userId);
          fa.setUserId(id: value.userId);
        }
        fl.token = value?.token;
        return resolver.next(true);
      },
    );
  }
}
