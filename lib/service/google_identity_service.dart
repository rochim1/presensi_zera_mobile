import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:presensi_data/presensi_data.dart';

/// Google proves identity; Pantoo's Login mutation still authorizes the session.
class GoogleIdentityService {
  static Future<void>? _initialization;
  static String? _clientId;

  static Future<void> initialize(GraphQlService api) async {
    final data = await api
        .query(query: 'query { GetGoogleRegistrationClientId }')
        .timeout(const Duration(seconds: 15));
    final clientId = (data?['GetGoogleRegistrationClientId'] as String?)
        ?.trim();
    if (clientId == null || clientId.isEmpty) {
      throw StateError('Google Sign-In belum diaktifkan pada server ini.');
    }
    if (_clientId != null && _clientId != clientId) {
      throw StateError(
        'Server Google berubah. Tutup dan buka kembali aplikasi.',
      );
    }
    _clientId = clientId;
    final initialization = _initialization ??= GoogleSignIn.instance.initialize(
      clientId: kIsWeb ? clientId : null,
      serverClientId: kIsWeb ? null : clientId,
    );
    try {
      await initialization;
    } catch (_) {
      _initialization = null;
      _clientId = null;
      rethrow;
    }
  }
}
