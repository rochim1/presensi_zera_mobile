import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class LeaveRequestDetailView extends StatefulWidget {
  final LeaveRequest request;
  const LeaveRequestDetailView({super.key, required this.request});

  @override
  State<LeaveRequestDetailView> createState() => _LeaveRequestDetailViewState();
}

class _LeaveRequestDetailViewState extends State<LeaveRequestDetailView> {
  LeaveRequest get request => widget.request;
  late final Future<_LeaveCalendarContext> _calendarContext;

  @override
  void initState() {
    super.initState();
    _calendarContext = _loadCalendarContext();
  }

  Future<_LeaveCalendarContext> _loadCalendarContext() async {
    final start = request.tanggalIzin;
    final end = request.tanggalMasuk;
    if (start == null || end == null || end.isBefore(start)) {
      return const _LeaveCalendarContext();
    }
    final results = await Future.wait<dynamic>([
      sl<KalenderRemoteDatasource>().getEventsByDateRange(
        DateFormat('yyyy-MM-dd').format(start),
        DateFormat('yyyy-MM-dd').format(end),
      ),
      sl<ShiftRemoteDatasource>().getShiftSchedules(
        GetShiftSchedulesRequest(
          userId: request.user.id,
          startDate: start.subtract(const Duration(days: 31)),
          endDate: end.add(const Duration(days: 31)),
        ),
      ),
    ]);
    return _LeaveCalendarContext(
      events: results[0] as List<KalenderEvent>,
      schedules: results[1] as List<ShiftScheduleResponse>,
    );
  }

  String _formatDate(DateTime dt) =>
      DateFormat("dd MMM yyyy", "id_ID").format(dt);

  int get _calendarDays {
    final start = request.tanggalIzin;
    final end = request.tanggalMasuk;
    if (start == null || end == null || end.isBefore(start)) return 0;
    return DateUtils.dateOnly(
          end,
        ).difference(DateUtils.dateOnly(start)).inDays +
        1;
  }

  Set<DateTime> _configuredHolidayDates(List<KalenderEvent> events) {
    const holidayTypes = {
      'hari_libur_nasional',
      'hari_libur_perusahaan',
      'cuti_bersama',
    };
    final leaveStart = request.tanggalIzin == null
        ? null
        : DateUtils.dateOnly(request.tanggalIzin!);
    final leaveEnd = request.tanggalMasuk == null
        ? null
        : DateUtils.dateOnly(request.tanggalMasuk!);
    if (leaveStart == null || leaveEnd == null) return {};

    final dates = <DateTime>{};
    for (final event in events.where(
      (item) => holidayTypes.contains(item.eventType),
    )) {
      final eventStart = DateTime.tryParse(event.startDate);
      final eventEnd = DateTime.tryParse(event.endDate ?? event.startDate);
      if (eventStart == null || eventEnd == null) continue;
      var date = DateUtils.dateOnly(eventStart);
      final lastDate = DateUtils.dateOnly(eventEnd);
      while (!date.isAfter(lastDate)) {
        if (!date.isBefore(leaveStart) && !date.isAfter(leaveEnd)) {
          dates.add(date);
        }
        date = date.add(const Duration(days: 1));
      }
    }
    return dates;
  }

  double _workingDays(
    Set<DateTime> holidays,
    List<ShiftScheduleResponse> schedules,
  ) {
    final start = request.tanggalIzin;
    final end = request.tanggalMasuk;
    if (start == null || end == null || end.isBefore(start)) return 0;
    final scheduledDates = schedules
        .where((item) => item.assignedDate != null)
        .map((item) => DateUtils.dateOnly(item.assignedDate!))
        .toSet();
    final isShiftBased = schedules.isNotEmpty;
    if (request.isHalfDay == true) {
      final date = DateUtils.dateOnly(start);
      final isWeekend =
          date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
      final isWorkingDay = isShiftBased
          ? scheduledDates.contains(date)
          : !isWeekend && !holidays.contains(date);
      return isWorkingDay ? 0.5 : 0;
    }

    var count = 0;
    var date = DateUtils.dateOnly(start);
    final lastDate = DateUtils.dateOnly(end);
    while (!date.isAfter(lastDate)) {
      final isWeekend =
          date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
      final isWorkingDay = isShiftBased
          ? scheduledDates.contains(date)
          : !isWeekend && !holidays.contains(date);
      if (isWorkingDay) count++;
      date = date.add(const Duration(days: 1));
    }
    return count.toDouble();
  }

  String _dayCountLabel(num value) {
    if (value == 0.5) return '0,5 hari';
    return '${value.toInt()} hari';
  }

  String get _durationLabel {
    if (request.isHalfDay == true) return '0,5 hari';
    return '$_calendarDays hari';
  }

  @override
  Widget build(BuildContext context) {
    final color = request.status.toDisplayColor;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppUserInfoTile(
                  user: request.user,
                  color: color,
                  avatarSize: AppDimens.w56,
                  subtitle:
                      request.category?.name ?? 'Kategori tidak diketahui',
                  padding: EdgeInsets.zero,
                ),
              ),
              SizedBox(width: AppDimens.w12),
              AppChip(
                label: request.status.toDisplayName,
                color: color,
                borderRadius: AppDimens.r24,
              ),
            ],
          ),
          SizedBox(height: AppDimens.h16),
          _sectionCard(
            context,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppDimens.w96,
                  child: Text('Alasan Cuti', style: _labelStyle(context)),
                ),
                Expanded(
                  child: Text(
                    request.alasan.isNotEmpty ? request.alasan : '-',
                    style: context.textStyle.bodyMedium?.copyWith(
                      color: AppColors.labelPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimens.h12),
          _sectionCard(
            context,
            title: 'Informasi Cuti',
            child: _buildLeaveSummary(context, color),
          ),
          if (request.fileIzin != null && request.fileIzin!.isNotEmpty) ...[
            SizedBox(height: AppDimens.h12),
            _sectionCard(
              context,
              title: 'Lampiran',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppDimens.r10),
                  onTap: () => context.router.push(
                    InAppBrowserPageRoute(url: request.fileIzin!),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppDimens.h4),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppDimens.w10),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(AppDimens.r10),
                          ),
                          child: Icon(
                            PhosphorIcons.filePdf,
                            color: AppColors.danger,
                          ),
                        ),
                        SizedBox(width: AppDimens.w12),
                        Expanded(
                          child: Text(
                            'Lampiran Bukti',
                            style: context.textStyle.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          PhosphorIcons.downloadSimple,
                          color: AppColors.labelSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (request.tanggalPengajuan != null) ...[
            SizedBox(height: AppDimens.h12),
            _sectionCard(
              context,
              child: _infoRow(
                context,
                icon: PhosphorIcons.calendarCheck,
                label: 'Tanggal Pengajuan',
                value: _formatDate(request.tanggalPengajuan!),
              ),
            ),
          ],
          if (request.approvalHistory != null) ...[
            SizedBox(height: AppDimens.h12),
            _sectionCard(
              context,
              child: AppApprovalHistory(history: request.approvalHistory!),
            ),
          ],
        ],
      ),
    );
  }

  TextStyle? _labelStyle(BuildContext context) => context.textStyle.bodySmall
      ?.copyWith(color: AppColors.labelSecondary, fontWeight: FontWeight.w600);

  Widget _sectionCard(
    BuildContext context, {
    String? title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.r12),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimens.w12,
                AppDimens.h10,
                AppDimens.w12,
                AppDimens.h10,
              ),
              child: Text(
                title,
                style: context.textStyle.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.dividerLight),
          ],
          Padding(padding: EdgeInsets.all(AppDimens.w12), child: child),
        ],
      ),
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: AppDimens.iconMedium),
        SizedBox(width: AppDimens.w12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: _labelStyle(context)),
              SizedBox(height: AppDimens.h2),
              Text(
                value,
                style: context.textStyle.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveSummary(BuildContext context, Color color) {
    final halfDayDescription = request.isHalfDay == true
        ? ' (${request.halfDayType?.toUpperCase() ?? '-'})'
        : '';

    return FutureBuilder<_LeaveCalendarContext>(
      future: _calendarContext,
      builder: (context, snapshot) {
        final holidays = snapshot.hasData
            ? _configuredHolidayDates(snapshot.data!.events)
            : null;
        final workingDays = holidays == null
            ? null
            : _workingDays(holidays, snapshot.data!.schedules);
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _summaryItem(
                    context,
                    label: 'Tanggal Izin',
                    value: request.tanggalIzin == null
                        ? '-'
                        : _formatDate(request.tanggalIzin!),
                    icon: PhosphorIcons.calendarBlank,
                    color: color,
                  ),
                ),
                SizedBox(width: AppDimens.w10),
                Expanded(
                  child: _summaryItem(
                    context,
                    label: 'Tanggal Masuk',
                    value: request.tanggalMasuk == null
                        ? '-'
                        : _formatDate(request.tanggalMasuk!),
                    icon: PhosphorIcons.calendarCheck,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimens.h10),
            const Divider(height: 1, color: AppColors.dividerLight),
            SizedBox(height: AppDimens.h10),
            Row(
              children: [
                Expanded(
                  child: _summaryItem(
                    context,
                    label: 'Total Durasi',
                    value: '$_durationLabel$halfDayDescription',
                    icon: PhosphorIcons.timer,
                    color: color,
                  ),
                ),
                SizedBox(width: AppDimens.w10),
                Expanded(
                  child: _summaryItem(
                    context,
                    label: 'Hari Kerja',
                    value: workingDays == null
                        ? (isLoading ? 'Memuat...' : '-')
                        : _dayCountLabel(workingDays),
                    icon: PhosphorIcons.briefcase,
                    color: color,
                  ),
                ),
                SizedBox(width: AppDimens.w10),
                Expanded(
                  child: _summaryItem(
                    context,
                    label: 'Hari Libur',
                    value: holidays == null
                        ? (isLoading ? 'Memuat...' : '-')
                        : '${holidays.length} hari',
                    icon: PhosphorIcons.coffee,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _summaryItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: AppDimens.w14, color: color),
            SizedBox(width: AppDimens.w4),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.bodySmall?.copyWith(
                  color: AppColors.labelSecondary,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimens.h4),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textStyle.bodySmall?.copyWith(
            color: AppColors.labelPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LeaveCalendarContext {
  final List<KalenderEvent> events;
  final List<ShiftScheduleResponse> schedules;

  const _LeaveCalendarContext({
    this.events = const [],
    this.schedules = const [],
  });
}
