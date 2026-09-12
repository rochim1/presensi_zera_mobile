import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/service/_service.dart';

import '../../formz/_formz.dart';
import 'check_in_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  final CheckIn checkInUseCase;
  final LocationService locationService;
  final Logger logger;
  Timer? _timer;

  CheckInCubit({
    required this.checkInUseCase,
    required this.locationService,
    required this.logger,
  }) : super(const CheckInState());

  Future<void> submit() async {
    final mode = state.attendanceMode;
    final form = state.form.copyWith(
      location: LocationInput.dirty(state.form.location.value),
      attachment: AttachmentInput.dirty(state.form.attachment.value),
      keterangan: NoteInput.dirty(state.form.keterangan.value),
      photo: SelfieInput.dirty(state.form.photo.value, mode: mode),
    );
    emit(state.copyWith(form: form));

    if (!form.isValid) return;

    emit(state.copyWith(checkIn: BaseState.loading()));

    try {
      final selfieCompressed = await form.photo.value?.toCompressedMultipart();
      final attachments = await Future.wait(
        form.attachment.value.map((v) => v.xFile.toCompressedMultipart()),
      );

      final params = CheckInParams(
        fotoPresensi: selfieCompressed,
        fotoPendukung: attachments,
        input: CheckInInputParams(
          keterangan: form.keterangan.value,
          location: form.location.value,
          type: state.presenceType,
          jamMulai: DateTime.now(),
        ),
      );
      final result = await checkInUseCase.call(params);

      result.fold(
        (failure) {
          emit(state.copyWith(checkIn: BaseState.failure(failure)));
        },
        (_) {
          emit(state.copyWith(checkIn: BaseState.success(null)));
        },
      );
    } catch (e, stackTrace) {
      logger.e(
        "CheckInCubit.submit Failed to compress image",
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          checkIn: BaseState.failure(
            UnknownFailure(message: 'Foto gagal diproses, silakan coba lagi'),
          ),
        ),
      );
    }
  }

  void onChangeKeterangan(String value) {
    final form = state.form.copyWith(keterangan: NoteInput.dirty(value));

    emit(state.copyWith(form: form));
  }

  void onChangePhoto(XFile? value) {
    final form = state.form.copyWith(
      photo: SelfieInput.dirty(value, mode: state.attendanceMode),
    );
    emit(state.copyWith(form: form));
  }

  void setAttendanceMode(SettingAttendanceMode mode) {
    final form = state.form.copyWith(
      photo: SelfieInput.dirty(state.form.photo.value, mode: mode),
    );
    emit(state.copyWith(attendanceMode: mode, form: form));
  }

  void onChangeAttachment(List<PlatformFile> value) {
    final form = state.form.copyWith(attachment: AttachmentInput.dirty(value));

    emit(state.copyWith(form: form));
  }

  void onChangePresenceType(AttendanceType value) {
    emit(state.copyWith(presenceType: value));
  }

  Future<void> getCurrentAddress() async {
    emit(state.copyWith(currentAddress: BaseState.loading()));

    try {
      final currentLocation = await locationService.getCurrentLocation();
      final currentAddress = await locationService.getAddressByLocation(
        currentLocation,
      );

      emit(
        state.copyWith(
          currentAddress: BaseState.success(currentAddress),
          form: state.form.copyWith(
            location: LocationInput.dirty(currentLocation),
          ),
        ),
      );
    } on LocationFailure catch (e) {
      logger.e("CheckInCubit.getCurrentLocation, $e");
      emit(state.copyWith(currentAddress: BaseState.failure(e)));
    } catch (e) {
      logger.e("CheckInCubit.getCurrentLocation, $e");
      emit(state.copyWith(currentAddress: BaseState.failure(UnknownFailure())));
    }
  }

  void init(SettingAttendanceMode mode, {AttendanceType? initialPresenceType}) {
    if (initialPresenceType != null) {
      onChangePresenceType(initialPresenceType);
    }
    setAttendanceMode(mode);
    getCurrentAddress();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(
        state.copyWith(
          currentTime: DateFormat('hh:mm:ss a').format(DateTime.now()),
        ),
      );
    });
    // Initial time set
    emit(
      state.copyWith(
        currentTime: DateFormat('hh:mm:ss a').format(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
