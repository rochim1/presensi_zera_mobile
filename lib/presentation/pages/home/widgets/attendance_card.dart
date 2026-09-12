import 'dart:async';

import 'package:action_slider/action_slider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class HomeAttendanceCard extends StatefulWidget {
  final VoidCallback? onTapActionButton;
  final VoidCallback? onTapSecondaryActionButton;
  final String actionButtonLabel;
  final String? secondaryActionButtonLabel;
  final String? overtimeStartTime;
  final Attendance? attendance;
  final EffectiveSchedule? effectiveSchedule;
  final Setting? setting;
  final bool isLoading;
  final bool isStartingOvertime;
  final bool hasCheckedOutToday;

  final String? sliderText;
  final Future<void> Function(ActionSliderController controller)?
  onSliderAction;
  final ActionSliderController? sliderController;

  const HomeAttendanceCard({
    super.key,
    this.onTapActionButton,
    this.onTapSecondaryActionButton,
    this.actionButtonLabel = 'Check In',
    this.secondaryActionButtonLabel,
    this.overtimeStartTime,
    this.sliderText,
    this.onSliderAction,
    this.sliderController,
    this.attendance,
    this.effectiveSchedule,
    this.setting,
    this.isLoading = false,
    this.isStartingOvertime = false,
    this.hasCheckedOutToday = false,
  });

  @override
  State<HomeAttendanceCard> createState() => _HomeAttendanceCardState();
}

class _HomeAttendanceCardState extends State<HomeAttendanceCard> {
  late DateTime _currentTime;
  late Timer _timer;
  final PageController _pageController = PageController();
  int _currentSlide = 0;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _currentTime = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// Safely parse a "HH:mm" (or "HH:mm:ss") time string into hour/minute.
  /// Returns null if the format is invalid (e.g. "In", "Out", etc.).
  ({int hour, int minute})? _parseTime(String? value) {
    if (value == null || value.length < 5) return null;
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(value);
    if (match == null) return null;
    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    if (hour == null || minute == null) return null;
    return (hour: hour, minute: minute);
  }

  String _getTargetKerja() {
    DateTime? start;
    DateTime? end;

    if (widget.effectiveSchedule != null) {
      final sParsed = _parseTime(widget.effectiveSchedule!.effectiveJamMasuk);
      final eParsed = _parseTime(widget.effectiveSchedule!.effectiveJamPulang);
      if (sParsed != null && eParsed != null) {
        start = DateTime(2020, 1, 1, sParsed.hour, sParsed.minute);
        end = DateTime(2020, 1, 1, eParsed.hour, eParsed.minute);
      }
    } else if (widget.setting != null) {
      final s = widget.setting!.jamMasuk;
      final e = widget.setting!.jamPulang;
      if (s != null && e != null) {
        start = DateTime(2020, 1, 1, s.hour, s.minute);
        end = DateTime(2020, 1, 1, e.hour, e.minute);
      }
    }

    if (start != null && end != null) {
      if (end.isBefore(start)) end = end.add(const Duration(days: 1));
      final diff = end.difference(start);
      return '${diff.inHours} Jam ${diff.inMinutes.remainder(60)} Menit';
    }
    return '--';
  }

  String _getSisaWaktu() {
    DateTime? end;
    if (widget.effectiveSchedule != null) {
      final eParsed = _parseTime(widget.effectiveSchedule!.effectiveJamPulang);
      if (eParsed != null) {
        final now = DateTime.now();
        end = DateTime(
          now.year,
          now.month,
          now.day,
          eParsed.hour,
          eParsed.minute,
        );
      }
    } else if (widget.setting?.jamPulang != null) {
      final e = widget.setting!.jamPulang!;
      final now = DateTime.now();
      end = DateTime(now.year, now.month, now.day, e.hour, e.minute);
    }

    if (end != null) {
      final now = DateTime.now();
      if (now.isAfter(end)) return 'Waktu Selesai';
      final diff = end.difference(now);
      return '${diff.inHours} Jam ${diff.inMinutes.remainder(60)} Menit';
    }
    return '--';
  }

  Widget _buildDetailItem(
    IconData icon,
    Color iconColor,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 11, color: AppColors.labelSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmer.box(width: 80, height: 12),
                      const SizedBox(height: 8),
                      AppShimmer.box(width: 120, height: 32),
                      const SizedBox(height: 4),
                      AppShimmer.box(width: 140, height: 12),
                    ],
                  ),
                ),
                AppShimmer.box(width: 100, height: 44, radius: 18),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppShimmer.box(
                    width: double.infinity,
                    height: 60,
                    radius: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppShimmer.box(
                    width: double.infinity,
                    height: 60,
                    radius: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppShimmer.box(
                    width: double.infinity,
                    height: 60,
                    radius: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppShimmer.box(
                    width: double.infinity,
                    height: 60,
                    radius: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppShimmer.box(width: double.infinity, height: 56, radius: 28),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Clock + Check In Button ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Expanded(child: _buildClock(context)),
                const SizedBox(width: 16),
                _buildCheckButton(context),
              ],
            ),
          ),

          // ── Status & Type ──
          if (widget.attendance != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(bottom: 16),
              child: Row(
                children: [
                  AppChip(
                    label: widget.attendance!.type.toName,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  AppChip(
                    label: widget.attendance!.status.toDisplayName,
                    color: widget.attendance!.status.toDisplayColor,
                  ),
                ],
              ),
            ),
          // 🕒 Info & Schedule PageView 🕒
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _currentSlide == 0 ? 90 : 135,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentSlide = index);
              },
              children: [
                // Slide 1: Check In & Check Out
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildCheckStatus(
                                context,
                                label: 'Check In',
                                time:
                                    widget.attendance?.jamMasuk?.format(
                                      pattern: 'HH:mm',
                                    ) ??
                                    '--:--',
                                subtitle: widget.attendance?.jamMasuk != null
                                    ? 'Sudah Check In'
                                    : 'Belum Check In',
                                icon: PhosphorIcons.signInFill,
                                color: const Color(0xFF0F8B6D),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildCheckStatus(
                                context,
                                label: 'Check Out',
                                time:
                                    widget.attendance?.jamPulang?.format(
                                      pattern: 'HH:mm',
                                    ) ??
                                    '--:--',
                                subtitle: widget.attendance?.jamPulang != null
                                    ? 'Sudah Check Out'
                                    : 'Belum Check Out',
                                icon: PhosphorIcons.signOutFill,
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Slide 2: Detailed Info View (Grid)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                    ),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailItem(
                                  PhosphorIcons.clockClockwiseFill,
                                  const Color(0xFF0F8B6D),
                                  'Jadwal Masuk',
                                  widget.effectiveSchedule != null
                                      ? _parseTime(
                                                  widget
                                                      .effectiveSchedule!
                                                      .effectiveJamMasuk,
                                                ) !=
                                                null
                                            ? '${_parseTime(widget.effectiveSchedule!.effectiveJamMasuk)!.hour.toString().padLeft(2, '0')}:${_parseTime(widget.effectiveSchedule!.effectiveJamMasuk)!.minute.toString().padLeft(2, '0')}'
                                            : '--:--'
                                      : widget.setting?.jamMasuk?.format(
                                              pattern: 'HH:mm',
                                            ) ??
                                            '--:--',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildDetailItem(
                                  PhosphorIcons.clockCounterClockwiseFill,
                                  const Color(0xFFE8890C),
                                  'Jadwal Pulang',
                                  widget.effectiveSchedule != null
                                      ? _parseTime(
                                                  widget
                                                      .effectiveSchedule!
                                                      .effectiveJamPulang,
                                                ) !=
                                                null
                                            ? '${_parseTime(widget.effectiveSchedule!.effectiveJamPulang)!.hour.toString().padLeft(2, '0')}:${_parseTime(widget.effectiveSchedule!.effectiveJamPulang)!.minute.toString().padLeft(2, '0')}'
                                            : '--:--'
                                      : widget.setting?.jamPulang?.format(
                                              pattern: 'HH:mm',
                                            ) ??
                                            '--:--',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailItem(
                                  PhosphorIcons.targetFill,
                                  const Color(0xFF0F8B6D),
                                  'Target Kerja',
                                  _getTargetKerja(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildDetailItem(
                                  PhosphorIcons.hourglassFill,
                                  const Color(0xFFE8890C),
                                  'Sisa Waktu',
                                  _getSisaWaktu(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Pagination Dots
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: _currentSlide == index ? 16 : 6,
                decoration: BoxDecoration(
                  color: _currentSlide == index
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 4),

          // ── Slider ──
          if (widget.attendance != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: AppActionSlider(
                  enabled: widget.attendance != null,
                  text: widget.sliderText ?? 'Geser untuk Presensi',
                  onAction: widget.onSliderAction ?? (c) {},
                  controller: widget.sliderController,
                ),
              ),
            )
          else
            const SizedBox(height: 16),

          // ── Today's Attendance Log Button ──
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.router.push(const TodayAttendancePageRoute());
              },
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      PhosphorIcons.listBullets,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Log Presensi Hari Ini',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClock(BuildContext context) {
    final timeStr = DateFormat('HH:mm:ss').format(_currentTime);
    final period = DateFormat('a').format(_currentTime).toUpperCase();
    final dateStr = DateFormat('EEEE, dd MMMM yyyy', 'id').format(_currentTime);
    final greeting = switch (_currentTime.hour) {
      >= 5 && < 10 => 'Pagi',
      >= 10 && < 15 => 'Siang',
      >= 15 && < 18 => 'Sore',
      _ => 'Malam',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, Waktu Saat Ini',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.labelSecondary,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.bottomLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeStr,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1E1E),
                  letterSpacing: -1,
                  height: 1.1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.labelSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          dateStr,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.labelSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCheckButton(BuildContext context) {
    final isCheckOut = widget.attendance != null;
    final hasOngoingAttendance =
        widget.attendance != null && widget.attendance!.jamPulang == null;
    final isCompleted =
        !hasOngoingAttendance &&
        widget.attendance != null &&
        widget.attendance!.jamPulang != null;
    final isJustCheckOut = isCheckOut && !isCompleted;
    final isCheckInAfterCompleted =
        isCompleted && widget.actionButtonLabel == 'Check In';

    final isLembur =
        widget.actionButtonLabel == 'Mulai Lembur' ||
        widget.actionButtonLabel == 'Akhiri Lembur';

    final String statusText;
    final attendanceStatus = widget.attendance?.status;
    if (widget.overtimeStartTime != null) {
      statusText = 'Sedang Lembur';
    } else if (attendanceStatus?.isIstirahat == true) {
      statusText = 'Sedang Istirahat';
    } else if (attendanceStatus?.isKerja == true && hasOngoingAttendance) {
      statusText = 'Sedang Kerja';
    } else if (attendanceStatus?.isPulang == true || isCompleted) {
      statusText = 'Sudah Pulang';
    } else if (hasOngoingAttendance) {
      statusText = 'Sesi Presensi Aktif';
    } else if (widget.hasCheckedOutToday) {
      statusText = 'Sudah Presensi hari ini';
    } else {
      statusText = 'Belum Check In hari ini';
    }

    final gradientColors = isLembur
        ? [AppColors.warning, AppColors.orange]
        : isCompleted && !isCheckInAfterCompleted
        ? [AppColors.grey, AppColors.grey]
        : isJustCheckOut
        ? [AppColors.red, AppColors.pink]
        : [AppColors.primary, AppColors.secondary];

    final shadowColor = isLembur
        ? AppColors.warning
        : (isCompleted && !isCheckInAfterCompleted
              ? AppColors.grey
              : (isJustCheckOut ? AppColors.red : AppColors.primary));

    return Column(
      children: [
        _buildPrimaryActionButton(
          gradientColors: gradientColors,
          shadowColor: shadowColor,
          isCheckOut: widget.actionButtonLabel == 'Check Out',
        ),
        if (widget.overtimeStartTime != null) ...[
          const SizedBox(height: 6),
          _buildOvertimeTimer(),
        ],
        if (widget.secondaryActionButtonLabel != null &&
            widget.onTapSecondaryActionButton != null) ...[
          const SizedBox(height: 8),
          _buildSecondaryActionButton(),
        ],
        const SizedBox(height: 6),
        Text(
          statusText,
          style: TextStyle(fontSize: 11, color: AppColors.labelSecondary),
        ),
      ],
    );
  }

  Widget _buildPrimaryActionButton({
    required List<Color> gradientColors,
    required Color shadowColor,
    required bool isCheckOut,
  }) {
    final showLoading =
        widget.isStartingOvertime && widget.actionButtonLabel == 'Mulai Lembur';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.isStartingOvertime ? null : widget.onTapActionButton,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                Icon(
                  isCheckOut
                      ? PhosphorIcons.signOutFill
                      : PhosphorIcons.signInFill,
                  color: Colors.white,
                  size: 18,
                ),
              const SizedBox(width: 8),
              Text(
                showLoading ? 'Memulai...' : widget.actionButtonLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOvertimeTimer() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final start = DateTime.parse(widget.overtimeStartTime!);
        final diff = DateTime.now().difference(start);
        final hours = diff.inHours.toString().padLeft(2, '0');
        final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');

        return Text(
          '$hours:$minutes:$seconds',
          style: TextStyle(
            color: AppColors.warning,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        );
      },
    );
  }

  Widget _buildSecondaryActionButton() {
    final showLoading =
        widget.isStartingOvertime &&
        widget.secondaryActionButtonLabel == 'Mulai Lembur';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.isStartingOvertime
            ? null
            : widget.onTapSecondaryActionButton,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.warning.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.warning,
                  ),
                )
              else
                Icon(
                  PhosphorIcons.timerFill,
                  color: AppColors.warning,
                  size: 16,
                ),
              const SizedBox(width: 6),
              Text(
                showLoading ? 'Memulai...' : widget.secondaryActionButtonLabel!,
                style: TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildStandardTimeChip(
    BuildContext context, {
    required String label,
    required String time,
    required String suffix,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.labelSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        suffix,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.labelSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckStatus(
    BuildContext context, {
    required String label,
    required String time,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.labelSecondary,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.labelSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
