import 'package:flutter/material.dart';

/// Coordinates remain the source for server-side attendance/location rules.
/// Google Maps web can be enabled after its browser API key is configured.
class WebAttendanceLocation extends StatelessWidget {
  const WebAttendanceLocation({
    super.key,
    required this.ready,
    required this.latitude,
    required this.longitude,
  });
  final bool ready;
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xFFE8F3F1),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              ready ? Icons.location_on_rounded : Icons.location_searching,
              size: 56,
              color: const Color(0xFF087F78),
            ),
            const SizedBox(height: 12),
            Text(
              ready
                  ? 'Lokasi dari browser ditemukan'
                  : 'Mencari lokasi browser…',
              textAlign: TextAlign.center,
            ),
            if (ready) ...[
              const SizedBox(height: 8),
              Text(
                '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
              ),
            ],
            const SizedBox(height: 12),
            const Text(
              'Peta tidak ditampilkan. Presensi tetap memakai titik lokasi perangkat dan aturan lokasi perusahaan.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
