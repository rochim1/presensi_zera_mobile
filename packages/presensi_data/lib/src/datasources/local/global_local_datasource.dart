import 'package:hive/hive.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class GlobalLocalDatasource {
  /// save to local
  Future<void> cacheQuery(GlobalQueryModel params, String boxKey);

  /// get local
  Future<List<GlobalQueryEntity>> getQuery(String boxKey);

  Future<void> deleteQueries(String boxKey);
}

class GlobalLocalDatasourceImpl extends GlobalLocalDatasource {
  Future<Box<GlobalQueryModel>> _getBox(String boxKey) async {
    return await Hive.openBox<GlobalQueryModel>(
      boxKey,
    ).onError((e, s) => throw CacheException(message: FAILURE_UNKNOWN));
  }

  @override
  Future<void> cacheQuery(GlobalQueryModel params, String boxKey) async {
    Box<GlobalQueryModel> box = await _getBox(boxKey);

    box.add(params).onError((error, stackTrace) {
      throw CacheException(message: FAILURE_UNKNOWN);
    });
  }

  @override
  Future<List<GlobalQueryEntity>> getQuery(String boxKey) async {
    Box<GlobalQueryModel> box = await _getBox(boxKey);

    return box.values.toList();
  }

  @override
  Future<void> deleteQueries(String boxKey) async {
    await Hive.deleteBoxFromDisk(boxKey);
  }
}
