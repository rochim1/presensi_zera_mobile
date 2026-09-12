import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'attendance_request_state.dart';

class AttendanceRequestCubit extends Cubit<AttendanceRequestState> {
  final Logger logger;

  AttendanceRequestCubit({required this.logger})
    : super(const AttendanceRequestState());

  void onChangeFilterDate(DateTime? value) {
    emit(state.copyWith(filterDate: value));
  }

  void applyFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? jenisRequest,
  }) {
    emit(
      state.copyWith(
        startDate: startDate,
        endDate: endDate,
        filterStatus: status,
        filterJenisRequest: jenisRequest,
        filterDate: startDate,
      ),
    );
  }

  void triggerRefresh() {
    emit(state.copyWith(refreshCounter: state.refreshCounter + 1));
  }

  void init() {
    final now = DateTime.now();
    applyFilters(
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 0),
    );
  }
}
