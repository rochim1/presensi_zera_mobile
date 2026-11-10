// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/service/_service.dart';

part 'global_post_fcm_state.dart';

class GlobalPostFcmCubit extends Cubit<GlobalPostFcmState> {
  final FirebaseMessaging messaging;
  final LoginCheck loginCheck;
  final GlobalPostTokenFcm postTokenFcm;
  final DeviceInfoPlugin deviceInfo;
  final LocalNotificationService localNotificationService;

  GlobalPostFcmCubit({
    required this.messaging,
    required this.postTokenFcm,
    required this.loginCheck,
    required this.deviceInfo,
    required this.localNotificationService,
  }) : super(const GlobalPostFcmState());

  StreamSubscription<RemoteMessage>? streamMessage;
  StreamSubscription<RemoteMessage>? streamMessageOpenedApp;
  StreamSubscription<String>? _tokenRefresh;
  Future<void> _tokenQueue = Future<void>.value();
  String? _registeredToken;
  String? _registeredUser;
  int _refreshVersion = 0;
  bool _initializing = false;

  Future<void> initialFCM(BuildContext context) async {
    // Web push needs a dedicated Firebase Web app, VAPID key and messaging
    // service worker. Keep the rest of the web app usable until those
    // deployment-specific values are configured.
    if (kIsWeb || isClosed || _initializing) return;
    _initializing = true;
    try {
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        announcement: false,
        criticalAlert: true,
        provisional: false,
      );

      if (isClosed) return;
      emit(state.copyWith(authorizationStatus: settings.authorizationStatus));
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        if (context.mounted) {
          localNotificationService.init(context);
        }
        await _controller(context);
      }
    } catch (error) {
      if (!isClosed) emit(state.copyWith(message: error.toString()));
    } finally {
      _initializing = false;
    }
  }

  Future<void> _controller(BuildContext context) async {
    await _tokenRefresh?.cancel();
    if (isClosed) return;
    _tokenRefresh = messaging.onTokenRefresh.listen(
      (token) {
        _refreshVersion++;
        unawaited(syncToken(token));
      },
      onError: (Object error) {
        if (!isClosed) emit(state.copyWith(message: error.toString()));
      },
    );
    // Receiving/tapping notifications must not depend on a token POST succeeding.
    await _foregroundHandler(context);
    await _openedAppHandler(context);
    await _postToken();
  }

  Future<void> _postToken() async {
    final version = _refreshVersion;
    final token = await messaging.getToken();
    // A refresh observed during getToken is newer than that read's result.
    if (version != _refreshVersion) {
      await _tokenQueue;
      return;
    }
    if (token != null) await syncToken(token);
  }

  /// Register replacements even when the login cache already contains a token.
  /// Serialize refreshes so an older POST cannot overwrite the newest token.
  Future<void> syncToken(String token) {
    if (token.trim().isEmpty || isClosed) return Future<void>.value();
    _tokenQueue = _tokenQueue
        .then((_) async {
          if (isClosed) return;
          final session = await loginCheck.call(NoParams());
          if (isClosed) return;
          await session.fold<Future<void>>(
            (failure) async {
              if (!isClosed) emit(state.copyWith(message: failure.message));
            },
            (user) async {
              if (user == null || user.userId.isEmpty || isClosed) return;
              fl.appId = token;
              emit(state.copyWith(appId: token));
              if (_registeredUser == user.userId && _registeredToken == token)
                return;
              final androidInfo = await deviceInfo.androidInfo;
              if (isClosed) return;
              final result = await postTokenFcm.call(
                GlobalFcmParamsEntity(
                  appsId: token,
                  modelDevice: androidInfo.model,
                  firebaseProjectId: Firebase.apps.isEmpty
                      ? null
                      : Firebase.app().options.projectId,
                ),
              );
              if (isClosed) return;
              result.fold(
                (failure) => emit(state.copyWith(message: failure.message)),
                (_) {
                  _registeredUser = user.userId;
                  _registeredToken = token;
                  emit(state.copyWith(message: ''));
                },
              );
            },
          );
        })
        .catchError((Object error) {
          if (!isClosed) emit(state.copyWith(message: error.toString()));
        });
    return _tokenQueue;
  }

  @pragma('vm:entry-point')
  static Future<void> backgroundHandler(RemoteMessage message) async {
    // A background isolate has no UI dependency locator/flavor instance.
    await Firebase.initializeApp();
  }

  Future<void> _foregroundHandler(BuildContext context) async {
    await streamMessage?.cancel();
    if (isClosed) return;
    streamMessage = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final typeNotif = (message.data['type_notif'] as String?);

      //! Got a message whilst in the foreground!
      emit(
        state.copyWith(
          authorizationStatus: AuthorizationStatus.authorized,
          notificationState: NotificationState.onMessage,
          notificationType: typeNotif?.toNotification,
          dataMessage: message.data,
        ),
      );

      if (message.notification != null) {
        //! handle local notification

        //! Message also contained a notification: `message.notification`
        emit(state.copyWith(notification: message.notification));
        Debounce.debounce(kDebNotif, const Duration(milliseconds: 800), () {
          if (!isClosed && context.mounted) {
            _redirectMessage(context, message.notification);
            localNotificationService.showNotification(message);
          }
        });
      }
    });
  }

  Future<void> _openedAppHandler(BuildContext context) async {
    await streamMessageOpenedApp?.cancel();
    if (isClosed) return;
    void opened(RemoteMessage message) {
      if (isClosed) return;
      final typeNotif =
          (message.data['type_notif'] as String?)?.toNotification!;

      emit(
        state.copyWith(
          authorizationStatus: AuthorizationStatus.authorized,
          notificationState: NotificationState.onMessageOpenedApp,
          notificationType: typeNotif,
          dataMessage: message.data,
          notification: message.notification,
        ),
      );

      if (message.notification != null) {
        //! Message also contained a notification: `message.notification`
        emit(state.copyWith(notification: message.notification));
        Debounce.debounce(kDebNotif, const Duration(milliseconds: 800), () {
          if (!isClosed && context.mounted)
            _redirectMessage(context, message.notification);
        });
      }
    }

    streamMessageOpenedApp = FirebaseMessaging.onMessageOpenedApp.listen(
      opened,
    );
    try {
      final initial = await messaging.getInitialMessage();
      if (!isClosed && context.mounted && initial != null) opened(initial);
    } catch (error) {
      if (!isClosed) emit(state.copyWith(message: error.toString()));
    }
  }

  void _redirectMessage(
    BuildContext context,
    RemoteNotification? notification,
  ) {
    if (state.notificationState.onMessageOpenedApp) {
      AppUtility.routeNotification(context, state.notificationType);
    }
  }

  @override
  Future<void> close() async {
    await super.close();
    await Future.wait([
      if (streamMessage != null) streamMessage!.cancel(),
      if (streamMessageOpenedApp != null) streamMessageOpenedApp!.cancel(),
      if (_tokenRefresh != null) _tokenRefresh!.cancel(),
    ]);
  }
}
