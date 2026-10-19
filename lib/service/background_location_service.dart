import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:presensi_mobile/service/location_disclosure_service.dart';

/// Menjalankan live tracking hanya selama sesi kerja aktif.
/// Izin selalu diminta dari UI, sesudah pengungkapan yang jelas kepada pengguna.
class BackgroundLocationService {
  static const _channelId = 'pantoo_live_tracking';
  static const _notificationId = 8888;
  static final _service = FlutterBackgroundService();

  static Future<void>? _initialization;

  // Concurrent session refreshes must not configure/start duplicate engines.
  // A failed configuration can be retried without touching stored attendance.
  static Future<void> initialize() => kIsWeb
      ? Future<void>.value()
      : _initialization ??= _configure().catchError((
          Object error,
          StackTrace stack,
        ) {
          _initialization = null;
          Error.throwWithStackTrace(error, stack);
        });

  static Future<void> _configure() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      'Live tracking Pantoo',
      description: 'Ditampilkan saat pelacakan lokasi sesi kerja aktif.',
      importance: Importance.low,
    );
    final notifications = FlutterLocalNotificationsPlugin();
    await notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
        autoStart: false,
        autoStartOnBoot: false,
        isForegroundMode: true,
        notificationChannelId: _channelId,
        initialNotificationTitle: 'Pantoo - Sesi kerja aktif',
        initialNotificationContent:
            'Live tracking siap digunakan selama sesi kerja.',
        foregroundServiceNotificationId: _notificationId,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: _onStart,
      ),
    );
  }

  /// Dipanggil dari UI tepat setelah pengguna menyetujui pengungkapan.
  static Future<bool> ensureTrackingPermission() async {
    if (kIsWeb) return false;
    if (!await LocationDisclosureService.ensureAccepted()) return false;

    final location = Location();
    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
    }
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.grantedLimited) {
      return false;
    }

    try {
      await location.enableBackgroundMode(enable: true);
      return true;
    } catch (error) {
      debugPrint('Unable to enable background location: $error');
      return false;
    }
  }

  static Future<void> start({
    required String baseUrl,
    required String token,
  }) async {
    if (kIsWeb) return;
    await initialize();
    final box = await Hive.openBox('background_tracking');
    await box.put('token', token);
    await box.put('baseUrl', baseUrl);
    if (!await _service.isRunning()) {
      await _service.startService();
    } else {
      _service.invoke('reconnect');
    }
  }

  static Future<void> stop() async {
    if (kIsWeb) return;
    if (await _service.isRunning()) _service.invoke('stop');
    final box = await Hive.openBox('background_tracking');
    await box.clear();
    await box.close();
  }
}

@pragma('vm:entry-point')
Future<void> _onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox('background_tracking');
  String? token = box.get('token') as String?;
  String? baseUrl = box.get('baseUrl') as String?;
  if (token == null || token.isEmpty || baseUrl == null || baseUrl.isEmpty) {
    if (service is AndroidServiceInstance) service.stopSelf();
    return;
  }

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: 'Pantoo - Sesi kerja aktif',
      content: 'Live tracking siap digunakan selama sesi kerja.',
    );
  }

  // The location plugin's hasPermission requires an Activity. This isolate
  // has only a Service; check existing permission without opening UI here.
  try {
    final permission = await geo.Geolocator.checkPermission();
    if (permission != geo.LocationPermission.always &&
        permission != geo.LocationPermission.whileInUse) {
      await box.close();
      service.stopSelf();
      return;
    }
  } catch (error) {
    debugPrint('Unable to initialize background location: $error');
    await box.close();
    service.stopSelf();
    return;
  }

  WebSocketChannel? socket;
  StreamSubscription<geo.Position>? locationSubscription;
  Timer? retryTimer;
  Timer? pingTimer;
  bool authenticated = false;
  bool tracking = false;
  bool terminated = false;

  void stopTracking() {
    tracking = false;
    locationSubscription?.cancel();
    locationSubscription = null;
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'Pantoo - Sesi kerja aktif',
        content: 'Live tracking siap digunakan selama sesi kerja.',
      );
    }
  }

  void startHeartbeat() {
    pingTimer?.cancel();
    pingTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      if (authenticated && socket != null) {
        socket!.sink.add(jsonEncode({'type': 'ping'}));
      }
    });
  }

  void startTracking() {
    if (tracking || !authenticated) return;
    tracking = true;
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'Pantoo - Pelacakan aktif',
        content: 'Lokasi dibagikan ke admin HR selama sesi kerja.',
      );
    }
    locationSubscription =
        geo.Geolocator.getPositionStream(
          locationSettings: defaultTargetPlatform == TargetPlatform.android
              ? geo.AndroidSettings(
                  accuracy: geo.LocationAccuracy.high,
                  distanceFilter: 0,
                  intervalDuration: const Duration(seconds: 15),
                )
              : const geo.LocationSettings(
                  accuracy: geo.LocationAccuracy.high,
                  distanceFilter: 0,
                ),
        ).listen(
          (data) {
            if (!authenticated || socket == null) {
              return;
            }
            socket!.sink.add(
              jsonEncode({
                'type': 'live_location',
                'data': {
                  'latitude': data.latitude,
                  'longitude': data.longitude,
                  'timestamp': DateTime.now().toIso8601String(),
                },
              }),
            );
          },
          onError: (Object error) {
            debugPrint('Background location update failed: $error');
            stopTracking();
          },
        );
  }

  late void Function() connect;
  connect = () {
    retryTimer?.cancel();
    final normalized = baseUrl!
        .replaceAll(RegExp(r'/graphql/?$'), '')
        .replaceFirst(RegExp(r'^http'), 'ws');
    socket = WebSocketChannel.connect(Uri.parse('$normalized/notifications'));
    socket!.stream.listen(
      (message) {
        try {
          final payload = jsonDecode(message as String) as Map<String, dynamic>;
          switch (payload['type']) {
            case 'connection':
              socket?.sink.add(
                jsonEncode({
                  'type': 'auth',
                  'token': token,
                  'client_type': 'mobile_tracker',
                }),
              );
              break;
            case 'auth_success':
              authenticated = true;
              startHeartbeat();
              break;
            case 'start_tracking':
              startTracking();
              break;
            case 'stop_tracking':
              stopTracking();
              break;
            case 'tracking_session_ended':
              terminated = true;
              retryTimer?.cancel();
              stopTracking();
              socket?.sink.close(ws_status.normalClosure);
              if (service is AndroidServiceInstance) {
                service.stopSelf();
              }
              break;
          }
        } catch (_) {}
      },
      onDone: () {
        authenticated = false;
        pingTimer?.cancel();
        stopTracking();
        if (!terminated) {
          retryTimer = Timer(const Duration(seconds: 10), connect);
        }
      },
      onError: (_) {
        authenticated = false;
        pingTimer?.cancel();
        stopTracking();
        if (!terminated) {
          retryTimer = Timer(const Duration(seconds: 10), connect);
        }
      },
    );
  };

  service.on('stop').listen((_) {
    terminated = true;
    retryTimer?.cancel();
    pingTimer?.cancel();
    stopTracking();
    socket?.sink.close(ws_status.normalClosure);
    if (service is AndroidServiceInstance) {
      service.stopSelf();
    }
  });
  service.on('reconnect').listen((_) async {
    terminated = false;
    token = box.get('token') as String?;
    baseUrl = box.get('baseUrl') as String?;
    if (token != null &&
        token!.isNotEmpty &&
        baseUrl != null &&
        baseUrl!.isNotEmpty) {
      connect();
    }
  });
  connect();
}
