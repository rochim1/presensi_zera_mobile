import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

@RoutePage()
class ApotekMapsPage extends StatefulWidget {
  const ApotekMapsPage({super.key});

  @override
  State<ApotekMapsPage> createState() => _ApotekMapsPageState();
}

class _ApotekMapsPageState extends State<ApotekMapsPage> {
  final Completer<GoogleMapController> _controller = Completer();
  
  // Default to Jakarta
  static const CameraPosition _kDefaultInitialPosition = CameraPosition(
    target: LatLng(-6.2088, 106.8456),
    zoom: 11.0,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ApotekGetAllDataCubit>()..initLoadAllData(),
      child: Scaffold(
        appBar: const AppTopBar(title: 'Peta Outlet'),
        body: BlocBuilder<ApotekGetAllDataCubit, ApotekGetAllDataState>(
          builder: (context, state) {
            if (state.status == TypeState.loading || state.status == TypeState.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == TypeState.notLoaded) {
              return Center(
                child: Text(
                  state.failure?.message ?? 'Gagal memuat data outlet',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final apotekList = state.apoteks ?? [];
            final Set<Marker> markers = {};
            
            // Calculate center
            double totalLat = 0;
            double totalLng = 0;
            int validCount = 0;

            for (final apotek in apotekList) {
              if (apotek.latitude != null && apotek.longitude != null) {
                final lat = double.tryParse(apotek.latitude!);
                final lng = double.tryParse(apotek.longitude!);
                
                if (lat != null && lng != null && lat != 0 && lng != 0) {
                  totalLat += lat;
                  totalLng += lng;
                  validCount++;
                  
                  markers.add(
                    Marker(
                      markerId: MarkerId(apotek.id ?? apotek.hashCode.toString()),
                      position: LatLng(lat, lng),
                      infoWindow: InfoWindow(
                        title: apotek.namaApotik,
                        snippet: apotek.alamat,
                        onTap: () {
                          context.router.push(ApotekDetailPageRoute(apotek: apotek));
                        },
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    ),
                  );
                }
              }
            }

            CameraPosition initialCameraPosition = _kDefaultInitialPosition;
            if (validCount > 0) {
              initialCameraPosition = CameraPosition(
                target: LatLng(totalLat / validCount, totalLng / validCount),
                zoom: 12.0,
              );
            }

            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          },
        ),
      ),
    );
  }
}
