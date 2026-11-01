import 'package:flutter/material.dart';
import 'package:presensi_mobile/presentation/widgets/app_chip.dart';

class KpiStatusBadge extends StatelessWidget {
  final String status;
  const KpiStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String label;

    switch (status) {
      case 'draft':
        label = 'Siap Dinilai';
        break;
      case 'data_collection':
        label = 'Pengumpulan Data';
        break;
      case 'self_review':
        label = 'Self Assessment';
        break;
      case 'manager_review':
        label = 'Menunggu Review';
        break;
      case 'completed':
        label = 'Menunggu Konfirmasi';
        break;
      case 'acknowledged':
        label = 'Selesai';
        break;
      default:
        label = status;
    }

    return AppChip(label: label);
  }
}
