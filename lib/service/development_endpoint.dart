import 'package:presensi_data/presensi_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Restore the same server as login before any authenticated request is made.
/// Production/staging always retain their configured endpoint.
Future<void> restoreDevelopmentEndpoint(FlavorConfig flavor) async {
  if (flavor.env != Env.DEVELOPMENT) return;
  final preferences = await SharedPreferences.getInstance();
  final endpoint = preferences.getString('dev_base_url')?.trim();
  if (endpoint != null && endpoint.isNotEmpty) flavor.baseApi = endpoint;
}
