import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/service/_service.dart';

import '../../formz/_formz.dart';
import 'check_out_state.dart';

class CheckOutCubit extends Cubit<CheckOutState> {
  final CheckOut checkOutUseCase;
  final LocationService locationService;
  final Logger logger;
  final LogbookRemoteDatasource logbookRemoteDatasource;
  final LoginLocalDatasource loginLocalDatasource;
  final LocalCacheService localCacheService;
  final SyncService syncService;
  Timer? _timer;

  CheckOutCubit({
    required this.checkOutUseCase,
    required this.locationService,
    required this.logger,
    required this.logbookRemoteDatasource,
    required this.loginLocalDatasource,
    required this.localCacheService,
    required this.syncService,
  }) : super(const CheckOutState());

  Future<void> submit({required int moodScore, String? workRelation}) async {
    if (state.checkOut.isLoading) return;

    final mode = state.attendanceMode;
    final form = state.form.copyWith(
      location: LocationInput.dirty(state.form.location.value),
      attachment: AttachmentInput.dirty(state.form.attachment.value),
      keterangan: NoteInput.dirty(state.form.keterangan.value),
      photo: SelfieInput.dirty(state.form.photo.value, mode: mode),
    );
    emit(state.copyWith(form: form));

    if (!form.isValid) return;

    emit(state.copyWith(checkOut: BaseState.loading(), queuedOffline: false));

    try {
      final selfieCompressed = await form.photo.value?.toCompressedMultipart();
      final attachments = await Future.wait(
        form.attachment.value.map((v) => v.xFile.toCompressedMultipart()),
      );

      final params = CheckOutParams(
        fotoPresensi: selfieCompressed,
        fotoPendukung: attachments,
        input: CheckOutInputParams(
          keterangan: form.keterangan.value,
          location: form.location.value,
          jamMulai: DateTime.now(),
          emotionalReport: {
            'mood_score': moodScore,
            if (moodScore <= 2) 'work_relation': workRelation,
          },
        ),
      );
      final result = await checkOutUseCase.call(params);

      await result.fold(
        (failure) async {
          if (failure is UnknownFailure) {
            await localCacheService.enqueuePresensi({
              'sync_type': 'check_out',
              'waktu_lokal': DateTime.now().toIso8601String(),
              'latitude': form.location.value.lat,
              'longitude': form.location.value.long,
              'input': {
                'keterangan': form.keterangan.value,
                'latitude': form.location.value.lat,
                'longitude': form.location.value.long,
                'jam_mulai': params.input.jamMulai.toIso8601String(),
                'emotional_report': params.input.emotionalReport,
              },
              'foto_presensi': await _serializeFile(form.photo.value),
              'foto_pendukung': await Future.wait(
                form.attachment.value.map((file) => _serializeFile(file.xFile)),
              ),
            });
            await syncService.refreshPendingCount();
            emit(
              state.copyWith(
                checkOut: BaseState.success(null),
                queuedOffline: true,
              ),
            );
            return;
          }
          emit(state.copyWith(checkOut: BaseState.failure(failure)));
        },
        (_) {
          emit(
            state.copyWith(
              checkOut: BaseState.success(null),
              queuedOffline: false,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      logger.e(
        "CheckOutCubit.submit Failed to compress image",
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          checkOut: BaseState.failure(
            UnknownFailure(message: 'Foto gagal diproses, silakan coba lagi'),
          ),
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> _serializeFile(XFile? file) async {
    if (file == null) return null;
    return {'name': file.name, 'bytes': base64Encode(await file.readAsBytes())};
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

  void setAttendanceType(AttendanceType value) {
    emit(state.copyWith(type: value));
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
      logger.e("CheckOutCubit.getCurrentLocation, $e");
      emit(state.copyWith(currentAddress: BaseState.failure(e)));
    } catch (e) {
      logger.e("CheckOutCubit.getCurrentLocation, $e");
      emit(state.copyWith(currentAddress: BaseState.failure(UnknownFailure())));
    }
  }

  void init(SettingAttendanceMode mode, AttendanceType type) {
    setAttendanceMode(mode);
    setAttendanceType(type);
    getCurrentAddress();
    _startTimer();
    checkLogbookPolicy();
  }

  Future<void> checkLogbookPolicy() async {
    emit(state.copyWith(policyState: BaseState.loading()));
    try {
      final user = await loginLocalDatasource.getLogin();
      final result = await logbookRemoteDatasource
          .testUserLogbookCheckoutPolicy(user.userId);
      emit(
        state.copyWith(
          policyState: BaseState.success(result),
          logbookPolicyResult: result,
        ),
      );
    } catch (e, stackTrace) {
      logger.e(
        'Failed to check logbook policy',
        error: e,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(policyState: BaseState.failure(UnknownFailure())));
    }
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
