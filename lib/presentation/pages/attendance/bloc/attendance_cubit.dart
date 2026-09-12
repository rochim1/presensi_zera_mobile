import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final Logger logger;
  final GetAttendanceStatistics getAttendanceStatisticsUseCase;

  AttendanceCubit({
    required this.logger,
    required this.getAttendanceStatisticsUseCase,
  }) : super(const AttendanceState());

  void applyFilters({
    DateTime? startDate,
    DateTime? endDate,
    String? typePresensi,
    String? searchName,
  }) {
    emit(
      state.copyWith(
        startDate: startDate,
        endDate: endDate,
        typePresensi: typePresensi,
        searchName: searchName,
      ),
    );
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    if (state.startDate == null || state.endDate == null) return;

    emit(state.copyWith(statistics: const BaseState.loading()));

    final result = await getAttendanceStatisticsUseCase.call(
      GetAttendancesParams(startDate: state.startDate, endDate: state.endDate),
    );

    result.fold(
      (failure) {
        logger.e("AttendanceCubit.fetchStatistics failure: $failure");
        emit(state.copyWith(statistics: BaseState.failure(failure)));
      },
      (data) {
        emit(state.copyWith(statistics: BaseState.success(data)));
      },
    );
  }

  void init() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    applyFilters(startDate: startOfMonth, endDate: endOfMonth);
  }
}
