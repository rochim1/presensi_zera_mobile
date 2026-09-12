import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppBottomNavigationBar extends StatelessWidget {
  // Navigation controls should keep a stable touch target on large screens.
  // ScreenUtil's width-based values grow excessively on tablets in landscape.
  static const double _mainButtonSize = 64;
  static const double _mainButtonIconSize = 32;
  static const double _navigationIconSize = 20;
  static const double _mainButtonGap = 64;

  final int currentIndex;
  final ValueChanged<int> onTap;
  final String mainButtonLabel;
  final VoidCallback? onTapMainButton;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.mainButtonLabel = 'Check In',
    this.onTapMainButton,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        top: false,
        child: Container(
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimens.r16),
            ),
            boxShadow: [
              BoxShadow(
                color: context.theme.shadowColor.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildItem(
                  context,
                  index: 0,
                  icon: PhosphorIcons.squaresFour,
                  activeIcon: PhosphorIcons.squaresFourFill,
                  label: "Home",
                ),
                _buildItem(
                  context,
                  index: 1,
                  icon: PhosphorIcons.calendarCheck,
                  activeIcon: PhosphorIcons.calendarCheckFill,
                  label: "Presensi",
                ),

                // Space for main button
                const SizedBox(width: _mainButtonGap),

                _buildItem(
                  context,
                  index: 2,
                  icon: PhosphorIcons.cardsThree,
                  activeIcon: PhosphorIcons.cardsThreeFill,
                  label: "Kunjungan",
                ),
                _buildItem(
                  context,
                  index: 3,
                  icon: PhosphorIcons.user,
                  activeIcon: PhosphorIcons.userFill,
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required int index,
    required PhosphorIconData icon,
    required PhosphorIconData activeIcon,
    required String label,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.primary : AppColors.labelSecondary;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: color,
              size: _navigationIconSize,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 11,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildMainActionButton(
    BuildContext context,
    String label,
    VoidCallback onTap, {
    bool enabled = true,
  }) {
    final isCheckOut = label.toLowerCase().contains('out');
    final backgroundColor = !enabled
        ? AppColors.neutral
        : isCheckOut
        ? AppColors.danger
        : AppColors.primary;
    final shadowColor = !enabled
        ? AppColors.grey
        : isCheckOut
        ? AppColors.red
        : AppColors.primary;

    return Transform.translate(
      offset: const Offset(0, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _mainButtonSize,
            height: _mainButtonSize,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                onTap: enabled ? onTap : null,
                child: Icon(
                  PhosphorIcons.fingerprint,
                  color: enabled
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.75),
                  size: _mainButtonIconSize,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: context.theme.textTheme.labelSmall?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
