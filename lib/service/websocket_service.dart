import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/service/local_notification_service.dart';

/// WebSocketService — Singleton for employee/user real-time connectivity.
///
/// Fitur:
/// - Online status tracking (admin tahu siapa yang sedang online)
/// - On-demand live location tracking (kirim lokasi HANYA saat admin minta)
/// - Real-time notifications via WebSocket
/// - Auto-reconnect & ping keep-alive
///
/// Cara pakai:
/// ```dart
/// // Setelah login berhasil:
/// final ws = WebSocketService.instance;
/// await ws.connect(baseUrl: 'http://...', token: 'JWT_TOKEN');
///
/// // Set location callback (agar bisa kirim lokasi saat diminta):
/// ws.onGetCurrentLocation = () async {
///   final loc = await locService.getCurrentLocation();
///   return {'latitude': loc.lat, 'longitude': loc.long};
/// };
///
/// // Set working status check (agar hanya kirim jika sedang kerja):
/// ws.onCheckIsWorking = () async => true; // or check presensi status
///
/// // Tracking akan dimulai/dihentikan otomatis oleh server (admin-driven).
///
/// // Saat logout:
/// ws.disconnect();
/// ```
class WebSocketService {
  // ── Singleton ──────────────────────────────────────
  WebSocketService._internal();
  static final WebSocketService instance = WebSocketService._internal();
  factory WebSocketService() => instance;

  // ── State ──────────────────────────────────────────
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  Timer? _locationTimer;
  bool _isConnected = false;
  bool _isAuthenticated = false;
  bool _intentionalDisconnect = false;
  bool _isLiveTracking = false;
  bool _isGettingLocation = false;
  String? _baseUrl;
  String? _token;

  bool get isConnected => _isConnected;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLiveTracking => _isLiveTracking;

  // ── Event Listeners ────────────────────────────────
  final List<void Function(Map<String, dynamic>)> _messageListeners = [];

  /// Listener untuk notifikasi real-time (badge, popup, dll.)
  final List<void Function(Map<String, dynamic>)> _notificationListeners = [];

  void addMessageListener(void Function(Map<String, dynamic>) listener) {
    _messageListeners.add(listener);
  }

  void removeMessageListener(void Function(Map<String, dynamic>) listener) {
    _messageListeners.remove(listener);
  }

  /// Register listener untuk notifikasi (type: 'notification')
  void addNotificationListener(void Function(Map<String, dynamic>) listener) {
    _notificationListeners.add(listener);
  }

  void removeNotificationListener(
    void Function(Map<String, dynamic>) listener,
  ) {
    _notificationListeners.remove(listener);
  }

  void _notifyListeners(Map<String, dynamic> message) {
    for (final listener in List.of(_messageListeners)) {
      try {
        listener(message);
      } catch (e) {
        debugPrint('[WS] Listener error: $e');
      }
    }
  }

  void _notifyNotificationListeners(Map<String, dynamic> data) {
    for (final listener in List.of(_notificationListeners)) {
      try {
        listener(data);
      } catch (e) {
        debugPrint('[WS] Notification listener error: $e');
      }
    }
  }

  // ── Callbacks ──────────────────────────────────────
  /// Callback untuk mendapatkan lokasi terkini (diset oleh LocationService)
  Future<Map<String, double>> Function()? onGetCurrentLocation;

  /// Callback untuk cek apakah user sedang dalam status kerja (sudah check-in, belum check-out)
  /// Return true = sedang kerja, false = tidak sedang kerja
  Future<bool> Function()? onCheckIsWorking;

  // ── Connect ────────────────────────────────────────
  /// Connect to WebSocket and authenticate as user/karyawan.
  /// [baseUrl]  : e.g. "http://192.168.1.10:3002" or "https://api.pantoo.id"
  /// [token]    : JWT access token from login response
  Future<void> connect({required String baseUrl, required String token}) async {
    if (_isConnected) {
      debugPrint('[WS] Already connected, skipping...');
      return;
    }

    _baseUrl = baseUrl;
    _token = token;
    _intentionalDisconnect = false;

    final wsUrl = _buildWsUrl(baseUrl);
    debugPrint('[WS] Connecting to $wsUrl');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _isConnected = true;

      _subscription = _channel!.stream.listen(
        (message) => _handleMessage(message, token),
        onError: (error) {
          debugPrint('[WS] Stream error: $error');
          _onDisconnected();
        },
        onDone: () {
          debugPrint('[WS] Connection closed');
          _onDisconnected();
        },
      );

      debugPrint('[WS] Connected to WebSocket');
    } catch (e) {
      debugPrint('[WS] Connection failed: $e');
      _isConnected = false;
      _scheduleReconnect();
    }
  }

  // ── Disconnect ─────────────────────────────────────
  void disconnect() {
    _intentionalDisconnect = true;
    stopLiveTracking();
    _cleanUp();
    debugPrint('[WS] Disconnected intentionally');
  }

  void _cleanUp() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    try {
      _channel?.sink.close(status.normalClosure);
    } catch (_) {}
    _channel = null;
    _isConnected = false;
    _isAuthenticated = false;
  }

  void _onDisconnected() {
    _isConnected = false;
    _isAuthenticated = false;
    _pingTimer?.cancel();
    if (!_intentionalDisconnect && _token != null) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!_intentionalDisconnect && _baseUrl != null && _token != null) {
        connect(baseUrl: _baseUrl!, token: _token!);
      }
    });
  }

  // ── Send ───────────────────────────────────────────
  void _send(Map<String, dynamic> data) {
    if (_channel != null && _isConnected) {
      try {
        final encoded = jsonEncode(data);
        _channel!.sink.add(encoded);
        debugPrint('[WS] Sent: ${data['type']}');
      } catch (e) {
        debugPrint('[WS] Send error: $e');
      }
    } else {
      debugPrint(
        '[WS] Cannot send (channel=${_channel != null}, connected=$_isConnected): ${data['type']}',
      );
    }
  }

  // ── Handle Messages ────────────────────────────────
  void _handleMessage(dynamic raw, String token) {
    try {
      final message = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = message['type'] as String?;
      debugPrint('[WS] Received: $type');

      switch (type) {
        case 'connection':
          // Server welcome → kirim auth
          _send({'type': 'auth', 'token': token, 'client_type': 'mobile'});
          break;

        case 'auth_success':
          _isAuthenticated = true;
          debugPrint('[WS] Authenticated as user/karyawan ✅');
          _startPing();
          break;

        case 'auth_error':
          _isAuthenticated = false;
          final reason = message['reason'];
          debugPrint('[WS] Auth error: $reason');
          if (reason == 'token_expired') {
            // Attempt to reconnect with a fresh token
            debugPrint('[WS] Token expired, attempting reconnect...');
            disconnect();
            if (_baseUrl != null && _token != null) {
              Future.delayed(const Duration(seconds: 2), () {
                connect(baseUrl: _baseUrl!, token: _token!);
              });
            }
          } else {
            disconnect();
          }
          break;

        case 'pong':
          break;

        case 'tracking_session_ended':
          stopLiveTracking();
          debugPrint(
            '[WS] Tracking dihentikan server karena sesi kerja berakhir',
          );
          break;

        // ══════════════════════════════════════════════
        // REAL-TIME NOTIFICATIONS
        // ══════════════════════════════════════════════
        case 'notification':
          final data = message['data'] as Map<String, dynamic>?;
          if (data != null) {
            debugPrint(
              '[WS] Notification received: ${data['title'] ?? data['_id']}',
            );
            // Notify UI listeners (e.g. badges, list refresh)
            _notifyNotificationListeners(data);

            // Skip showing local push notification for silent system events
            final innerType = data['type']?.toString();
            if (innerType == 'notification_read' || innerType == 'email_sent') {
              break;
            }

            // We do NOT call showLocalNotification here because FCM (Firebase Messaging)
            // already triggers a local notification in the foreground via global_post_fcm_cubit.
            // Calling it here causes double notifications.
            /*
            try {
              final title = data['title'] ?? 'Notifikasi Baru';
              final body = data['body'] ?? data['content'] ?? 'Anda menerima notifikasi baru.';
              final idStr = data['_id'] ?? data['id'];
              final rawId = idStr != null ? idStr.hashCode : DateTime.now().millisecondsSinceEpoch;
              final id = rawId.abs() % 2147483647; // Ensure fits in 32-bit integer
              
              sl<LocalNotificationService>().showLocalNotification(
                id: id,
                title: title.toString(),
                body: body.toString(),
                payload: jsonEncode(data),
              );
            } catch (e) {
              debugPrint('[WS] Failed to show local notification: $e');
            }
            */
          }
          break;

        // ══════════════════════════════════════════════
        // REAL-TIME CHAT MESSAGES
        // ══════════════════════════════════════════════
        case 'chat_message':
          final data = message['data'] as Map<String, dynamic>?;
          if (data != null) {
            debugPrint(
              '[WS] Chat message received for conversation: ${data['conversation_id']}',
            );

            // Build notification-like data so listeners can react
            final msgData = data['message'] as Map<String, dynamic>? ?? {};
            final senderData = msgData['sender'] as Map<String, dynamic>? ?? {};
            final senderName = senderData['name'] ?? 'Pesan Baru';
            final content = msgData['content'] ?? 'Anda menerima pesan baru';
            final conversationId = data['conversation_id'] ?? '';

            // Notify notification listeners (for HomeCubit badge + ChatRoomCubit refresh)
            _notifyNotificationListeners({
              'title': 'Pesan dari $senderName',
              'body': content,
              'conversation_id': conversationId,
              'type': 'chat_message',
              ...data,
            });

            // Also notify message listeners
            _notifyListeners(message);

            // Show local push notification with sound
            try {
              final rawId =
                  conversationId.hashCode ^
                  DateTime.now().millisecondsSinceEpoch;
              final id = rawId.abs() % 2147483647;

              sl<LocalNotificationService>().showLocalNotification(
                id: id,
                title: senderName.toString(),
                body: content.toString(),
                payload: jsonEncode({
                  'type': 'chat',
                  'conversation_id': conversationId,
                }),
              );
            } catch (e) {
              debugPrint('[WS] Failed to show chat notification: $e');
            }
          }
          break;

        // ══════════════════════════════════════════════
        // ON-DEMAND LIVE TRACKING (admin-driven)
        // ══════════════════════════════════════════════
        case 'start_tracking':
          debugPrint('[WS] Admin requested live tracking — starting...');
          _handleStartTracking();
          break;

        case 'stop_tracking':
          debugPrint('[WS] Admin stopped live tracking — stopping...');
          stopLiveTracking();
          break;

        default:
          break;
      }

      _notifyListeners(message);
    } catch (e) {
      debugPrint('[WS] Parse error: $e');
    }
  }

  // ── Ping / Keep-alive ──────────────────────────────
  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _send({'type': 'ping'});
    });
  }

  // ═══════════════════════════════════════════════════
  // ON-DEMAND LIVE LOCATION TRACKING
  // ═══════════════════════════════════════════════════

  /// Dipanggil otomatis ketika server mengirim 'start_tracking'.
  /// Akan cek apakah user sedang kerja sebelum mulai kirim lokasi.
  Future<void> _handleStartTracking() async {
    // Cek apakah user sedang kerja (sudah check-in, belum check-out)
    if (onCheckIsWorking != null) {
      try {
        final isWorking = await onCheckIsWorking!();
        if (!isWorking) {
          debugPrint('[WS] User not working, ignoring start_tracking');
          return;
        }
      } catch (e) {
        debugPrint('[WS] Error checking work status: $e');
        return;
      }
    }

    startLiveTracking(intervalSeconds: 10);
  }

  /// Mulai kirim lokasi berkala ke server.
  /// Hanya dipanggil secara internal saat admin me-request tracking.
  /// [intervalSeconds] : interval pengiriman (default 10 detik untuk live tracking)
  void startLiveTracking({int intervalSeconds = 10}) {
    if (_isLiveTracking) return;
    _isLiveTracking = true;
    debugPrint('[WS] Live tracking started (interval: ${intervalSeconds}s)');

    // Kirim lokasi pertama segera
    _sendCurrentLocation();

    // Lalu kirim berkala
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) => _sendCurrentLocation(),
    );
  }

  /// Hentikan live tracking.
  /// Dipanggil saat server kirim 'stop_tracking' atau saat user check-out / logout.
  void stopLiveTracking() {
    if (!_isLiveTracking) return;
    _isLiveTracking = false;
    _locationTimer?.cancel();
    _locationTimer = null;
    debugPrint('[WS] Live tracking stopped');
  }

  /// Beri tahu server bahwa sesi kerja telah selesai agar marker lokasi
  /// pengguna segera dihapus dari halaman live tracking admin.
  void notifyTrackingStopped() {
    stopLiveTracking();
    _send({'type': 'tracking_stopped'});
  }

  /// Kirim lokasi terkini via WebSocket
  Future<void> _sendCurrentLocation() async {
    // Guard: cegah panggilan bersamaan (jika panggilan sebelumnya belum selesai)
    if (_isGettingLocation) {
      debugPrint('[WS] Already getting location, skipping this tick...');
      return;
    }
    if (!_isConnected || !_isAuthenticated) {
      debugPrint(
        '[WS] _sendCurrentLocation skipped: connected=$_isConnected, authenticated=$_isAuthenticated',
      );
      return;
    }
    if (onGetCurrentLocation == null) {
      debugPrint('[WS] onGetCurrentLocation callback not set, skipping...');
      return;
    }

    _isGettingLocation = true;
    try {
      debugPrint('[WS] Getting current location...');
      final loc = await onGetCurrentLocation!();
      debugPrint('[WS] Got location: ${loc['latitude']}, ${loc['longitude']}');
      _send({
        'type': 'live_location',
        'data': {
          'latitude': loc['latitude'],
          'longitude': loc['longitude'],
          'timestamp': DateTime.now().toIso8601String(),
        },
      });
      debugPrint('[WS] Location sent successfully');
    } catch (e) {
      debugPrint('[WS] Error getting/sending location: $e');
    } finally {
      _isGettingLocation = false;
    }
  }

  // ── Helpers ────────────────────────────────────────
  String _buildWsUrl(String baseUrl) {
    var cleanBase = baseUrl.replaceAll(RegExp(r'/graphql/?$'), '');
    if (cleanBase.endsWith('/')) {
      cleanBase = cleanBase.substring(0, cleanBase.length - 1);
    }
    final wsBase = cleanBase.replaceFirst(RegExp(r'^http'), 'ws');
    return '$wsBase/notifications';
  }
}
