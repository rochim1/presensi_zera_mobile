// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
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

  late StreamSubscription<RemoteMessage> streamMessage;
  late StreamSubscription<RemoteMessage> streamMessageOpenedApp;

  Future<void> initialFCM(BuildContext context) async {
    // Web push needs a dedicated Firebase Web app, VAPID key and messaging
    // service worker. Keep the rest of the web app usable until those
    // deployment-specific values are configured.
    if (kIsWeb) return;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: false,
      announcement: false,
      criticalAlert: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _controller(context);
      localNotificationService.init(context);
    } else {
      emit(state.copyWith(authorizationStatus: settings.authorizationStatus));
    }
  }

  Future<void> _controller(BuildContext context) async {
    //! get token and save to server
    await _postToken();

    //! Also handle any interaction when the app is in the background via a Stream listener
    await _openedAppHandler(context);

    //! To listen to messages whilst your application is in the foreground, listen to the onMessage stream.
    await _foregroundHandler(context);
  }

  Future<void> _postToken() async {
    //! get token app_id for this device
    final token = await messaging.getToken();

    //! get device information
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    emit(
      state.copyWith(
        appId: token,
        authorizationStatus: AuthorizationStatus.authorized,
      ),
    );

    //! save appId/token to local for received on header graphql
    fl.appId = token;

    //! token save to server
    final user = await loginCheck.call(NoParams());

    user.fold((failure) {}, (value) async {
      if (value?.appId == null && value?.appId != token) {
        final params = GlobalFcmParamsEntity(
          appsId: token ?? '',
          modelDevice: androidInfo.model,
        );

        final Either<Failure, String?> data = await postTokenFcm.call(params);

        data.fold(
          (failure) => emit(state.copyWith(message: failure.message)),
          (value) {},
        );
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<void> backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(name: kAppName, options: fl.values!.options);
  }

  Future<void> _foregroundHandler(BuildContext context) async {
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
          _redirectMessage(context, message.notification);
          localNotificationService.showNotification(message);
        });
      }
    });
  }

  Future<void> _openedAppHandler(BuildContext context) async {
    streamMessageOpenedApp = FirebaseMessaging.onMessageOpenedApp.listen((
      message,
    ) {
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
          _redirectMessage(context, message.notification);
        });
      }
    });
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
  Future<void> close() {
    if (!kIsWeb) {
      streamMessage.cancel();
      streamMessageOpenedApp.cancel();
    }
    return super.close();
  }
}
