import 'package:flutter/material.dart';
import 'package:presensi_mobile/core/_core.dart';

class TabIndicator extends Decoration {
  final double indicatorHeight;
  final Color indicatorColor;
  final double indicatorRadius;
  final EdgeInsetsGeometry insets;
  final TabBarIndicatorSize tabBarIndicatorSize;

  @override
  final EdgeInsetsGeometry padding;

  const TabIndicator({
    this.indicatorHeight = 24.0,
    this.indicatorColor = AppColors.secondary,
    this.indicatorRadius = 100.0,
    this.tabBarIndicatorSize = TabBarIndicatorSize.tab,
    this.padding = const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
    this.insets = EdgeInsets.zero,
  });

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is TabIndicator) {
      return TabIndicator(
        padding: EdgeInsetsGeometry.lerp(a.padding, padding, t)!,
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is TabIndicator) {
      return TabIndicator(
        padding: EdgeInsetsGeometry.lerp(padding, b.padding, t)!,
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _BubblePainter(this, onChanged);
  }
}

class _BubblePainter extends BoxPainter {
  _BubblePainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  final TabIndicator decoration;

  double get indicatorHeight => decoration.indicatorHeight;
  Color get indicatorColor => decoration.indicatorColor;
  double get indicatorRadius => decoration.indicatorRadius;
  EdgeInsetsGeometry get padding => decoration.padding;
  EdgeInsetsGeometry get insets => decoration.insets;
  TabBarIndicatorSize get tabBarIndicatorSize => decoration.tabBarIndicatorSize;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    Rect indicator = padding.resolve(textDirection).inflateRect(rect);

    if (tabBarIndicatorSize == TabBarIndicatorSize.tab) {
      indicator = insets.resolve(textDirection).deflateRect(rect);
    }

    return Rect.fromLTWH(
      indicator.left,
      indicator.top,
      indicator.width,
      indicator.height,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect =
        Offset(
          offset.dx,
          (configuration.size!.height / 2) - indicatorHeight / 2,
        ) &
        Size(configuration.size!.width, indicatorHeight);
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = _indicatorRectFor(rect, textDirection);
    final Paint paint = Paint();
    paint.color = indicatorColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(indicator, Radius.circular(indicatorRadius)),
      paint,
    );
  }
}
