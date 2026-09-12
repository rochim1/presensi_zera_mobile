import 'package:hive_flutter/hive_flutter.dart';
import 'package:presensi_data/core/values/constant.dart';

/// Local cache service for storing Apotek & Product data offline.
class LocalCacheService {
  // ── Apotek Cache ──────────────────────────────────
  Future<Box<Map>> _getApotekBox() async {
    return await Hive.openBox<Map>(BOX_APOTEK_CACHE);
  }

  /// Save all apotek data to local cache.
  Future<void> cacheApotekList(List<Map<String, dynamic>> apotekListJson) async {
    final box = await _getApotekBox();
    await box.clear();
    for (int i = 0; i < apotekListJson.length; i++) {
      await box.put(i, apotekListJson[i]);
    }
  }

  /// Get cached apotek data.
  Future<List<Map<String, dynamic>>> getCachedApotekList() async {
    final box = await _getApotekBox();
    if (box.isEmpty) return [];
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // ── Product Cache ─────────────────────────────────
  Future<Box<Map>> _getProductBox() async {
    return await Hive.openBox<Map>(BOX_PRODUCT_CACHE);
  }

  /// Save all product data to local cache.
  Future<void> cacheProductList(List<Map<String, dynamic>> productListJson) async {
    final box = await _getProductBox();
    await box.clear();
    for (int i = 0; i < productListJson.length; i++) {
      await box.put(i, productListJson[i]);
    }
  }

  /// Get cached product data.
  Future<List<Map<String, dynamic>>> getCachedProductList() async {
    final box = await _getProductBox();
    if (box.isEmpty) return [];
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // ── Order Queue ───────────────────────────────────
  Future<Box<Map>> _getOrderQueueBox() async {
    return await Hive.openBox<Map>(BOX_ORDER_QUEUE);
  }

  /// Add a sales order to the offline queue.
  Future<void> enqueueOrder(Map<String, dynamic> orderJson) async {
    final box = await _getOrderQueueBox();
    await box.add(orderJson);
  }

  /// Get all pending orders from the queue.
  Future<List<Map<String, dynamic>>> getPendingOrders() async {
    final box = await _getOrderQueueBox();
    if (box.isEmpty) return [];
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Get the count of pending orders.
  Future<int> getPendingOrderCount() async {
    final box = await _getOrderQueueBox();
    return box.length;
  }

  /// Remove a specific order from the queue by its key.
  Future<void> removeOrder(dynamic key) async {
    final box = await _getOrderQueueBox();
    await box.delete(key);
  }

  /// Clear all orders from the queue (after successful sync).
  Future<void> clearOrderQueue() async {
    final box = await _getOrderQueueBox();
    await box.clear();
  }

  /// Get the box keys for iterating.
  Future<Iterable<dynamic>> getOrderQueueKeys() async {
    final box = await _getOrderQueueBox();
    return box.keys;
  }

  /// Get a single order by key.
  Future<Map<String, dynamic>?> getOrderByKey(dynamic key) async {
    final box = await _getOrderQueueBox();
    final val = box.get(key);
    return val != null ? Map<String, dynamic>.from(val) : null;
  }


  // ── Presensi Queue ───────────────────────────────────
  Future<Box<Map>> _getPresensiQueueBox() async {
    return await Hive.openBox<Map>(BOX_PRESENSI_QUEUE);
  }

  Future<void> enqueuePresensi(Map<String, dynamic> presensiJson) async {
    final box = await _getPresensiQueueBox();
    await box.add(presensiJson);
  }

  Future<List<Map<String, dynamic>>> getPendingPresensi() async {
    final box = await _getPresensiQueueBox();
    if (box.isEmpty) return [];
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<int> getPendingPresensiCount() async {
    final box = await _getPresensiQueueBox();
    return box.length;
  }

  Future<void> removePresensi(dynamic key) async {
    final box = await _getPresensiQueueBox();
    await box.delete(key);
  }

  Future<Iterable<dynamic>> getPresensiQueueKeys() async {
    final box = await _getPresensiQueueBox();
    return box.keys;
  }

  Future<Map<String, dynamic>?> getPresensiByKey(dynamic key) async {
    final box = await _getPresensiQueueBox();
    final val = box.get(key);
    return val != null ? Map<String, dynamic>.from(val) : null;
  }

  // ── Visit Queue ───────────────────────────────────
  Future<Box<Map>> _getVisitQueueBox() async {
    return await Hive.openBox<Map>(BOX_VISIT_QUEUE);
  }

  Future<void> enqueueVisit(Map<String, dynamic> visitJson) async {
    final box = await _getVisitQueueBox();
    await box.add(visitJson);
  }

  Future<List<Map<String, dynamic>>> getPendingVisits() async {
    final box = await _getVisitQueueBox();
    if (box.isEmpty) return [];
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<int> getPendingVisitCount() async {
    final box = await _getVisitQueueBox();
    return box.length;
  }

  Future<void> removeVisit(dynamic key) async {
    final box = await _getVisitQueueBox();
    await box.delete(key);
  }

  Future<Iterable<dynamic>> getVisitQueueKeys() async {
    final box = await _getVisitQueueBox();
    return box.keys;
  }

  Future<Map<String, dynamic>?> getVisitByKey(dynamic key) async {
    final box = await _getVisitQueueBox();
    final val = box.get(key);
    return val != null ? Map<String, dynamic>.from(val) : null;
  }
}
