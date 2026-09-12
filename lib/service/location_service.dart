import 'dart:async';

import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/service/location_disclosure_service.dart';

abstract class LocationService {
  Future<AppLocation> getCurrentLocation();

  Future<AppAddress> getAddressByLocation(AppLocation location);
}

class LocationServiceImpl implements LocationService {
  final loc.Location locationLib;

  LocationServiceImpl({required this.locationLib});

  @override
  Future<AppLocation> getCurrentLocation() async {
    final disclosureAccepted = await LocationDisclosureService.ensureAccepted();
    if (!disclosureAccepted) {
      throw LocationFailure(
        message: 'Persetujuan penggunaan lokasi belum diberikan',
      );
    }

    // Runtime permission harus langsung mengikuti prominent disclosure.
    await _requestPermission();

    try {
      // Browser tidak memiliki sakelar GPS seperti Android/iOS. Memanggil
      // requestService di web tidak membantu dan dapat menyamarkan error asli.
      if (!kIsWeb) {
        bool serviceEnabled = await locationLib.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await locationLib.requestService();
          if (!serviceEnabled) {
            throw LocationFailure(message: 'Location service tidak aktif');
          }
        }
      }

      await locationLib.changeSettings(
        // Laptop umumnya mengandalkan Wi-Fi/IP dan tidak memiliki GPS. Mode
        // balanced lebih andal di web; validasi radius tetap memakai accuracy
        // yang dikembalikan browser.
        accuracy: kIsWeb
            ? loc.LocationAccuracy.balanced
            : loc.LocationAccuracy.high,
        interval: 5000,
        distanceFilter: 0,
      );

      final currentLocation = await locationLib.getLocation().timeout(
        const Duration(seconds: 30),
      );

      return AppLocation(
        lat: currentLocation.latitude,
        long: currentLocation.longitude,
      );
    } on TimeoutException {
      throw LocationFailure(
        message:
            'Lokasi belum berhasil ditemukan. Pastikan layanan lokasi Windows aktif, lalu coba lagi.',
      );
    } on PlatformException catch (error) {
      final message = switch (error.code) {
        'PERMISSION_DENIED' => PERMISSION_LOCATION_DENIED,
        'POSITION_UNAVAILABLE' =>
          'Posisi tidak tersedia. Pastikan layanan lokasi Windows aktif dan perangkat terhubung ke internet.',
        'TIMEOUT' =>
          'Pencarian lokasi terlalu lama. Pastikan layanan lokasi Windows aktif, lalu coba lagi.',
        _ => error.message ?? 'Gagal mendapatkan lokasi dari browser',
      };
      throw LocationFailure(message: message);
    }
  }

  Future<void> _requestPermission() async {
    final permissionStatus = await locationLib.hasPermission();
    if (permissionStatus != loc.PermissionStatus.granted &&
        permissionStatus != loc.PermissionStatus.grantedLimited) {
      final result = await locationLib.requestPermission();
      if (result != loc.PermissionStatus.granted &&
          result != loc.PermissionStatus.grantedLimited) {
        throw LocationFailure(message: PERMISSION_LOCATION_DENIED);
      }
    }
  }

  @override
  Future<AppAddress> getAddressByLocation(AppLocation location) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(
        location.lat,
        location.long,
      );

      if (placemarks.isEmpty) {
        throw LocationFailure(
          message: "No address found for the given location",
        );
      }

      final placemark = placemarks.first;
      final address =
          "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
      return AppAddress(location: location, address: address);
    } catch (e) {
      // Reverse geocoding is not consistently available in browsers. The
      // browser may already have returned a valid GPS position, so do not
      // discard it merely because its human-readable address cannot be found.
      if (kIsWeb) {
        return AppAddress(
          location: location,
          address:
              'Koordinat ${location.lat.toStringAsFixed(6)}, ${location.long.toStringAsFixed(6)}',
        );
      }
      throw LocationFailure(message: "Failed to get address");
    }
  }
}
