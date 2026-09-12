import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? size;
  final double? padding;

  const AppCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black,
    this.backgroundColor = AppColors.white,
    this.size = 24,
    this.padding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(padding!),
            child: Icon(icon, color: iconColor, size: size),
          ),
        ),
      ),
    );
  }
}
