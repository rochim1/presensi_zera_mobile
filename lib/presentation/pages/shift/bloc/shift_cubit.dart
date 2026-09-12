import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

import 'shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  final Logger logger;

  ShiftCubit({required this.logger}) : super(const ShiftState());

  void onChangeFilterDate(DateTime? value) {
    emit(state.copyWith(filterDate: value));
  }

  void applyFilters({DateTime? startDate, DateTime? endDate}) {
    emit(
      state.copyWith(
        startDate: startDate,
        endDate: endDate,
        filterDate: startDate,
      ),
    );
  }

  void triggerRefresh() {
    emit(state.copyWith(refreshCounter: state.refreshCounter + 1));
  }

  void init() {
    onChangeFilterDate(DateTime.now());
  }
}
