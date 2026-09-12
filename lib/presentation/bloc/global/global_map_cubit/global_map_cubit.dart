import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/service/location_disclosure_service.dart';

part 'global_map_state.dart';

class GlobalMapCubit extends Cubit<GlobalMapState> {
  final Location location;

  GlobalMapCubit(this.location)
    : super(
        const GlobalMapState(
          targetPosition: LatLng(kDDefaultLat, kDDefaultLong),
          address: GlobalAddressEntity(),
        ),
      );

  void getPermissionStatus() async {
    emit(state.copyWith(typeState: TypeState.loading));

    if (!await LocationDisclosureService.ensureAccepted()) {
      emit(
        state.copyWith(
          typeState: TypeState.notLoaded,
          isLocationGranted: false,
          message: 'Persetujuan penggunaan lokasi belum diberikan',
        ),
      );
      return;
    }

    var status = await location.hasPermission();
    if (status != PermissionStatus.granted &&
        status != PermissionStatus.grantedLimited) {
      status = await location.requestPermission();
    }

    if (status != PermissionStatus.granted &&
        status != PermissionStatus.grantedLimited) {
      emit(
        state.copyWith(
          typeState: TypeState.notLoaded,
          isLocationGranted: false,
          message: PERMISSION_LOCATION_DENIED,
        ),
      );
      return;
    }

    bool service = await location.serviceEnabled();

    if (!service) {
      service = await location.requestService();
      if (!service) {
        emit(
          state.copyWith(
            typeState: TypeState.notLoaded,
            isLocationGranted: false,
            message: PERMISSION_LOCATION_DISABLE,
          ),
        );
        return;
      }
    }

    emit(
      state.copyWith(
        typeState: TypeState.loaded,
        isLocationGranted: true,
        message: null,
      ),
    );
  }

  Future<void> updateToCurrentLocation() async {
    emit(state.copyWith(typeState: TypeState.loading));
    try {
      if (!await LocationDisclosureService.ensureAccepted()) {
        emit(
          state.copyWith(
            typeState: TypeState.notLoaded,
            isLocationGranted: false,
            message: 'Persetujuan penggunaan lokasi belum diberikan',
          ),
        );
        return;
      }
      LocationData currentLocation = await location.getLocation();
      LatLng target = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );

      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        target.latitude,
        target.longitude,
      );

      emit(
        state.copyWith(
          typeState: TypeState.loaded,
          targetPosition: target,
          address: AppUtility.mapAddreass(placemarks),
        ),
      );
    } on PlatformException catch (e, s) {
      log.w(e.toString(), stackTrace: s);
      emit(
        state.copyWith(
          typeState: TypeState.notLoaded,
          message: 'Gagal mendapatkan lokasi: \${e.message}',
        ),
      );
    } catch (e, s) {
      log.w(e.toString(), stackTrace: s);
      emit(
        state.copyWith(
          typeState: TypeState.notLoaded,
          message: 'Gagal mendapatkan lokasi. Pastikan GPS aktif.',
        ),
      );
    }
  }

  Future<GlobalAddressEntity?> updateTarget(LatLng target) async {
    emit(state.copyWith(typeState: TypeState.loading));
    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        target.latitude,
        target.longitude,
      );

      final address = AppUtility.mapAddreass(placemarks);
      emit(
        state.copyWith(
          typeState: TypeState.loaded,
          targetPosition: target,
          address: address,
        ),
      );

      return address;
    } on PlatformException catch (e, s) {
      log.w(e.toString(), stackTrace: s);
      //! IO_ERROR handle error connection
      if (e.code == 'IO_ERROR') {
        emit(
          state.copyWith(
            typeState: TypeState.notLoaded,
            address: null,
            message: FAILURE_IO_ERROR,
          ),
        );
      } else {
        emit(
          state.copyWith(
            typeState: TypeState.notLoaded,
            address: null,
            message: FAILURE_MAP_NOTFOUND,
          ),
        );
      }
    }

    return null;
  }
}
