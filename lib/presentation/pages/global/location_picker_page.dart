import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPickerResult {
  final LatLng position;
  final GlobalAddressEntity address;

  LocationPickerResult({required this.position, required this.address});
}

@RoutePage()
class LocationPickerPage extends StatefulWidget {
  final double initialLat;
  final double initialLong;
  final bool isReadOnly;

  const LocationPickerPage({
    super.key,
    this.initialLat = kDDefaultLat,
    this.initialLong = kDDefaultLong,
    this.isReadOnly = false,
  });

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  CameraPosition? _lastCameraPosition;

  Future<void> _moveCameraTo(LatLng latLng) async {
    try {
      final controller = await _mapController.future;
      await controller.animateCamera(CameraUpdate.newLatLng(latLng));
    } catch (_) {}
  }

  void _onCameraMove(CameraPosition position) {
    if (widget.isReadOnly) return;

    _lastCameraPosition = position;
  }

  void _onCameraIdle(BuildContext context) async {
    if (_lastCameraPosition == null) return;

    await context.read<GlobalMapCubit>().updateTarget(
      _lastCameraPosition!.target,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }
  }

  void _onMapTap(BuildContext context, LatLng target) async {
    if (widget.isReadOnly) return;

    await context.read<GlobalMapCubit>().updateTarget(target);
    _moveCameraTo(target);
  }

  void _onTapMyLocation(BuildContext context) async {
    if (widget.isReadOnly) return;
    final cubit = context.read<GlobalMapCubit>();

    await cubit.updateToCurrentLocation();
    final position = cubit.state.targetPosition;
    if (position == null) return;
    _moveCameraTo(position);
  }

  Future<void> _openInGoogleMaps(LatLng latLng) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}',
    );
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Fluttertoast.showToast(msg: 'Tidak dapat membuka Google Maps');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Gagal membuka Google Maps');
    }
  }

  @override
  void dispose() {
    _mapController.future.then((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = LatLng(widget.initialLat, widget.initialLong);

    return BlocProvider(
      create: (ctx) => sl<GlobalMapCubit>()
        ..getPermissionStatus()
        ..updateTarget(initialPosition),
      child: BlocConsumer<GlobalMapCubit, GlobalMapState>(
        listener: (context, state) {
          if (state.typeState.isNotLoaded && state.message != null) {
            Fluttertoast.showToast(msg: state.message!);
          }
        },
        builder: (context, state) {
          return Material(
            child: Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: initialPosition,
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    rotateGesturesEnabled: !widget.isReadOnly,
                    scrollGesturesEnabled: !widget.isReadOnly,
                    zoomGesturesEnabled: !widget.isReadOnly,
                    onMapCreated: _onMapCreated,
                    onCameraMove: (position) => _onCameraMove(position),
                    onCameraIdle: () => _onCameraIdle(context),
                    onTap: (target) => _onMapTap(context, target),
                  ),
                ),
                _buildMapPinMarker(isLoading: state.typeState.isLoading),
                _buildAppBar(),
                _buildBottomBar(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: AppDimens.appBarHeight,
      left: AppDimens.paddingMediumX,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
      ),
    );
  }

  Widget _buildMapPinMarker({bool isLoading = false}) {
    const pinSize = AppDimens.size3XL;
    const pinSizeHeight = pinSize + (pinSize * 0.3);
    return IgnorePointer(
      ignoring: true,
      child: Center(
        child: Transform.translate(
          offset: const Offset(0, -(pinSizeHeight / 2)),
          child: MapPin(isLoading: isLoading, size: pinSize),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, GlobalMapState state) {
    final target =
        state.targetPosition ?? const LatLng(kDDefaultLat, kDDefaultLong);
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.all(AppDimens.paddingMediumX),
              child: Column(
                children: [
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: IconButton(
                      icon: const Icon(Icons.map_outlined),
                      tooltip: 'Buka di Google Maps',
                      onPressed: () {
                        _openInGoogleMaps(target);
                      },
                    ),
                  ),
                  if (!widget.isReadOnly) ...[
                    AppDimens.size2M.hSpace,
                    Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 4,
                      child: IconButton(
                        icon: const Icon(Icons.my_location),
                        onPressed: () => _onTapMyLocation(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppDimens.paddingMediumX),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimens.radiusMediumX),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    minHeight: AppDimens.size1X,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lokasi Terpilih',
                        style: context.textStyle.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      AppDimens.size3M.hSpace,
                      if (state.typeState.isLoading) ...[
                        Row(
                          children: const [
                            SpinKitThreeBounce(
                              color: AppColors.primary,
                              size: AppDimens.sizeM,
                            ),
                            SizedBox(width: AppDimens.sizeS),
                            Text(
                              'Mencari lokasi...',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                      if (state.typeState.isLoaded) ...[
                        Text(
                          state.address?.toString() ?? '',
                          style: context.textStyle.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.isReadOnly) ...[
                  AppDimens.size3M.hSpace,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      onPressed: () => context.router.pop(),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],

                if (!widget.isReadOnly) ...[
                  AppDimens.size3M.hSpace,
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.fillTertiary,
                            foregroundColor: AppColors.labelPrimary,
                          ),
                          onPressed: () => context.router.pop(),
                          child: const Text('Batal'),
                        ),
                      ),
                      AppDimens.size3M.wSpace,
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.typeState.isLoading
                                ? AppColors.grey
                                : AppColors.primary,
                            foregroundColor: AppColors.white,
                          ),
                          child: const Text('Pilih Lokasi'),
                          onPressed: () {
                            if (state.typeState.isLoading) return;
                            final result = LocationPickerResult(
                              position: state.targetPosition!,
                              address: state.address!,
                            );
                            context.router.pop(result);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MapPin extends StatelessWidget {
  final bool isLoading;
  final Color pinColor;
  final double size;

  const MapPin({
    super.key,
    required this.isLoading,
    this.pinColor = AppColors.primary,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size + (size * 0.3), // 0.3 for tail overlap,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          _buildPinTail(),
          _buildPinHead(isLoading: isLoading),
        ],
      ),
    );
  }

  Widget _buildPinHead({bool isLoading = false}) {
    return Positioned(
      top: 0,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: pinColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading ? _buildPinHeadLoading() : _buildPinHeadCircle(),
        ),
      ),
    );
  }

  Widget _buildPinHeadCircle() {
    return Container(
      width: size * 0.3,
      height: size * 0.3,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildPinHeadLoading() {
    return SizedBox(
      width: size * 0.5,
      height: size * 0.5,
      child: CircularProgressIndicator(
        strokeWidth: size * 0.05,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildPinTail() {
    return Positioned(
      bottom: 0,
      child: CustomPaint(
        size: Size(size / 2, size / 2),
        painter: _PinTailPainter(pinColor),
      ),
    );
  }
}

class _PinTailPainter extends CustomPainter {
  final Color color;

  _PinTailPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
