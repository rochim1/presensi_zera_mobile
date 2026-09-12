import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import '../formz/_formz.dart';
import 'request_state.dart';

class AttendanceRequestFormCubit extends Cubit<AttendanceRequestFormState> {
  final GetShiftSchedules getShiftSchedulesUseCase;
  final CreateAttendanceRequest createAttendanceRequestUseCase;
  final Logger logger;
  final AttendanceRequestRepository repository;
  AttendanceRequest? _request;

  AttendanceRequestFormCubit({
    required this.logger,
    required this.getShiftSchedulesUseCase,
    required this.createAttendanceRequestUseCase,
    required this.repository,
  }) : super(const AttendanceRequestFormState());

  String? _constructAttendanceTime(AttendanceRequestFormInputs form) {
    final checkIn = form.checkInTime.value;
    final checkOut = form.checkOutTime.value;
    final formatPattern = 'HH:mm';
    final checkInFormatted = checkIn?.format(pattern: formatPattern);
    final checkOutFormatted = checkOut?.format(pattern: formatPattern);

    if (checkIn != null && checkOut != null) {
      return 'Masuk: $checkInFormatted, Pulang: $checkOutFormatted';
    }

    if (checkIn != null) {
      return checkInFormatted;
    }

    return null;
  }

  void submit() async {
    final form = state.form.copyWith(
      attendanceType: AttendanceTypeInput.dirty(
        state.form.attendanceType.value,
      ),
      attendanceRequestType: AttendanceRequestTypeInput.dirty(
        state.form.attendanceRequestType.value,
      ),
      attendanceDate: AttendanceDateInput.dirty(
        state.form.attendanceDate.value,
      ),
      checkInTime: CheckInTimeInput.dirty(state.form.checkInTime.value),
      checkOutTime: CheckOutTimeInput.dirty(state.form.checkOutTime.value),
      reason: ReasonInput.dirty(state.form.reason.value),
      attachments: AttachmentsInput.dirty(state.form.attachments.value),
      shiftSchedule: ShiftScheduleInput.dirty(
        state.form.shiftSchedule.value,
        attendanceType: state.form.attendanceType.value,
        attendanceDate: state.form.attendanceDate.value,
      ),
    );
    emit(state.copyWith(form: form));

    if (!form.isValid) return;

    emit(state.copyWith(submit: BaseState.loading()));

    late final List<MultipartFile> attachments;
    try {
      attachments = form.attachments.value
          .map(AppUtility.toPickedMultipartFile)
          .toList();
    } on Failure catch (failure) {
      emit(state.copyWith(submit: BaseState.failure(failure)));
      return;
    }

    final params = CreateAttendanceRequestParams(
      attendanceDate: form.attendanceDate.value,
      attendanceType: form.attendanceType.value,
      attachments: attachments,
      attendanceRequestType: form.attendanceRequestType.value,
      attendanceTime: _constructAttendanceTime(form),
      reason: form.reason.value,
      shiftId: form.shiftSchedule.value?.id,
    );
    final result = _request == null
        ? await createAttendanceRequestUseCase.call(params)
        : await repository.updateAttendanceRequest(_request!.id, params);

    result.fold(
      (failure) {
        emit(state.copyWith(submit: BaseState.failure(failure)));
      },
      (_) {
        emit(state.copyWith(submit: BaseState.success(null)));
      },
    );
  }

  void onChangeAttendanceType(AttendanceType? value) {
    final form = state.form.copyWith(
      attendanceType: AttendanceTypeInput.dirty(value),
      shiftSchedule: ShiftScheduleInput.dirty(
        null,
        attendanceType: value,
        attendanceDate: state.form.attendanceDate.value,
      ),
    );

    emit(state.copyWith(form: form));

    if (form.shiftSchedule.isRequired) {
      getShiftSchedule();
    }
  }

  void onChangeAttendanceRequestType(AttendanceRequestType? value) {
    final form = state.form.copyWith(
      attendanceRequestType: AttendanceRequestTypeInput.dirty(value),
      checkInTime: CheckInTimeInput.dirty(
        state.form.checkInTime.value,
        attendanceRequestType: value,
      ),
      checkOutTime: CheckOutTimeInput.dirty(
        state.form.checkOutTime.value,
        attendanceRequestType: value,
      ),
    );

    emit(state.copyWith(form: form));
  }

  void onChangeAttendanceDate(DateTime? value) async {
    final form = state.form.copyWith(
      attendanceDate: AttendanceDateInput.dirty(value),
      shiftSchedule: ShiftScheduleInput.dirty(
        null,
        attendanceType: state.form.attendanceType.value,
        attendanceDate: value,
      ),
    );

    emit(state.copyWith(form: form));

    if (form.shiftSchedule.isRequired) {
      getShiftSchedule();
    }
  }

  void onChangeCheckInTime(DateTime? value) {
    final form = state.form.copyWith(
      checkInTime: CheckInTimeInput.dirty(
        value,
        attendanceRequestType: state.form.attendanceRequestType.value,
      ),
    );

    emit(state.copyWith(form: form));
  }

  void onChangeCheckOutTime(DateTime? value) {
    final form = state.form.copyWith(
      checkOutTime: CheckOutTimeInput.dirty(
        value,
        attendanceRequestType: state.form.attendanceRequestType.value,
      ),
    );

    emit(state.copyWith(form: form));
  }

  void onChangeReason(String? value) {
    final form = state.form.copyWith(reason: ReasonInput.dirty(value));
    emit(state.copyWith(form: form));
  }

  void onChangeAttachments(List<PlatformFile> value) {
    final form = state.form.copyWith(
      attachments: AttachmentsInput.dirty(value),
    );

    emit(state.copyWith(form: form));
  }

  void onChangeShiftSchedule(ShiftSchedule? value) {
    final form = state.form.copyWith(
      shiftSchedule: ShiftScheduleInput.dirty(
        value,
        attendanceType: state.form.attendanceType.value,
        attendanceDate: state.form.attendanceDate.value,
      ),
    );

    emit(state.copyWith(form: form));
  }

  void getShiftSchedule() async {
    final attendanceDate = state.form.attendanceDate;
    if (attendanceDate.isNotValid) return;

    emit(state.copyWith(shiftSchedules: BaseState.loading()));

    final params = GetShiftSchedulesParams(
      startDate: attendanceDate.value?.startOfDay,
      endDate: attendanceDate.value?.endOfDay,
    );
    final result = await getShiftSchedulesUseCase.call(params);

    result.fold(
      (failure) {
        emit(state.copyWith(shiftSchedules: BaseState.failure(failure)));
      },
      (value) {
        emit(state.copyWith(shiftSchedules: BaseState.success(value)));
      },
    );
  }

  DateTime? _timeFromRequest(String source, int index) {
    final values = RegExp(
      r'\d{2}:\d{2}',
    ).allMatches(source).map((m) => m.group(0)!).toList();
    if (values.length <= index) return null;
    final parts = values[index].split(':');
    return DateTime(2000, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
  }

  void init([Attendance? attendance, AttendanceRequest? request]) {
    _request = request;
    if (request != null) {
      emit(
        state.copyWith(
          form: state.form.copyWith(
            attendanceType: const AttendanceTypeInput.dirty(
              AttendanceType.daily,
            ),
            attendanceRequestType: AttendanceRequestTypeInput.dirty(
              request.type,
            ),
            attendanceDate: AttendanceDateInput.dirty(request.tanggalPresensi),
            checkInTime: CheckInTimeInput.dirty(
              _timeFromRequest(request.waktuYangDiminta, 0),
              attendanceRequestType: request.type,
            ),
            checkOutTime: CheckOutTimeInput.dirty(
              _timeFromRequest(request.waktuYangDiminta, 1),
              attendanceRequestType: request.type,
            ),
            reason: ReasonInput.dirty(request.alasan),
          ),
        ),
      );
      return;
    }
    if (attendance != null) {
      final form = state.form.copyWith(
        attendanceDate: AttendanceDateInput.dirty(attendance.date),
        attendanceType: AttendanceTypeInput.dirty(attendance.type),
      );
      emit(state.copyWith(form: form));
      if (form.shiftSchedule.isRequired) {
        getShiftSchedule();
      }
    }
  }
}
