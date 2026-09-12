import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class ListItemNote extends StatelessWidget {
  final String label;
  final String? value;

  const ListItemNote({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(color: AppColors.grey.shade700, fontSize: 13),
          ),
        ),
        AppDimens.size2S.hSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value?.isEmptyStrip ?? '-',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}
