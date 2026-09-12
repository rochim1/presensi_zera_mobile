import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:presensi_mobile/presentation/widgets/global/background_location_disclosure.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Satu-satunya gerbang sebelum aplikasi meminta izin atau membaca lokasi.
///
/// Menyatukan seluruh alur lokasi mencegah halaman tertentu melewati
/// pengungkapan yang diwajibkan Google Play.
class LocationDisclosureService {
  static const int disclosureVersion = 3;
  static const String _preferenceKey = 'location_disclosure_version';

  static Future<bool>? _pendingRequest;

  static Future<bool> ensureAccepted() {
    return _pendingRequest ??= _ensureAccepted().whenComplete(() {
      _pendingRequest = null;
    });
  }

  static Future<bool> _ensureAccepted() async {
    final preferences = await SharedPreferences.getInstance();
    final acceptedVersion = preferences.getInt(_preferenceKey) ?? 0;
    if (acceptedVersion >= disclosureVersion) return true;

    final context = ChuckerFlutter.navigatorKey.currentContext;
    if (context == null || !context.mounted) return false;

    final accepted = await showBackgroundLocationDisclosure(context);
    if (!accepted) return false;

    await preferences.setInt(_preferenceKey, disclosureVersion);
    return true;
  }
}
