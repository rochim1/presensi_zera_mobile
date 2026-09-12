import 'package:hive/hive.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class LoginLocalDatasource {
  /// check local Login data
  Future<LoginUserEntity> checkLogin();

  /// save to local Login data
  Future<void> cacheLogin(LoginUserModel data);

  /// get local Login data
  Future<LoginUserEntity> getLogin();

  /// delete local for data user
  Future<void> signOut();
}

class LoginLocalDatasourceImpl extends LoginLocalDatasource {
  Future<Box<LoginUserModel>> _getBox() async {
    return await Hive.openBox<LoginUserModel>(
      BOX_LOGIN,
    ).onError((e, s) => throw CacheException(message: FAILURE_UNKNOWN));
  }

  @override
  Future<void> cacheLogin(LoginUserModel data) async {
    Box<LoginUserModel> box = await _getBox();

    await box.put(BOX_KEY_LOGIN, data).onError((error, stackTrace) {
      throw CacheException(message: FAILURE_UNKNOWN);
    });
  }

  @override
  Future<LoginUserEntity> checkLogin() async {
    Box<LoginUserModel> box = await _getBox();

    if (box.containsKey(BOX_KEY_LOGIN)) {
      return box.get(BOX_KEY_LOGIN)!;
    } else {
      throw CacheException(message: EXCEPTION_LOGIN);
    }
  }

  @override
  Future<LoginUserEntity> getLogin() async {
    Box<LoginUserModel> box = await _getBox();

    if (box.containsKey(BOX_KEY_LOGIN)) {
      return box.get(BOX_KEY_LOGIN)!;
    } else {
      throw CacheException(message: EXCEPTION_LOGIN);
    }
  }

  @override
  Future<void> signOut() async {
    await Hive.deleteBoxFromDisk(BOX_LOGIN);
  }
}
