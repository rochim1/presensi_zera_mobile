import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/global/global_post_fcm_cubit/global_post_fcm_cubit.dart';
import 'package:presensi_mobile/service/local_notification_service.dart';

class _Check extends Fake implements LoginCheck {
  LoginUserEntity? user = const LoginUserEntity(
    userId: 'one',
    appId: 'old-token',
  );
  @override
  Future<Either<Failure, LoginUserEntity?>> call(NoParams params) async =>
      Right(user);
}

class _Post extends Fake implements GlobalPostTokenFcm {
  final tokens = <String>[];
  bool fail = false;
  Completer<void>? hold;
  @override
  Future<Either<Failure, String?>> call(GlobalFcmParamsEntity params) async {
    tokens.add(params.appsId);
    await hold?.future;
    return fail ? Left(CacheFailure()) : Right(params.appsId);
  }
}

class _Android extends Fake implements AndroidDeviceInfo {
  @override
  String get model => 'Test phone';
}

class _Device extends Fake implements DeviceInfoPlugin {
  @override
  Future<AndroidDeviceInfo> get androidInfo async => _Android();
}

class _Settings extends Fake implements NotificationSettings {
  _Settings(this.status);
  final AuthorizationStatus status;
  @override
  AuthorizationStatus get authorizationStatus => status;
}

class _Messaging extends Fake implements FirebaseMessaging {
  AuthorizationStatus status = AuthorizationStatus.denied;
  final refresh = StreamController<String>.broadcast();
  Completer<String?>? pendingToken;
  RemoteMessage? initial;
  @override
  Stream<String> get onTokenRefresh => refresh.stream;
  @override
  Future<String?> getToken({
    String? vapidKey,
    String? serviceWorkerScriptPath,
  }) async =>
      pendingToken == null ? 'initial-token' : await pendingToken!.future;
  @override
  Future<RemoteMessage?> getInitialMessage() async => initial;
  @override
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
    bool providesAppNotificationSettings = false,
  }) async => _Settings(status);
}

class _Local extends Fake implements LocalNotificationService {
  @override
  void init(BuildContext context) {}
}

void main() {
  test(
    'registration includes the Firebase project for backend sender routing',
    () {
      const params = GlobalFcmParamsEntity(
        appsId: 'token',
        firebaseProjectId: 'pantoo-511802',
      );
      expect(
        (params.toJson()['input'] as Map)['firebase_project_id'],
        'pantoo-511802',
      );
      expect(
        const GlobalFcmParamsEntity(appsId: 'legacy').toJson()['input'],
        isNot(contains('firebase_project_id')),
      );
    },
  );
  late _Check check;
  late _Post post;
  late _Messaging messaging;
  late GlobalPostFcmCubit cubit;
  setUpAll(() {
    sl.registerSingleton<FlavorConfig>(
      FlavorConfig.init(env: Env.DEVELOPMENT, values: null),
    );
  });
  setUp(() {
    check = _Check();
    post = _Post();
    messaging = _Messaging();
    cubit = GlobalPostFcmCubit(
      messaging: messaging,
      loginCheck: check,
      postTokenFcm: post,
      deviceInfo: _Device(),
      localNotificationService: _Local(),
    );
  });
  tearDown(() async {
    if (!cubit.isClosed) await cubit.close();
    await messaging.refresh.close();
  });

  test(
    'replaces a nonempty cached token and accepts subsequent refresh',
    () async {
      await cubit.syncToken('new-project-token');
      await cubit.syncToken('refreshed-token');
      expect(post.tokens, ['new-project-token', 'refreshed-token']);
      expect(cubit.state.appId, 'refreshed-token');
    },
  );

  test('deduplicates successful registration for the same user only', () async {
    await cubit.syncToken('token');
    await cubit.syncToken('token');
    check.user = const LoginUserEntity(userId: 'two', appId: 'token');
    await cubit.syncToken('token');
    expect(post.tokens, ['token', 'token']);
  });

  test('serializes token writes so the newest registration wins', () async {
    post.hold = Completer<void>();
    final first = cubit.syncToken('first');
    final second = cubit.syncToken('latest');
    await Future<void>.delayed(Duration.zero);
    expect(post.tokens, ['first']);
    post.hold!.complete();
    await Future.wait([first, second]);
    expect(post.tokens, ['first', 'latest']);
    expect(cubit.state.appId, 'latest');
  });

  test('failed registration can be retried', () async {
    post.fail = true;
    await cubit.syncToken('token');
    post.fail = false;
    await cubit.syncToken('token');
    expect(post.tokens, ['token', 'token']);
    expect(cubit.state.message, '');
  });

  test('skips empty tokens and logged out sessions', () async {
    await cubit.syncToken(' ');
    check.user = null;
    await cubit.syncToken('token');
    expect(post.tokens, isEmpty);
  });

  test(
    'closing before initialization is safe and skips later registration',
    () async {
      await cubit.close();
      await cubit.syncToken('token');
      expect(post.tokens, isEmpty);
    },
  );

  testWidgets('denied permission can close without initialized subscriptions', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      ),
    );
    await cubit.initialFCM(context);
    expect(cubit.state.authorizationStatus, AuthorizationStatus.denied);
    await cubit.close();
    expect(post.tokens, isEmpty);
  });

  testWidgets('refresh stream registers replacement and handles cold start', (
    tester,
  ) async {
    messaging.status = AuthorizationStatus.authorized;
    messaging.initial = const RemoteMessage(data: {'source': 'cold-start'});
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.runAsync(() => cubit.initialFCM(context));
    expect(cubit.state.dataMessage, {'source': 'cold-start'});
    await tester.runAsync(() async {
      messaging.refresh.add('replacement');
      await Future<void>.delayed(Duration.zero);
    });
    expect(post.tokens, ['initial-token', 'replacement']);
    await tester.runAsync(() => cubit.close());
  });

  testWidgets('refresh during initial token read wins over its stale result', (
    tester,
  ) async {
    messaging.status = AuthorizationStatus.provisional;
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.runAsync(() async {
      messaging.pendingToken = Completer<String?>();
      final initializing = cubit.initialFCM(context);
      await Future<void>.delayed(Duration.zero);
      messaging.refresh.add('fresh-token');
      await Future<void>.delayed(Duration.zero);
      messaging.pendingToken!.complete('stale-token');
      await initializing;
    });
    expect(post.tokens, ['fresh-token']);
    await tester.runAsync(() => cubit.close());
  });
}
