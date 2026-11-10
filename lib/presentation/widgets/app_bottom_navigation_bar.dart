import 'package:presensi_mobile/l10n/hr_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_mobile/core/_core.dart';

class AppBottomNavigationBar extends StatelessWidget {
  // Navigation controls should keep a stable touch target on large screens.
  // ScreenUtil's width-based values grow excessively on tablets in landscape.
  static const double _mainButtonSize = 64;
  static const double _mainButtonIconSize = 32;
  static const double _navigationIconSize = 38;
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildItem(
                  context,
                  index: 0,
                  icon: PhosphorIcons.squaresFour,
                  assetName: 'home',
                  label: ("Home").tr(context),
                ),
                _buildItem(
                  context,
                  index: 1,
                  icon: PhosphorIcons.calendarCheck,
                  assetName: 'attendance',
                  label: ("Presensi").tr(context),
                ),

                // Space for main button
                const SizedBox(width: _mainButtonGap),

                _buildItem(
                  context,
                  index: 2,
                  icon: PhosphorIcons.cardsThree,
                  assetName: 'visits',
                  label: ('Kunjungan').tr(context),
                ),
                _buildItem(
                  context,
                  index: 3,
                  icon: PhosphorIcons.user,
                  assetName: 'profile',
                  label: ('Profile').tr(context),
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
    required String assetName,
    required String label,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.primary : AppColors.labelSecondary;
    final navigationIcon = Image.asset(
      'assets/icons/menu/$assetName.png',
      width: _navigationIconSize,
      height: _navigationIconSize,
      cacheWidth: 96,
      cacheHeight: 96,
      excludeFromSemantics: true,
      errorBuilder: (_, _, _) =>
          Icon(icon, color: color, size: _navigationIconSize),
    );

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 30,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primaryLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: OverflowBox(
                  minWidth: _navigationIconSize,
                  maxWidth: _navigationIconSize,
                  minHeight: _navigationIconSize,
                  maxHeight: _navigationIconSize,
                  child: isActive
                      ? navigationIcon
                      : ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0,
                            0,
                            0,
                            1,
                            0,
                          ]),
                          child: navigationIcon,
                        ),
                ),
              ),
              const SizedBox(height: 2),
              HrText(
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
      ),
    );
  }

  static Widget buildMainActionButton(
    BuildContext context,
    String label,
    VoidCallback onTap, {
    bool enabled = true,
    bool isLoading = false,
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
                onTap: enabled && !isLoading ? onTap : null,
                child: isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Icon(
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
          HrText(
            isLoading ? 'Memproses...' : label,
            style: context.theme.textTheme.labelSmall?.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
