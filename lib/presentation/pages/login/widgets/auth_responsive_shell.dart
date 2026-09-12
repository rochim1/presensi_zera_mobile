import 'package:flutter/material.dart';

import '../../../../core/_core.dart';

class AuthResponsiveShell extends StatelessWidget {
  const AuthResponsiveShell({
    required this.child,
    super.key,
    this.topPadding = 16,
  });

  final Widget child;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppImages.geometricBg,
          fit: BoxFit.cover,
          alignment: Alignment.topLeft,
        ),
        Container(color: AppColors.primaryDark.withValues(alpha: 0.18)),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth >= 600;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 32 : 0,
                  topPadding,
                  isTablet ? 32 : 0,
                  24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - topPadding - 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            isTablet ? 24 : 0,
                          ),
                          border: isTablet
                              ? Border.all(color: AppColors.border)
                              : null,
                          boxShadow: isTablet
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 32,
                                    offset: const Offset(0, 12),
                                  ),
                                ]
                              : null,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
