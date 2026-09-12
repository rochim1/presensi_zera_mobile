import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/service/_service.dart';

import 'attendance_detail_state.dart';

class AttendanceDetailCubit extends Cubit<AttendanceDetailState> {
  final GetAttendanceById getAttendanceByIdUseCase;
  final LocationService locationService;
  final Logger logger;

  AttendanceDetailCubit({
    required this.getAttendanceByIdUseCase,
    required this.logger,
    required this.locationService,
  }) : super(const AttendanceDetailState());

  Future<void> getAttendance() async {
    if (state.attendanceId.isEmpty) return;
    if (state.attendance.isLoading) return;
    emit(state.copyWith(attendance: BaseState.loading()));

    final result = await getAttendanceByIdUseCase.call(state.attendanceId);

    result.fold(
      (failure) {
        emit(state.copyWith(attendance: BaseState.failure(failure)));
      },
      (value) {
        emit(state.copyWith(attendance: BaseState.success(value)));
        _getCheckInAddress();
        _getCheckOutAddress();
      },
    );
  }

  Future<void> _getCheckInAddress() async {
    try {
      final attendance = state.attendance.data;
      if (attendance == null) return;
      final location = attendance.locationCheckIn;
      if (location == null) return;
      emit(state.copyWith(checkInAddress: BaseState.loading()));

      final address = await _getAddress(location);

      emit(state.copyWith(checkInAddress: BaseState.success(address)));
    } on LocationFailure catch (e) {
      logger.e("CheckInCubit.getCurrentLocation, $e");
      emit(state.copyWith(checkInAddress: BaseState.failure(e)));
    } catch (e) {
      logger.e("CheckInCubit.getCurrentLocation, $e");
      emit(state.copyWith(checkInAddress: BaseState.failure(UnknownFailure())));
    }
  }

  Future<void> _getCheckOutAddress() async {
    try {
      final attendance = state.attendance.data;
      if (attendance == null) return;
      final location = attendance.locationCheckOut;
      if (location == null) return;
      emit(state.copyWith(checkOutAddress: BaseState.loading()));

      final address = await _getAddress(location);

      emit(state.copyWith(checkOutAddress: BaseState.success(address)));
    } on LocationFailure catch (e) {
      logger.e("CheckInCubit.getCurrentLocation, $e");
      emit(state.copyWith(checkOutAddress: BaseState.failure(e)));
    } catch (e) {
      logger.e("CheckInCubit.getCurrentLocation, $e");
      emit(
        state.copyWith(checkOutAddress: BaseState.failure(UnknownFailure())),
      );
    }
  }

  Future<AppAddress> _getAddress(AppLocation location) {
    return locationService.getAddressByLocation(location);
  }

  void setAttendanceId(String value) {
    emit(state.copyWith(attendanceId: value));
  }

  void init(String attendanceId) {
    setAttendanceId(attendanceId);
    getAttendance();
  }

  Future<void> onRefresh() async {
    await getAttendance();
  }
}
