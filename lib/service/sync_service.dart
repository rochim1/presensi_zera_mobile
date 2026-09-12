import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

/// Service that syncs queued offline orders when connectivity is restored.
class SyncService {
  final OrderRepository orderRepository;
  final PresensiRepository presensiRepository;
  final TasksRepository tasksRepository;
  final LocalCacheService localCacheService;
  final NetworkInfo networkInfo;

  StreamSubscription? _connectivitySubscription;
  Timer? _retryTimer;
  bool _isSyncing = false;

  /// Notifier for pending count changes (Total of all queues).
  final ValueNotifier<int> pendingCountNotifier = ValueNotifier(0);

  SyncService({
    required this.orderRepository,
    required this.presensiRepository,
    required this.tasksRepository,
    required this.localCacheService,
    required this.networkInfo,
  });

  /// Initialize the sync service: listen for connectivity changes.
  void init() {
    _refreshPendingCount();

    _connectivitySubscription = networkInfo.onConnectivityChanged.listen((
      results,
    ) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) {
        syncPendingOrders();
      }
    });

    // Internet dapat tetap tersambung ketika hanya backend yang mati, sehingga
    // tidak ada event connectivity baru saat server hidup kembali.
    _retryTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (pendingCountNotifier.value > 0) syncPendingOrders();
    });
  }

  /// Manually trigger a sync of all pending orders.
  Future<void> syncPendingOrders() async {
    if (_isSyncing) return;

    final isOnline = await networkInfo.isConnected;
    if (!isOnline) return;

    _isSyncing = true;
    debugPrint('[SyncService] Starting sync of pending orders...');

    try {
      await _syncOrders();
      await _syncPresensi();
      await _syncVisits();
    } finally {
      _isSyncing = false;
      _refreshPendingCount();
    }
  }

  Future<void> _syncOrders() async {
    final keys = await localCacheService.getOrderQueueKeys();
    for (final key in keys.toList()) {
      final orderJson = await localCacheService.getOrderByKey(key);
      if (orderJson == null) continue;
      try {
        final params = SalesOrderParamsEntity.fromJson(orderJson);
        final result = await orderRepository.createSalesOrder(params);
        result.fold(
          (failure) => debugPrint(
            '[SyncService] Failed to sync order $key: ${failure.message}',
          ),
          (success) async => await localCacheService.removeOrder(key),
        );
      } catch (e) {
        debugPrint('[SyncService] Error syncing order $key: $e');
      }
    }
  }

  Future<void> _syncPresensi() async {
    final keys = await localCacheService.getPresensiQueueKeys();
    for (final key in keys.toList()) {
      final json = await localCacheService.getPresensiByKey(key);
      if (json == null) continue;
      try {
        final type = json['sync_type'];
        if (type != 'check_out') {
          debugPrint(
            '[SyncService] Presensi $key ($type) belum didukung untuk sync.',
          );
          continue;
        }

        final input = Map<String, dynamic>.from(json['input'] as Map);
        final emotionalReport = input['emotional_report'] is Map
            ? Map<String, dynamic>.from(input['emotional_report'] as Map)
            : <String, dynamic>{};
        final attachments = (json['foto_pendukung'] as List? ?? const [])
            .whereType<Map>()
            .map((item) => _multipartFromQueue(Map<String, dynamic>.from(item)))
            .whereType<http.MultipartFile>()
            .toList();

        final result = await presensiRepository.checkOut(
          CheckOutParams(
            fotoPresensi: json['foto_presensi'] is Map
                ? _multipartFromQueue(
                    Map<String, dynamic>.from(json['foto_presensi'] as Map),
                  )
                : null,
            fotoPendukung: attachments,
            input: CheckOutInputParams(
              keterangan: input['keterangan']?.toString(),
              location: AppLocation(
                lat: (input['latitude'] as num).toDouble(),
                long: (input['longitude'] as num).toDouble(),
              ),
              jamMulai: DateTime.parse(input['jam_mulai'].toString()),
              emotionalReport: emotionalReport,
            ),
          ),
        );

        final synced = result.fold((failure) {
          debugPrint(
            '[SyncService] Gagal sync checkout $key: ${failure.message}',
          );
          return false;
        }, (_) => true);
        if (synced) await localCacheService.removePresensi(key);
      } catch (e) {
        debugPrint('[SyncService] Error syncing presensi $key: $e');
      }
    }
  }

  http.MultipartFile? _multipartFromQueue(Map<String, dynamic> file) {
    final encoded = file['bytes']?.toString();
    if (encoded == null || encoded.isEmpty) return null;
    return http.MultipartFile.fromBytes(
      'file',
      base64Decode(encoded),
      filename: file['name']?.toString() ?? 'attachment',
    );
  }

  Future<void> _syncVisits() async {
    final keys = await localCacheService.getVisitQueueKeys();
    for (final key in keys.toList()) {
      final json = await localCacheService.getVisitByKey(key);
      if (json == null) continue;
      try {
        // TODO: Implement parsing from json to TasksParamsEntity etc.
        /*
        dynamic result;
        if (type == 'post_data') {
          result = await tasksRepository.postData(TasksParamsEntity.fromJson(json));
        } else if (type == 'post_completed') {
          result = await tasksRepository.postCompleted(TasksCompletedParamsEntity.fromJson(json));
        } else if (type == 'post_canceled') {
          result = await tasksRepository.postCanceled(TasksCanceledParamsEntity.fromJson(json));
        }
        */

        // Do not delete visit data until a real backend request succeeds.
        debugPrint(
          '[SyncService] Visit $key is still waiting for a supported sync.',
        );
      } catch (e) {
        debugPrint('[SyncService] Error syncing visit $key: $e');
      }
    }
  }

  /// Update the pending count notifier.
  Future<void> _refreshPendingCount() async {
    final orderCount = await localCacheService.getPendingOrderCount();
    final presensiCount = await localCacheService.getPendingPresensiCount();
    final visitCount = await localCacheService.getPendingVisitCount();
    pendingCountNotifier.value = orderCount + presensiCount + visitCount;
  }

  /// Refresh count externally (e.g. after adding a new queue item).
  Future<void> refreshPendingCount() async => _refreshPendingCount();

  /// Dispose resources.
  void dispose() {
    _connectivitySubscription?.cancel();
    _retryTimer?.cancel();
    pendingCountNotifier.dispose();
  }
}
