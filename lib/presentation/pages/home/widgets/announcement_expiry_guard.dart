import 'dart:async';
import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';

/// Rechecks expiry while visible and after returning from the background.
class AnnouncementExpiryGuard extends StatefulWidget {
  final List<Announcement> announcements;
  final Widget Function(BuildContext, List<Announcement>) builder;
  final void Function(List<Announcement>) onShown;
  final DateTime Function()? now;

  const AnnouncementExpiryGuard({
    super.key,
    required this.announcements,
    required this.builder,
    required this.onShown,
    this.now,
  });

  @override
  State<AnnouncementExpiryGuard> createState() =>
      _AnnouncementExpiryGuardState();
}

class _AnnouncementExpiryGuardState extends State<AnnouncementExpiryGuard>
    with WidgetsBindingObserver {
  Timer? _timer;
  late List<Announcement> _active;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _active = _valid();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _check());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _check();
      if (_active.isNotEmpty && ModalRoute.of(context)?.isCurrent == true) {
        widget.onShown(List.unmodifiable(_active));
      }
    });
  }

  List<Announcement> _valid() {
    final now = widget.now?.call() ?? DateTime.now();
    return widget.announcements.where((item) => item.isActiveAt(now)).toList();
  }

  void _check() {
    if (!mounted || _closing) return;
    final active = _valid();
    if (active.isEmpty) {
      _closing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final route = ModalRoute.of(context);
        if (route != null && route.isActive) {
          // Remove this popup only, even if another route is above it.
          Navigator.of(context).removeRoute(route);
        }
      });
      setState(() => _active = active);
    } else if (active.length != _active.length) {
      setState(() => _active = active);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _active.isEmpty
      ? const SizedBox.shrink()
      : widget.builder(context, _active);
}
