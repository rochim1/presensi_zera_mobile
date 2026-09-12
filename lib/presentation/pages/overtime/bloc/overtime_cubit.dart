import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'overtime_state.dart';

class OvertimeCubit extends Cubit<OvertimeState> {
  final Logger logger;

  OvertimeCubit({required this.logger}) : super(const OvertimeState());

  void onChangeFilterDate(DateTime? value) {
    emit(state.copyWith(filterDate: value));
  }

  void applyFilters({DateTime? startDate, DateTime? endDate, String? status}) {
    emit(
      state.copyWith(
        startDate: startDate,
        endDate: endDate,
        filterStatus: status,
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
