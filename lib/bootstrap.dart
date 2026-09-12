import 'dart:io';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:logger/logger.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'core/_core.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/service/_service.dart';
import 'package:presensi_mobile/service/background_location_service.dart';

Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  required FlavorConfig flavor,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    final response = AppUtility.errorIgnore(error.toString());
    if (!response) return true;

    if (!kIsWeb && !kDebugMode) {
      fs.recordError(error, stackTrace, fatal: fl.env!.isProd);
    }
    log.f(error.toString(), stackTrace: stackTrace);
    return true;
  };

  //! Firebase Init
  // Native Firebase is also initialized by the platform configuration, while
  // web has no implicit default app. Services such as Analytics, Messaging,
  // Crashlytics and Remote Config below use their `.instance` getter, which
  // requires `[DEFAULT]` to exist in the browser.
  if (kIsWeb) {
    await Firebase.initializeApp(options: flavor.values!.options);
  } else {
    await Firebase.initializeApp(
      name: kAppName,
      options: flavor.values!.options,
    );
  }

  //! Init injection locator
  initLocator(flavor);

  //! An interface for observing the behavior of [Bloc] instances.
  Bloc.observer = AppBlocObserver(flavor);

  //! Initializing Hive
  await Hive.initFlutter();

  //! Register Hive
  HiveAdapterService.init();

  // Background services are a native capability. On web they would either
  // fail at runtime or suggest a level of tracking that browsers cannot keep
  // alive once the tab is suspended.
  if (!kIsWeb) {
    await BackgroundLocationService.initialize();
  }

  //! Initialize SyncService for offline order queue
  sl<SyncService>().init();

  // Android 15+ mewajibkan edge-to-edge dan Android 16 mengabaikan
  // pembatasan orientasi pada layar besar. Scaffold/SafeArea menangani inset.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  //! Enables/disables automatic data collection by Crashlytics.
  if (!kIsWeb) {
    await fa.setAnalyticsCollectionEnabled(!kDebugMode);
    await fs.setCrashlyticsCollectionEnabled(!kDebugMode && fl.env!.isProd);
  }

  //! Set the background messaging handler early on, as a named top-level function
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(GlobalPostFcmCubit.backgroundHandler);
  }

  //! ZERA-6 handle issue close app when initial map view
  if (!kIsWeb && Platform.isAndroid) {
    try {
      await GoogleMapsFlutterAndroid().initializeWithRenderer(
        AndroidMapRenderer.latest,
      );
    } catch (_) {
      // Ignore exception. This typically happens during Hot Restart because
      // the native Android renderer persists while the Dart isolate restarts.
    }
  }

  //! run app
  runApp(await builder());

  Logger.addLogListener((event) {
    if (event.level == Level.error ||
        event.level == Level.warning ||
        event.level == Level.fatal) {
      final response = AppUtility.errorIgnore(event.message);
      if (!response) return;

      if (!kIsWeb && !kDebugMode) {
        fs.recordError(
          '${event.message}\n${event.error}',
          event.stackTrace,
          fatal: event.level == Level.error || event.level == Level.fatal,
        );
      }
    }
  });

  FlutterError.onError = (details) {
    final response = AppUtility.errorIgnore(details.toString());
    if (!response) return;

    if (!kIsWeb && !kDebugMode) {
      fs.recordFlutterError(details, fatal: fl.env!.isProd);
    }
    if (flavor.values!.printResponse!) {
      log.e(details.toString(), stackTrace: details.stack);
    }
  };

  Isolate.current.addErrorListener(
    RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;

      final response = AppUtility.errorIgnore(
        errorAndStacktrace.first.toString(),
      );
      if (!response) return;

      if (!kIsWeb && !kDebugMode) {
        await fs.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
          fatal: fl.env!.isProd,
        );
      }
    }).sendPort,
  );
}

class AppBlocObserver extends BlocObserver {
  final FlavorConfig flavor;

  AppBlocObserver(this.flavor);

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (flavor.values!.printResponse!) {
      log.i(
        'onChange(\n${bloc.runtimeType}, \n${change.currentState.toString()})',
      );
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log.t('$error', stackTrace: stackTrace);
  }
}
