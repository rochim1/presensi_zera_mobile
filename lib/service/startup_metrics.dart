import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Opt-in QA timings. No account identifiers, tokens or business data logged.
class StartupMetrics {
  static const enabled = bool.fromEnvironment('HRMS_STARTUP_METRICS');
  static final _clock = Stopwatch();
  static bool _homeReported = false;

  static void begin() {
    if (!enabled) return;
    _clock.start();
    mark('dart_bootstrap');
  }

  static void mark(String phase) {
    if (enabled)
      debugPrint(
        '[ZeraStartup] $phase elapsed_ms=${_clock.elapsedMilliseconds}',
      );
  }

  static Future<void> homeReady() async {
    if (!enabled || _homeReported) return;
    _homeReported = true;
    mark('home_ready');
    if (kIsWeb) return;
    try {
      await const MethodChannel(
        'com.pantoo.presensi/startup',
      ).invokeMethod<void>('homeReady');
    } on MissingPluginException {
      // Other platforms still expose Dart timings without Android's clock.
    } on PlatformException catch (error) {
      debugPrint('[ZeraStartup] timing unavailable: ${error.code}');
    }
  }
}
