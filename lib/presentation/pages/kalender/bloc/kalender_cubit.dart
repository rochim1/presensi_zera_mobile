import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';

// ─── State ──────────────────────────────────────────

class KalenderState extends Equatable {
  final bool isLoading;
  final List<KalenderEvent> events;
  final String? errorMessage;
  final DateTime focusedMonth;
  final DateTime? selectedDate;

  const KalenderState({
    this.isLoading = false,
    this.events = const [],
    this.errorMessage,
    required this.focusedMonth,
    this.selectedDate,
  });

  KalenderState copyWith({
    bool? isLoading,
    List<KalenderEvent>? events,
    String? errorMessage,
    DateTime? focusedMonth,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
  }) {
    return KalenderState(
      isLoading: isLoading ?? this.isLoading,
      events: events ?? this.events,
      errorMessage: errorMessage,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: clearSelectedDate
          ? null
          : (selectedDate ?? this.selectedDate),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    events,
    errorMessage,
    focusedMonth,
    selectedDate,
  ];
}

// ─── Cubit ──────────────────────────────────────────

class KalenderCubit extends Cubit<KalenderState> {
  final KalenderRemoteDatasource remoteDatasource;

  KalenderCubit({required this.remoteDatasource})
    : super(KalenderState(focusedMonth: DateTime.now()));

  Future<void> init() async {
    await fetchEvents();
  }

  Future<void> onMonthChanged(DateTime month) async {
    emit(state.copyWith(focusedMonth: month, clearSelectedDate: true));
    await fetchEvents();
  }

  Future<void> onDateSelected(DateTime selectedDay, DateTime focusedDay) async {
    // Toggle off if the same date is clicked
    if (state.selectedDate != null &&
        isSameDay(state.selectedDate, selectedDay)) {
      emit(state.copyWith(clearSelectedDate: true, focusedMonth: focusedDay));
    } else {
      emit(state.copyWith(selectedDate: selectedDay, focusedMonth: focusedDay));
    }
  }

  // helper method since isSameDay is from table_calendar
  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> fetchEvents() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final month = state.focusedMonth;
      // Fetch broader range to include events that span month boundaries
      final start = DateTime(month.year, month.month - 1, 1);
      final end = DateTime(month.year, month.month + 2, 0);

      final startStr =
          '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
      final endStr =
          '${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}';

      final events = await remoteDatasource.getEventsByDateRange(
        startStr,
        endStr,
      );
      emit(state.copyWith(isLoading: false, events: events));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<String?> createEvent(Map<String, dynamic> input) async {
    try {
      await remoteDatasource.createEvent(input);
      await fetchEvents();
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> updateEvent(String id, Map<String, dynamic> input) async {
    try {
      await remoteDatasource.updateEvent(id, input);
      await fetchEvents();
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> deleteEvent(String id) async {
    try {
      await remoteDatasource.deleteEvent(id);
      await fetchEvents();
      return null;
    } catch (error) {
      return error.toString();
    }
  }
}
