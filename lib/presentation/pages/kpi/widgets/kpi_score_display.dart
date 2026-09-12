import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class KpiScoreDisplay extends StatelessWidget {
  final double? score;
  const KpiScoreDisplay({super.key, this.score});

  @override
  Widget build(BuildContext context) {
    if (score == null) return const Text('-');

    return Text(
      score!.toStringAsFixed(1),
      style: context.textStyle.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
