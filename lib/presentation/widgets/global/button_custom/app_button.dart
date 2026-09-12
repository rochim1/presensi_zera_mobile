import 'package:flutter/material.dart';

import '../../../../core/_core.dart';

class AppButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final IconData? icon;
  final List<Color>? colors;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.colors,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Container(
                width: double.infinity,
                height: AppDimens.size3XL,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        widget.colors ??
                        [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMediumX),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.colors?.first ?? AppColors.primary)
                          .withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.isLoading ? null : widget.onPressed,
                    borderRadius: BorderRadius.circular(
                      AppDimens.radiusMediumX,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: widget.isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: AppDimens.sizeL,
                                  height: AppDimens.sizeL,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.white,
                                    ),
                                    strokeWidth: 2.5,
                                  ),
                                ),
                                const SizedBox(width: AppDimens.sizeM),
                                Text(
                                  'Memproses...',
                                  style: context.textStyle.bodyLarge?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.icon != null) ...[
                                  Icon(
                                    widget.icon,
                                    color: AppColors.white,
                                    size: AppDimens.sizeL,
                                  ),
                                  const SizedBox(width: AppDimens.size2S),
                                ],
                                Text(
                                  widget.text,
                                  style: context.textStyle.bodyLarge?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
