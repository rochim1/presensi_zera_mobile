import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class MapViewWidget extends StatelessWidget {
  final Function(GoogleMapController)? onMapCreated;
  final CameraPosition initialCameraPosition;
  final LatLng position;
  final LatLng? outletPosition;
  final Function()? onMyLocation;
  final Function()? onChangePosition;

  const MapViewWidget({
    super.key,
    this.onMapCreated,
    required this.initialCameraPosition,
    required this.position,
    this.outletPosition,
    this.onMyLocation,
    this.onChangePosition,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.25,
      width: context.width,
      child: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            markers: {
              Marker(markerId: const MarkerId(kMarkerId), position: position),
              if (outletPosition != null)
                Marker(
                  markerId: const MarkerId('outlet_marker'),
                  position: outletPosition!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
            },
            onMapCreated: onMapCreated,
            initialCameraPosition: initialCameraPosition,
          ),
          if (onMyLocation != null)
            Positioned(
              right: AppDimens.paddingMediumX,
              bottom: AppDimens.paddingMediumX,
              child: IconButtonCustom(
                padding: const EdgeInsets.all(AppDimens.sizeM),
                selected: true,
                showShadow: true,
                selectedColor: AppColors.white,
                icon: const Icon(Icons.location_searching_rounded),
                onTap: onMyLocation,
              ),
            ),
          Positioned(
            top: AppDimens.paddingSmall,
            right: AppDimens.paddingSmall,
            child: IconButtonCustom(
              padding: const EdgeInsets.all(AppDimens.sizeM),
              selected: true,
              showShadow: true,
              selectedColor: AppColors.white,
              icon: const Icon(Icons.fullscreen_rounded, color: AppColors.primary),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => Scaffold(
                      body: Stack(
                        children: [
                          GoogleMap(
                            zoomControlsEnabled: true,
                            zoomGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            rotateGesturesEnabled: true,
                            markers: {
                              Marker(markerId: const MarkerId(kMarkerId), position: position),
                              if (outletPosition != null)
                                Marker(
                                  markerId: const MarkerId('outlet_marker'),
                                  position: outletPosition!,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                                ),
                            },
                            initialCameraPosition: CameraPosition(
                              target: position,
                              zoom: 16,
                            ),
                          ),
                          Positioned(
                            top: 50,
                            left: 16,
                            child: InkWell(
                              onTap: () => Navigator.pop(ctx),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                                ),
                                child: const Icon(Icons.arrow_back, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (onChangePosition != null)
            Positioned(
              right: AppDimens.paddingMediumX,
              bottom: AppDimens.paddingMediumX,
              child: IconButtonCustom(
                padding: const EdgeInsets.all(AppDimens.sizeM),
                selected: true,
                showShadow: true,
                selectedColor: AppColors.white,
                icon: const Icon(
                  Icons.edit_location_alt_rounded,
                  color: AppColors.red,
                ),
                onTap: onChangePosition,
              ),
            ),
        ],
      ),
    );
  }
}
