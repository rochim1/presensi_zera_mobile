import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppMapView extends StatelessWidget {
  final LatLng initialPosition;
  final double zoom;
  final bool showMarker;
  final bool showRadius;
  final double radius;

  final void Function(GoogleMapController controller)? onMapReady;

  const AppMapView({
    super.key,
    required this.initialPosition,
    this.zoom = 15,
    this.showMarker = false,
    this.showRadius = false,
    this.radius = 120,
    this.onMapReady,
  });

  void _onMapCreated(GoogleMapController controller) {
    controller.animateCamera(CameraUpdate.newLatLng(initialPosition));
    onMapReady?.call(controller);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: zoom,
      ),
      onMapCreated: _onMapCreated,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      markers: showMarker
          ? {
              Marker(
                markerId: const MarkerId('marker'),
                position: initialPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ),
            }
          : {},
      circles: showRadius
          ? {
              Circle(
                circleId: const CircleId('radius'),
                center: initialPosition,
                radius: radius,
                fillColor: Colors.blue.withValues(alpha: 0.15),
                strokeColor: Colors.blue.withValues(alpha: 0.3),
                strokeWidth: 1,
              ),
            }
          : {},
    );
  }
}
