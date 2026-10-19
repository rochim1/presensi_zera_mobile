import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/service/cached_api_session.dart';

class LocalSession extends Fake implements LoginLocalDatasource {
  @override
  Future<LoginUserEntity> getLogin() async => const LoginUserEntity(
    userId: 'qa-employee',
    token: 'qa-test-token',
    appId: 'qa-test-device',
  );
}

class ApiContext extends Fake implements FlavorConfig {
  @override
  String? token;
  @override
  String? appId;
}

class MissingSession extends Fake implements LoginLocalDatasource {
  @override
  Future<LoginUserEntity> getLogin() async =>
      throw CacheException(message: 'No session');
}

void main() {
  test(
    'a fresh or logged-out browser can still open the application',
    () async {
      final context = ApiContext();
      await restoreCachedApiSession(context, datasource: MissingSession());
      expect(context.token, isNull);
      expect(context.appId, isNull);
    },
  );
  test(
    'restored session supplies credentials before the next API request',
    () async {
      final context = ApiContext();
      await restoreCachedApiSession(context, datasource: LocalSession());
      expect(context.token, 'qa-test-token');
      expect(context.appId, 'qa-test-device');
    },
  );
}
