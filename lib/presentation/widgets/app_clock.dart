import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/core/_core.dart';

/// A self-managed clock widget that displays the current time and (optionally) the date.
///
/// It uses an internal [Timer] to update the time every second, reducing the need
/// for external state management (like BloC/Cubit) to handle the clock's tick.
///
/// Example usage:
/// ```dart
/// const AppClock(
///   textAlign: TextAlign.start,
///   showDate: true,
/// )
/// ```
class AppClock extends StatefulWidget {
  /// How the time and date text should be aligned.
  final TextAlign textAlign;

  /// Whether to show the current date below the time.
  final bool showDate;

  const AppClock({
    super.key,
    this.textAlign = TextAlign.center,
    this.showDate = true,
  });

  @override
  State<AppClock> createState() => _AppClockState();
}

class _AppClockState extends State<AppClock> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : widget.textAlign == TextAlign.right
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('hh:mm:ss a').format(_currentTime),
          style: context.textStyle.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.labelPrimary,
            letterSpacing: 1,
          ),
          textAlign: widget.textAlign,
        ),
        if (widget.showDate)
          Text(
            DateFormat('EEEE, dd MMMM yyyy', 'id').format(_currentTime),
            style: context.textStyle.labelMedium?.copyWith(
              color: AppColors.labelSecondary,
            ),
            textAlign: widget.textAlign,
          ),
      ],
    );
  }
}
