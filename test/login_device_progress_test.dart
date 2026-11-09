import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/bloc/login/login_sign_in_cubit/login_sign_in_cubit.dart';

class _Login extends Fake implements LoginSignIn {
  int calls = 0;
  LoginParamsEntity? received;
  final pending = Completer<Either<Failure, LoginUserEntity>>();
  @override
  Future<Either<Failure, LoginUserEntity>> call(LoginParamsEntity params) {
    calls++;
    received = params;
    return pending.future;
  }
}

class _Device extends DeviceInfoPlugin {
  int calls = 0;
  final pending = Completer<AndroidDeviceInfo>();
  @override
  Future<AndroidDeviceInfo> get androidInfo {
    calls++;
    return pending.future;
  }
}

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);
  testWidgets('Android metadata timeout exits loading with visible failure', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final login = _Login(), device = _Device();
    final cubit = LoginSignInCubit(loginSignIn: login, deviceInfo: device);
    final attempt = cubit.login(
      const LoginParamsEntity.google(idToken: 'test'),
    );
    expect(cubit.state.status.isLoading, isTrue);
    await tester.pump(const Duration(seconds: 11));
    await attempt;
    expect(cubit.state.status.isNotLoggedIn, isTrue);
    expect(cubit.state.failure?.message, contains('timeout'));
    expect(login.calls, 0);
    await cubit.close();
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets(
    'iOS Google login skips Android metadata and exposes server failure',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final login = _Login(), device = _Device();
      final cubit = LoginSignInCubit(loginSignIn: login, deviceInfo: device);
      final attempt = cubit.login(
        const LoginParamsEntity.google(idToken: 'test'),
      );
      expect(device.calls, 0);
      expect(login.calls, 1);
      login.pending.complete(Left(ServerFailure(message: 'Akun belum aktif')));
      await attempt;
      expect(cubit.state.status.isNotLoggedIn, isTrue);
      expect(cubit.state.failure?.message, 'Akun belum aktif');
      expect(login.received!.toJson()['input']['provider'], 'google');
      await cubit.close();
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets('leaving login during authentication ignores late result', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final login = _Login();
    final cubit = LoginSignInCubit(loginSignIn: login, deviceInfo: _Device());
    final attempt = cubit.login(
      const LoginParamsEntity.google(idToken: 'test'),
    );
    await cubit.close();
    debugDefaultTargetPlatformOverride = null;
    login.pending.complete(Left(ServerFailure(message: 'Late response')));
    await attempt;
    expect(tester.takeException(), isNull);
  });
}
