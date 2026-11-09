import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/routers/app_guard.dart';
import 'package:presensi_mobile/core/routers/app_router.dart';
import 'package:presensi_mobile/core/routers/auth_navigation.dart';
import 'package:presensi_mobile/injections.dart';

class _Check extends Fake implements LoginCheck {
  LoginUserEntity? cached;
  @override
  Future<Either<Failure, LoginUserEntity?>> call(NoParams params) async =>
      cached == null ? Left(CacheFailure()) : Right(cached);
}

const _employee = LoginUserEntity(
  userId: 'employee',
  token: 'test-token',
  user: UserEntity(id: 'employee', instansiId: InstansiEntity()),
);

class _Router extends RootStackRouter {
  _Router({
    required this.guard,
    required this.hasOrganization,
    this.throughLogin = false,
  });
  final bool throughLogin;
  final AppGuard guard;
  final bool hasOrganization;
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: PageInfo(
        MainPageRoute.name,
        builder: (_) => const Scaffold(body: Text('Dashboard')),
      ),
      guards: [guard],
    ),
    AutoRoute(
      path: '/intro',
      page: PageInfo(
        IntroPageRoute.name,
        builder: (data) {
          final args = data.argsAs<IntroPageRouteArgs>();
          return Scaffold(
            body: TextButton(
              onPressed: throughLogin
                  ? () => openPantooLogin(this)
                  : () => args.onLoginResult!(
                      true,
                      hasOrganization
                          ? _employee
                          : const LoginUserEntity(
                              userId: 'new',
                              user: UserEntity(id: 'new'),
                            ),
                    ),
              child: const Text('Google verified'),
            ),
          );
        },
      ),
    ),
    AutoRoute(
      path: '/login',
      page: PageInfo(
        LoginPageRoute.name,
        builder: (data) => Scaffold(
          body: throughLogin
              ? TextButton(
                  onPressed: () {
                    final args = data.argsAs<LoginPageRouteArgs>(
                      orElse: () => const LoginPageRouteArgs(),
                    );
                    expect(args.onLoginResult, isNull);
                    (guard.loginCheck as _Check).cached = _employee;
                    replaceAll([
                      hasOrganization
                          ? const MainPageRoute()
                          : InstansiSetupPageRoute(),
                    ]);
                  },
                  child: const Text('Complete Google login'),
                )
              : const Text('Login'),
        ),
      ),
    ),
    AutoRoute(
      path: '/setup',
      page: PageInfo(
        InstansiSetupPageRoute.name,
        builder: (_) => const Scaffold(body: Text('Setup')),
      ),
    ),
  ];
}

void main() {
  setUpAll(() {
    sl.registerSingleton<FlavorConfig>(
      FlavorConfig.init(env: Env.DEVELOPMENT, values: null),
    );
  });
  for (final hasOrganization in [true, false]) {
    testWidgets(
      'Intro to Login discards obsolete callback, organization=$hasOrganization',
      (tester) async {
        final router = _Router(
          guard: AppGuard(_Check()),
          hasOrganization: hasOrganization,
          throughLogin: true,
        );
        await tester.pumpWidget(
          MaterialApp.router(routerConfig: router.config()),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Google verified'));
        await tester.pumpAndSettle();
        expect(find.text('Complete Google login'), findsOneWidget);
        await tester.tap(find.text('Complete Google login'));
        await tester.pumpAndSettle();
        expect(
          find.text(hasOrganization ? 'Dashboard' : 'Setup'),
          findsOneWidget,
        );
        expect(find.text('Complete Google login'), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        router.dispose();
      },
    );
    testWidgets('guard resumes verified login, organization=$hasOrganization', (
      tester,
    ) async {
      final router = _Router(
        guard: AppGuard(_Check()),
        hasOrganization: hasOrganization,
      );
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router.config()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Google verified'));
      await tester.pumpAndSettle();
      expect(
        find.text(hasOrganization ? 'Dashboard' : 'Setup'),
        findsOneWidget,
      );
      expect(find.text('Google verified'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      router.dispose();
    });
  }
  testWidgets(
    'logout reaches login after clearing state disposes the source route',
    (tester) async {
      final router = _Router(guard: AppGuard(_Check()), hasOrganization: true);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router.config(
            deepLinkBuilder: (_) => DeepLink([LoginPageRoute()]),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final cleared = Completer<void>();
      final logout = finishPantooSignOut(router, () => cleared.future);
      // A session gate may replace the profile subtree while logout awaits.
      await router.replaceAll([InstansiSetupPageRoute()]);
      await tester.pumpAndSettle();
      cleared.complete();
      await tester.pumpAndSettle();
      await logout;
      expect(find.text('Login'), findsOneWidget);
      expect(router.stack.length, 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      router.dispose();
    },
  );
}
