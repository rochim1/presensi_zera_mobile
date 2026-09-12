import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class MapViewDraggable extends StatelessWidget {
  final Function(GoogleMapController)? onMapCreated;
  final CameraPosition initialCameraPosition;
  final LatLng position;
  final Function()? onMyLocation;
  final Function()? onFullScreen;
  final bool? zoomControlsEnabled;
  final bool? zoomGesturesEnabled;
  final bool? scrollGesturesEnabled;
  final bool? rotateGesturesEnabled;
  final String? address;
  final ArgumentCallback<LatLng>? onTap;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  const MapViewDraggable({
    super.key,
    this.onMapCreated,
    required this.initialCameraPosition,
    required this.position,
    this.onMyLocation,
    this.onFullScreen,
    this.zoomControlsEnabled = false,
    this.zoomGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.rotateGesturesEnabled = false,
    this.address,
    this.onTap,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
  });

  static var eagerGestureRecognizer = <Factory<OneSequenceGestureRecognizer>>{
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.28,
      width: context.width,
      child: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: zoomControlsEnabled!,
            zoomGesturesEnabled: zoomGesturesEnabled!,
            scrollGesturesEnabled: scrollGesturesEnabled!,
            rotateGesturesEnabled: rotateGesturesEnabled!,
            gestureRecognizers: gestureRecognizers,
            onTap: onTap,
            markers: {
              Marker(
                markerId: const MarkerId(kMarkerId2),
                position: position,
                infoWindow: InfoWindow(title: address),
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
          if (onFullScreen != null)
            Positioned(
              right: AppDimens.paddingMediumX,
              bottom: AppDimens.paddingMediumX,
              child: IconButtonCustom(
                padding: const EdgeInsets.all(AppDimens.sizeM),
                selected: true,
                showShadow: true,
                selectedColor: AppColors.white,
                icon: const Icon(Icons.fullscreen_rounded),
                onTap: onFullScreen,
              ),
            ),
        ],
      ),
    );
  }
}
