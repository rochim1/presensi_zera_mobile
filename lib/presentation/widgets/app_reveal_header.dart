import 'package:flutter/material.dart';

class AppRevealHeader extends StatefulWidget {
  final ScrollController controller;
  final double triggerOffset;
  final Duration duration;
  final Widget child;

  const AppRevealHeader({
    super.key,
    required this.controller,
    required this.child,
    this.triggerOffset = 80,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<AppRevealHeader> createState() => _AppRevealHeaderState();
}

class _AppRevealHeaderState extends State<AppRevealHeader> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = widget.controller.offset;

    if (offset > widget.triggerOffset && !_visible) {
      setState(() => _visible = true);
    } else if (offset <= widget.triggerOffset && _visible) {
      setState(() => _visible = false);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: widget.duration,
      curve: Curves.easeOut,
      offset: _visible ? Offset.zero : const Offset(0, -1),
      child: widget.child,
    );
  }
}
