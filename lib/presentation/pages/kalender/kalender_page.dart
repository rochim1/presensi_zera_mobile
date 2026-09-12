import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

import 'bloc/kalender_cubit.dart';
import 'widgets/create_event_sheet.dart';

@RoutePage()
class KalenderPage extends StatelessWidget {
  const KalenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          KalenderCubit(remoteDatasource: sl<KalenderRemoteDatasource>())
            ..init(),
      child: const KalenderView(),
    );
  }
}

class KalenderView extends StatelessWidget {
  const KalenderView({super.key});

  static const _eventTypeColors = {
    'hari_libur_nasional': Color(0xFFdc3545),
    'hari_libur_perusahaan': Color(0xFFfd7e14),
    'cuti_bersama': Color(0xFFffc107),
    'event_perusahaan': Color(0xFF007bff),
    'lainnya': Color(0xFF6c757d),
  };

  static const _eventTypeLabels = {
    'hari_libur_nasional': 'Hari Libur Nasional',
    'hari_libur_perusahaan': 'Hari Libur Perusahaan',
    'cuti_bersama': 'Cuti Bersama',
    'event_perusahaan': 'Event Perusahaan',
    'lainnya': 'Lainnya',
  };

  Color _eventColor(KalenderEvent event) {
    if (event.color != null && event.color!.isNotEmpty) {
      try {
        final hex = event.color!.replaceFirst('#', '');
        return Color(int.parse('FF$hex', radix: 16));
      } catch (_) {}
    }
    return _eventTypeColors[event.eventType] ?? const Color(0xFFdc3545);
  }

  String _eventTypeLabel(String? type) {
    return _eventTypeLabels[type] ?? type ?? '-';
  }

  List<KalenderEvent> _getEventsForDay(
    List<KalenderEvent> allEvents,
    DateTime day,
  ) {
    final dayStr = DateFormat('yyyy-MM-dd').format(day);
    return allEvents.where((event) {
      final start = event.startDate;
      final end = event.endDate ?? event.startDate;
      return dayStr.compareTo(start) >= 0 && dayStr.compareTo(end) <= 0;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalenderCubit, KalenderState>(
      builder: (context, state) {
        final cubit = context.read<KalenderCubit>();
        final canCreateEvent = context.select<AppCubit, bool>(
          (appCubit) =>
              appCubit.state.user.data?.hasPermission(
                'kalender',
                action: 'create',
              ) ??
              false,
        );
        final canUpdateEvent = context.select<AppCubit, bool>(
          (cubit) =>
              cubit.state.user.data?.hasPermission(
                'kalender',
                action: 'update',
              ) ??
              false,
        );
        final canDeleteEvent = context.select<AppCubit, bool>(
          (cubit) =>
              cubit.state.user.data?.hasPermission(
                'kalender',
                action: 'delete',
              ) ??
              false,
        );

        return Scaffold(
          appBar: const AppTopBar(
            title: 'Kalender Kerja',
            backgroundColor: AppColors.transparent,
          ),
          floatingActionButton: canCreateEvent
              ? FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  shape: const CircleBorder(),
                  onPressed: () => CreateCalendarEventSheet.show(
                    context,
                    initialDate: state.selectedDate ?? DateTime.now(),
                    onSubmit: cubit.createEvent,
                  ),
                  child: const Icon(Icons.add, color: AppColors.white),
                )
              : null,
          body: Column(
            children: [
              // Calendar Widget
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppDimens.w12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppDimens.r16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TableCalendar<KalenderEvent>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: state.focusedMonth,
                  locale: 'id_ID',
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: context.textStyle.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.labelPrimary,
                    ),
                    leftChevronIcon: Icon(
                      PhosphorIcons.caretLeft,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    rightChevronIcon: Icon(
                      PhosphorIcons.caretRight,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: AppColors.danger),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 3,
                    markerSize: 6,
                    markerMargin: const EdgeInsets.symmetric(horizontal: 1),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    cubit.onDateSelected(selectedDay, focusedDay);
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(state.selectedDate, day);
                  },
                  eventLoader: (day) => _getEventsForDay(state.events, day),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return null;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: events.take(3).map((event) {
                          return Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _eventColor(event),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  onPageChanged: (focusedDay) {
                    cubit.onMonthChanged(focusedDay);
                  },
                ),
              ),

              SizedBox(height: AppDimens.h12),

              // Legend
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppDimens.w16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _eventTypeColors.entries.map((e) {
                      return Padding(
                        padding: EdgeInsets.only(right: AppDimens.w12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: e.value,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: AppDimens.w4),
                            Text(
                              _eventTypeLabels[e.key] ?? e.key,
                              style: context.textStyle.bodySmall?.copyWith(
                                color: AppColors.labelSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(height: AppDimens.h12),

              // Event List for current month
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildEventList(
                        context,
                        state,
                        cubit,
                        canUpdateEvent,
                        canDeleteEvent,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventList(
    BuildContext context,
    KalenderState state,
    KalenderCubit cubit,
    bool canUpdate,
    bool canDelete,
  ) {
    List<KalenderEvent> displayEvents;
    String emptyMessage;

    if (state.selectedDate != null) {
      displayEvents = _getEventsForDay(state.events, state.selectedDate!);
      final dateStr = DateFormat(
        'dd MMM yyyy',
        'id_ID',
      ).format(state.selectedDate!);
      emptyMessage = 'Tidak ada event pada $dateStr';
    } else {
      // Filter events that overlap with the focused month
      final month = state.focusedMonth;
      final monthStart = DateTime(month.year, month.month, 1);
      final monthEnd = DateTime(month.year, month.month + 1, 0);
      final monthStartStr = DateFormat('yyyy-MM-dd').format(monthStart);
      final monthEndStr = DateFormat('yyyy-MM-dd').format(monthEnd);

      displayEvents = state.events.where((event) {
        final start = event.startDate;
        final end = event.endDate ?? event.startDate;
        return start.compareTo(monthEndStr) <= 0 &&
            end.compareTo(monthStartStr) >= 0;
      }).toList();
      emptyMessage = 'Tidak ada event bulan ini';
    }

    displayEvents.sort((a, b) => a.startDate.compareTo(b.startDate));

    if (displayEvents.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 96;
          final icon = Icon(
            PhosphorIcons.calendarBlank,
            size: compact ? AppDimens.w24 : AppDimens.w48,
            color: AppColors.labelSecondary.withValues(alpha: 0.4),
          );
          final message = Flexible(
            child: Text(
              emptyMessage,
              style: context.textStyle.bodyMedium?.copyWith(
                color: AppColors.labelSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );

          return Center(
            child: compact
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        icon,
                        SizedBox(width: AppDimens.w8),
                        message,
                      ],
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      SizedBox(height: AppDimens.h12),
                      message,
                    ],
                  ),
          );
        },
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
      itemCount: displayEvents.length,
      separatorBuilder: (context, index) => SizedBox(height: AppDimens.h10),
      itemBuilder: (context, index) {
        final event = displayEvents[index];
        final color = _eventColor(event);

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimens.r12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimens.r12),
                      bottomLeft: Radius.circular(AppDimens.r12),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimens.w12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                style: context.textStyle.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.labelPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _eventTypeLabel(event.eventType),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (canUpdate || canDelete)
                              PopupMenuButton<String>(
                                tooltip: 'Aksi event',
                                onSelected: (action) async {
                                  if (action == 'edit') {
                                    await CreateCalendarEventSheet.show(
                                      context,
                                      initialDate:
                                          DateTime.tryParse(event.startDate) ??
                                          DateTime.now(),
                                      initialEvent: event,
                                      onSubmit: (input) =>
                                          cubit.updateEvent(event.id, input),
                                    );
                                    return;
                                  }
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      title: const Text('Hapus Event?'),
                                      content: Text(
                                        'Event "${event.title}" akan dihapus.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                            dialogContext,
                                            false,
                                          ),
                                          child: const Text('Batal'),
                                        ),
                                        FilledButton(
                                          onPressed: () => Navigator.pop(
                                            dialogContext,
                                            true,
                                          ),
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirmed != true) return;
                                  final error = await cubit.deleteEvent(
                                    event.id,
                                  );
                                  if (!context.mounted) return;
                                  if (error == null) {
                                    AppSnackbar.showSuccess(
                                      context,
                                      'Event berhasil dihapus',
                                    );
                                  } else {
                                    AppSnackbar.showError(
                                      context,
                                      'Gagal menghapus event: $error',
                                    );
                                  }
                                },
                                itemBuilder: (_) => [
                                  if (canUpdate)
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                  if (canDelete)
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Hapus'),
                                    ),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: AppDimens.h4),
                        Row(
                          children: [
                            Icon(
                              PhosphorIcons.calendarBlank,
                              size: 14,
                              color: AppColors.labelSecondary,
                            ),
                            SizedBox(width: AppDimens.w4),
                            Text(
                              _formatDateRange(event),
                              style: context.textStyle.bodySmall?.copyWith(
                                color: AppColors.labelSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        if (event.description != null &&
                            event.description!.isNotEmpty) ...[
                          SizedBox(height: AppDimens.h4),
                          Text(
                            event.description!,
                            style: context.textStyle.bodySmall?.copyWith(
                              color: AppColors.labelSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDateRange(KalenderEvent event) {
    try {
      final start = DateFormat('yyyy-MM-dd').parse(event.startDate);
      final startFormatted = DateFormat('dd MMM yyyy', 'id').format(start);

      if (event.endDate != null &&
          event.endDate!.isNotEmpty &&
          event.endDate != event.startDate) {
        final end = DateFormat('yyyy-MM-dd').parse(event.endDate!);
        final endFormatted = DateFormat('dd MMM yyyy', 'id').format(end);
        return '$startFormatted - $endFormatted';
      }

      return startFormatted;
    } catch (_) {
      return event.startDate;
    }
  }
}
