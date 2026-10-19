import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/service/development_endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestFlavor extends Fake implements FlavorConfig {
  TestFlavor(this.env);
  @override
  final Env env;
  @override
  String? baseApi;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'restores the login server before session requests after restart',
    () async {
      SharedPreferences.setMockInitialValues({
        'dev_base_url': ' http://localhost:8086/graphql ',
      });
      final flavor = TestFlavor(Env.DEVELOPMENT);
      await restoreDevelopmentEndpoint(flavor);
      expect(flavor.baseApi, 'http://localhost:8086/graphql');
    },
  );
  test('missing or empty preference retains the configured endpoint', () async {
    for (final values in [
      <String, Object>{},
      <String, Object>{'dev_base_url': '  '},
    ]) {
      SharedPreferences.setMockInitialValues(values);
      final flavor = TestFlavor(Env.DEVELOPMENT)
        ..baseApi = 'http://configured.test/graphql';
      await restoreDevelopmentEndpoint(flavor);
      expect(flavor.baseApi, 'http://configured.test/graphql');
    }
  });
  test(
    'saved development server cannot override production or staging',
    () async {
      SharedPreferences.setMockInitialValues({
        'dev_base_url': 'http://localhost:8086/graphql',
      });
      for (final environment in [Env.PRODUCTION, Env.STAGING]) {
        final flavor = TestFlavor(environment)
          ..baseApi = 'https://configured.test/graphql';
        await restoreDevelopmentEndpoint(flavor);
        expect(flavor.baseApi, 'https://configured.test/graphql');
      }
    },
  );
}
