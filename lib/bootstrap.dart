import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
import 'package:presensi_mobile/service/startup_gate.dart';
import 'package:presensi_mobile/service/startup_metrics.dart';
import 'package:presensi_mobile/service/development_endpoint.dart';
import 'package:presensi_mobile/service/cached_api_session.dart';

Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  required FlavorConfig flavor,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  StartupMetrics.begin();
  runApp(StartupGate(initialize: () => _initialize(builder, flavor: flavor)));
}

Future<Widget> _initialize(
  FutureOr<Widget> Function() builder, {
  required FlavorConfig flavor,
}) async {
  final startup = Stopwatch()..start();

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
    // Native services all use [DEFAULT], supplied by google-services/plist.
    // Creating an additional named app initializes unused Firebase components.
    await Firebase.initializeApp();
  }

  StartupMetrics.mark('firebase_ready');

  await restoreDevelopmentEndpoint(flavor);

  //! Init injection locator
  initLocator(flavor);
  StartupMetrics.mark('dependencies_registered');

  //! An interface for observing the behavior of [Bloc] instances.
  Bloc.observer = AppBlocObserver(flavor);

  //! Initializing Hive
  await Hive.initFlutter();

  //! Register Hive
  HiveAdapterService.init();
  await restoreCachedApiSession(flavor);
  StartupMetrics.mark('storage_ready');

  // Android 15+ mewajibkan edge-to-edge dan Android 16 mengabaikan
  // pembatasan orientasi pada layar besar. Scaffold/SafeArea menangani inset.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  //! Enables/disables automatic data collection by Crashlytics.
  if (!kIsWeb) {
    await Future.wait([
      fa.setAnalyticsCollectionEnabled(!kDebugMode),
      fs.setCrashlyticsCollectionEnabled(!kDebugMode && fl.env!.isProd),
    ]);
  }

  //! Set the background messaging handler early on, as a named top-level function
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(GlobalPostFcmCubit.backgroundHandler);
  }

  // Maps initializes when a map is opened (the SDK defaults to its latest
  // renderer). Loading it here blocks Android's platform thread even on login.
  // Tracking is configured lazily by BackgroundLocationService.start().
  final app = await builder();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Hive and its adapters are ready before any queue work can start.
    sl<SyncService>().init();
    debugPrint('[Startup] app ready in ${startup.elapsedMilliseconds}ms');
  });

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

  // dart:isolate is unavailable in browsers. Web errors are handled above
  // by PlatformDispatcher and FlutterError.
  if (!kIsWeb) {
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

  return app;
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
