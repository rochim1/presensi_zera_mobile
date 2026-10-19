import 'package:presensi_data/presensi_data.dart';

/// Hydrate HTTP/WS credentials once, before creating any routes or session work.
/// Keeping this at bootstrap avoids a delayed old account restore changing the
/// active credentials after an interactive logout/login.
Future<void> restoreCachedApiSession(
  FlavorConfig flavor, {
  LoginLocalDatasource? datasource,
}) async {
  try {
    final login = await (datasource ?? LoginLocalDatasourceImpl()).getLogin();
    flavor.token = login.token;
    flavor.appId = login.appId;
  } on CacheException {
    // A fresh or logged-out installation has no local session. Route guards
    // handle login; never delete data or fail application startup here.
  }
}
