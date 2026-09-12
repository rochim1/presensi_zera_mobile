import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/config/flavor_config.dart';
import 'package:presensi_mobile/core/_core.dart';

class RemoteConfigService with KeysConstant {
  final FirebaseRemoteConfig remoteConfig;
  final FlavorConfig flavorConfig;
  final Logger log;

  RemoteConfigService({
    required this.flavorConfig,
    required this.remoteConfig,
    required this.log,
  });

  /// Set config for RemoteConfig
  Future<void> setConfigSettings() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: flavorConfig.values!.delay!,
      ),
    );

    //! Setup default dat value
    await _setDefaults();

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetchAndActivate();
    } on FirebaseException catch (e, s) {
      log.w(e.message, stackTrace: s);
    }
  }

  /// Setup default data value
  Future<void> _setDefaults() async =>
      remoteConfig.setDefaults({faceDetector: true});

  //! Add new Key on line below. Dont forget set default value on `setDefaults()`
  /// Get status of feature Face Detector on Camera
  bool get getFaceDetector => remoteConfig.getBool(faceDetector) && !kDebugMode;
}
