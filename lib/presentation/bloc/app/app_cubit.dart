import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/service/background_location_service.dart';
import 'package:presensi_mobile/service/websocket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  static const _settingCacheKeyPrefix = 'organization_setting_cache';
  final GetActiveAttendance getActiveAttendanceUseCase;
  final GetAttendances getAttendancesUseCase;
  final GetEffectiveScheduleToday getEffectiveScheduleTodayUseCase;
  final GetAuthSession getAuthSessionUseCase;
  final GetCurrentUser getCurrentUserUseCase;
  final GetSettingByOrganizationId getSettingByOrganizationIdUseCase;
  final CreateOvertimeRequest createOvertimeRequestUseCase;
  final GetActiveOvertimeSession getActiveOvertimeSessionUseCase;
  final StartOvertimeSession startOvertimeSessionUseCase;
  final FinishOvertimeSession finishOvertimeSessionUseCase;
  final CancelOvertimeSession cancelOvertimeSessionUseCase;

  AppCubit({
    required this.getActiveAttendanceUseCase,
    required this.getAttendancesUseCase,
    required this.getEffectiveScheduleTodayUseCase,
    required this.getAuthSessionUseCase,
    required this.getSettingByOrganizationIdUseCase,
    required this.getCurrentUserUseCase,
    required this.createOvertimeRequestUseCase,
    required this.getActiveOvertimeSessionUseCase,
    required this.startOvertimeSessionUseCase,
    required this.finishOvertimeSessionUseCase,
    required this.cancelOvertimeSessionUseCase,
  }) : super(const AppState());

  Future<void> getActiveAttendance() async {
    emit(state.copyWith(activeAttendance: BaseState.loading()));

    final result = await getActiveAttendanceUseCase.call(NoParams());
    result.fold(
      (failure) {
        emit(state.copyWith(activeAttendance: BaseState.failure(failure)));
      },
      (value) {
        emit(state.copyWith(activeAttendance: BaseState.success(value)));
      },
    );
  }

  Future<void> getEffectiveScheduleToday() async {
    emit(state.copyWith(effectiveSchedule: BaseState.loading()));

    final result = await getEffectiveScheduleTodayUseCase.call(NoParams());
    result.fold(
      (failure) {
        emit(state.copyWith(effectiveSchedule: BaseState.failure(failure)));
      },
      (value) {
        emit(state.copyWith(effectiveSchedule: BaseState.success(value)));
      },
    );
  }

  Future<void> getAuthSession() async {
    emit(state.copyWith(session: BaseState.loading()));

    final result = await getAuthSessionUseCase.call(NoParams());
    result.fold(
      (failure) {
        emit(state.copyWith(session: BaseState.failure(failure)));
      },
      (value) {
        emit(state.copyWith(session: BaseState.success(value)));
      },
    );
  }

  Future<void> getCurrentUser() async {
    emit(state.copyWith(user: BaseState.loading()));

    final result = await getCurrentUserUseCase.call(NoParams());
    result.fold(
      (failure) {
        emit(state.copyWith(user: BaseState.failure(failure)));
      },
      (value) {
        emit(state.copyWith(user: BaseState.success(value)));
      },
    );
  }

  Future<void> getSetting() async {
    if (!state.user.isSuccess) return;
    final currentUser = state.user.data;
    final currentOrgId = currentUser?.organization?.id;
    final currentUserId = currentUser?.id;
    if (currentOrgId == null || currentUserId == null) return;

    // Keep the last valid value available while refreshing. Attendance pages
    // must never temporarily fall back to another mode because a request is in
    // flight.
    if (!state.setting.isSuccess) {
      emit(state.copyWith(setting: BaseState.loading()));
    }

    final result = await getSettingByOrganizationIdUseCase.call(
      GetSettingParams(organizationId: currentOrgId, userId: currentUserId),
    );
    await result.fold<Future<void>>(
      (failure) async {
        if (!state.setting.isSuccess) {
          emit(state.copyWith(setting: BaseState.failure(failure)));
        }
      },
      (value) async {
        await _saveSettingCache(value);
        emit(state.copyWith(setting: BaseState.success(value)));
      },
    );
  }

  String? get _settingCacheKey {
    final userId = state.user.data?.id;
    final organizationId = state.user.data?.organization?.id;
    if (userId == null || organizationId == null) return null;
    return '${_settingCacheKeyPrefix}_${organizationId}_$userId';
  }

  Future<void> _saveSettingCache(Setting setting) async {
    final key = _settingCacheKey;
    if (key == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      key,
      jsonEncode({
        'id': setting.id,
        'jamMasuk': setting.jamMasuk?.toIso8601String(),
        'jamPulang': setting.jamPulang?.toIso8601String(),
        'attendanceMode': setting.attendanceMode?.name,
        'modeOrderSales': setting.modeOrderSales,
        'allowMobileChangeVisitVehicle': setting.allowMobileChangeVisitVehicle,
        'allowOvertimeCrossDay': setting.allowOvertimeCrossDay,
        'overtimeAutoCloseNextDay': setting.overtimeAutoCloseNextDay,
        'overtimeAutoCloseTime': setting.overtimeAutoCloseTime,
        'maxOvertimeActiveHours': setting.maxOvertimeActiveHours,
        'isMandatorySupportingEvidence': setting.isMandatorySupportingEvidence,
        'allowPresensiOnCall': setting.allowPresensiOnCall,
        'onCallRequireLocationPolicy': setting.onCallRequireLocationPolicy,
        'onCallRequireLocation': setting.onCallRequireLocation,
        'allowOnCallAfterCheckout': setting.allowOnCallAfterCheckout,
        'allowOnCallCrossDay': setting.allowOnCallCrossDay,
        'onCallAutoCloseNextDay': setting.onCallAutoCloseNextDay,
        'onCallAutoCloseTime': setting.onCallAutoCloseTime,
        'maxOnCallActiveHours': setting.maxOnCallActiveHours,
        'attendanceTypes': setting.attendanceTypes,
        'logbookRequiredForCheckout': setting.logbookRequiredForCheckout,
        'logbookRequireStartEndTime': setting.logbookRequireStartEndTime,
        'logbookRequireDescription': setting.logbookRequireDescription,
        'logbookRequireCategory': setting.logbookRequireCategory,
        'logbookUseDefaultTimeWhenEmpty':
            setting.logbookUseDefaultTimeWhenEmpty,
        'logbookDefaultStartTime': setting.logbookDefaultStartTime,
        'logbookDefaultEndTime': setting.logbookDefaultEndTime,
        'logbookDefaultDurationMinutes': setting.logbookDefaultDurationMinutes,
      }),
    );
  }

  Future<void> loadSettingCache() async {
    final key = _settingCacheKey;
    if (key == null) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final modeName = json['attendanceMode']?.toString();
      final cached = Setting(
        id: json['id']?.toString() ?? '',
        jamMasuk: DateTime.tryParse(json['jamMasuk']?.toString() ?? ''),
        jamPulang: DateTime.tryParse(json['jamPulang']?.toString() ?? ''),
        attendanceMode: SettingAttendanceMode.values.firstWhere(
          (mode) => mode.name == modeName,
          orElse: () => SettingAttendanceMode.tanpa_foto,
        ),
        modeOrderSales: json['modeOrderSales']?.toString() ?? 'full',
        allowMobileChangeVisitVehicle:
            json['allowMobileChangeVisitVehicle'] == true,
        allowOvertimeCrossDay: json['allowOvertimeCrossDay'] == true,
        overtimeAutoCloseNextDay: json['overtimeAutoCloseNextDay'] != false,
        overtimeAutoCloseTime:
            json['overtimeAutoCloseTime']?.toString() ?? '23:59',
        maxOvertimeActiveHours:
            (json['maxOvertimeActiveHours'] as num?)?.toInt() ?? 8,
        isMandatorySupportingEvidence:
            json['isMandatorySupportingEvidence'] == true,
        allowPresensiOnCall: json['allowPresensiOnCall'] == true,
        onCallRequireLocationPolicy:
            json['onCallRequireLocationPolicy'] != false,
        onCallRequireLocation: json['onCallRequireLocation'] != false,
        allowOnCallAfterCheckout: json['allowOnCallAfterCheckout'] != false,
        allowOnCallCrossDay: json['allowOnCallCrossDay'] != false,
        onCallAutoCloseNextDay: json['onCallAutoCloseNextDay'] == true,
        logbookRequiredForCheckout: json['logbookRequiredForCheckout'] == true,
        logbookRequireStartEndTime: json['logbookRequireStartEndTime'] != false,
        logbookRequireDescription: json['logbookRequireDescription'] == true,
        logbookRequireCategory: json['logbookRequireCategory'] == true,
        logbookUseDefaultTimeWhenEmpty:
            json['logbookUseDefaultTimeWhenEmpty'] == true,
        logbookDefaultStartTime:
            json['logbookDefaultStartTime']?.toString() ?? '09:00',
        logbookDefaultEndTime:
            json['logbookDefaultEndTime']?.toString() ?? '17:00',
        logbookDefaultDurationMinutes:
            (json['logbookDefaultDurationMinutes'] as num?)?.toInt() ?? 30,
        onCallAutoCloseTime: json['onCallAutoCloseTime']?.toString() ?? '23:59',
        maxOnCallActiveHours:
            (json['maxOnCallActiveHours'] as num?)?.toInt() ?? 24,
        attendanceTypes:
            (json['attendanceTypes'] as List<dynamic>?)
                ?.map((value) => value.toString())
                .toList() ??
            const ['reguler'],
      );
      if (cached.id.isNotEmpty) {
        emit(state.copyWith(setting: BaseState.success(cached)));
      }
    } catch (_) {
      await prefs.remove(key);
    }
  }

  Future<void> loadCheckedOutDate() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = state.user.data?.id;
    if (userId == null) return;

    final key = 'checked_out_date_$userId';
    // The local marker is only a UI cache and must never authorize overtime
    // after the app is restarted. The server sync below is authoritative.
    await prefs.remove(key);
    emit(state.copyWith(checkedOutDate: null));
  }

  Future<void> markCheckedOutToday() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = state.user.data?.id;
    if (userId == null) return;

    final today = DateTime.now().toIso8601String().substring(0, 10);
    await prefs.setString('checked_out_date_$userId', today);
    emit(state.copyWith(checkedOutDate: today));
  }

  Future<void> syncCheckedOutDateFromTodayAttendance(bool hasCheckedOut) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = state.user.data?.id;
    if (userId == null) return;

    if (hasCheckedOut) {
      final today = DateTime.now().toIso8601String().substring(0, 10);
      await prefs.setString('checked_out_date_$userId', today);
      if (state.checkedOutDate != today) {
        emit(state.copyWith(checkedOutDate: today));
      }
      return;
    }

    if (state.checkedOutDate != null) {
      await prefs.remove('checked_out_date_$userId');
      emit(state.copyWith(checkedOutDate: null));
    }
  }

  Future<bool> syncTodayAttendanceFromServer() async {
    final userId = state.user.data?.id;
    if (userId == null) return false;

    final now = DateTime.now();
    final result = await getAttendancesUseCase.call(
      GetAttendancesParams(
        userId: userId,
        startDate: now.startOfDay,
        endDate: now.endOfDay,
        page: 0,
        limit: 20,
      ),
    );

    return result.fold(
      (_) async {
        await syncCheckedOutDateFromTodayAttendance(false);
        return false;
      },
      (attendances) async {
        final hasCheckedOut = attendances.any(
          (attendance) => attendance.jamPulang != null,
        );
        await syncCheckedOutDateFromTodayAttendance(hasCheckedOut);
        return true;
      },
    );
  }

  Future<void> loadOvertimeState() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = state.user.data?.id;
    if (userId == null) return;

    final activeResult = await getActiveOvertimeSessionUseCase.call(NoParams());
    var activeLookupFailed = false;
    final activeSession = activeResult.fold((_) {
      activeLookupFailed = true;
      return null;
    }, (session) => session);
    String? startTime = prefs.getString('overtime_start_time_$userId');

    if (activeSession != null) {
      final activeStart = _combineOvertimeDateTime(
        activeSession.date,
        activeSession.startTime,
      );
      if (activeStart != null) {
        await prefs.setString('active_overtime_id_$userId', activeSession.id);
        await prefs.setString(
          'overtime_start_time_$userId',
          activeStart.toIso8601String(),
        );
        startTime = activeStart.toIso8601String();
      }
    } else if (!activeLookupFailed) {
      await prefs.remove('active_overtime_id_$userId');
    }

    if (startTime == null) {
      await prefs.remove('active_overtime_id_$userId');
      emit(state.copyWith(overtimeStartTime: null));
      return;
    }

    final overtimeStart = DateTime.tryParse(startTime);
    if (overtimeStart == null) {
      await prefs.remove('active_overtime_id_$userId');
      await prefs.remove('overtime_start_time_$userId');
      emit(state.copyWith(overtimeStartTime: null));
      return;
    }

    final now = DateTime.now();
    final setting = state.setting.data;
    final crossedDay = !_isSameDate(overtimeStart, now);
    final maxHours = setting?.maxOvertimeActiveHours ?? 8;
    final exceededMaxDuration =
        maxHours > 0 && now.difference(overtimeStart).inMinutes > maxHours * 60;
    final crossDayNotAllowed =
        crossedDay && setting?.allowOvertimeCrossDay != true;
    final autoCloseAt = _resolveOvertimeAutoCloseAt(
      overtimeStart,
      setting?.overtimeAutoCloseTime ?? '23:59',
    );
    final shouldAutoCloseCrossDay =
        crossDayNotAllowed &&
        (setting?.overtimeAutoCloseNextDay ?? true) &&
        !now.isBefore(autoCloseAt);

    if (shouldAutoCloseCrossDay) {
      final submitted = await _submitAutoClosedOvertime(
        startTime: overtimeStart,
        endTime: autoCloseAt,
      );

      if (!submitted) {
        emit(state.copyWith(overtimeStartTime: startTime));
        return;
      }
    }

    if (!shouldAutoCloseCrossDay && exceededMaxDuration) {
      await _cancelActiveOvertimeSessionIfAny();
    }

    if (shouldAutoCloseCrossDay || exceededMaxDuration) {
      await prefs.remove('active_overtime_id_$userId');
      await prefs.remove('overtime_start_time_$userId');
      emit(state.copyWith(overtimeStartTime: null));
      return;
    }

    emit(state.copyWith(overtimeStartTime: startTime));
  }

  bool _isSameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  DateTime _resolveOvertimeAutoCloseAt(
    DateTime overtimeStart,
    String autoCloseTime,
  ) {
    final parts = autoCloseTime.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 23 : 23;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 59 : 59;
    var autoCloseAt = DateTime(
      overtimeStart.year,
      overtimeStart.month,
      overtimeStart.day,
      hour.clamp(0, 23),
      minute.clamp(0, 59),
    );

    if (autoCloseAt.isBefore(overtimeStart)) {
      autoCloseAt = autoCloseAt.add(const Duration(days: 1));
    }

    return autoCloseAt;
  }

  Future<bool> _submitAutoClosedOvertime({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = state.user.data?.id;
    final overtimeId = userId == null
        ? null
        : prefs.getString('active_overtime_id_$userId');

    if (overtimeId != null) {
      final result = await finishOvertimeSessionUseCase.call(
        FinishOvertimeSessionParams(
          overtimeId: overtimeId,
          date: startTime,
          startTime: startTime,
          endTime: endTime,
          reason: 'Auto tutup lembur karena lupa akhiri lembur',
        ),
      );

      return result.fold((_) => false, (_) => true);
    }

    final result = await createOvertimeRequestUseCase.call(
      CreateOvertimeRequestParams(
        date: startTime,
        startTime: startTime,
        endTime: endTime,
        reason: 'Auto tutup lembur karena lupa akhiri lembur',
      ),
    );

    return result.fold((_) => false, (_) => true);
  }

  Future<void> _cancelActiveOvertimeSessionIfAny() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = state.user.data?.id;
    if (userId == null) return;

    final overtimeId = prefs.getString('active_overtime_id_$userId');
    if (overtimeId == null) return;

    await cancelOvertimeSessionUseCase.call(overtimeId);
  }

  String _failureMessage(Failure failure, String fallback) {
    final message = failure.message.trim();
    return message.isEmpty ? fallback : message;
  }

  /// Returns `null` on success, otherwise the failure message from backend.
  Future<String?> startOvertime() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = state.user.data?.id;
    if (userId == null) return 'Data pengguna tidak ditemukan';

    // Revalidate immediately before starting overtime. Do not trust the local
    // checkout marker because it can outlive a failed/stale attendance refresh.
    final attendanceResult = await getActiveAttendanceUseCase.call(NoParams());
    final attendanceError = attendanceResult.fold<String?>(
      (failure) => failure is NotFoundFailure
          ? null
          : _failureMessage(
              failure,
              'Status presensi belum dapat diverifikasi. Silakan muat ulang.',
            ),
      (attendance) {
        if (attendance.jamPulang == null) {
          return 'Anda masih memiliki presensi aktif. Lakukan presensi pulang sebelum memulai lembur.';
        }
        return null;
      },
    );
    if (attendanceError != null) return attendanceError;

    final checkoutVerified = await syncTodayAttendanceFromServer();
    if (!checkoutVerified || !state.hasCheckedOutToday) {
      return 'Presensi pulang hari ini belum ditemukan. Lakukan presensi pulang sebelum memulai lembur.';
    }

    final now = DateTime.now();
    final result = await startOvertimeSessionUseCase.call(
      StartOvertimeSessionParams(
        date: now,
        startTime: now,
        reason: 'Lembur setelah presensi pulang',
      ),
    );

    return await result.fold(
      (failure) async {
        return _failureMessage(
          failure,
          'Gagal memulai lembur. Silakan coba lagi.',
        );
      },
      (session) async {
        final start =
            _combineOvertimeDateTime(session.date, session.startTime) ?? now;
        final startIso = start.toIso8601String();
        await prefs.setString('active_overtime_id_$userId', session.id);
        await prefs.setString('overtime_start_time_$userId', startIso);
        emit(state.copyWith(overtimeStartTime: startIso));
        return null;
      },
    );
  }

  Future<void> endOvertime() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = state.user.data?.id;
    if (userId == null) return;

    await prefs.remove('active_overtime_id_$userId');
    await prefs.remove('overtime_start_time_$userId');
    emit(state.copyWith(overtimeStartTime: null));

    final attendance = state.activeAttendance.data;
    final hasOngoingAttendance =
        attendance != null && attendance.jamPulang == null;
    if (!hasOngoingAttendance) {
      WebSocketService.instance.notifyTrackingStopped();
      await BackgroundLocationService.stop();
    }
  }

  /// Returns `null` on success, otherwise the failure message from backend.
  Future<String?> finishOvertime(
    String reason, {
    List<String> attachmentPaths = const [],
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = state.user.data?.id;
    if (userId == null) return 'Data pengguna tidak ditemukan';

    final overtimeId = prefs.getString('active_overtime_id_$userId');
    final startTimeStr =
        state.overtimeStartTime ??
        prefs.getString('overtime_start_time_$userId');
    if (startTimeStr == null) return 'Waktu mulai lembur tidak ditemukan';

    final startTime = DateTime.tryParse(startTimeStr);
    if (startTime == null) return 'Waktu mulai lembur tidak valid';

    final result = await finishOvertimeSessionUseCase.call(
      FinishOvertimeSessionParams(
        overtimeId: overtimeId,
        date: startTime,
        startTime: startTime,
        endTime: DateTime.now(),
        reason: reason,
        attachments: attachmentPaths.map(AppUtility.toMultipartFile).toList(),
      ),
    );

    return await result.fold(
      (failure) async {
        return _failureMessage(
          failure,
          'Gagal menyimpan lembur. Silakan coba lagi.',
        );
      },
      (_) async {
        await endOvertime();
        return null;
      },
    );
  }

  /// Returns `null` on success, otherwise the failure message from backend.
  Future<String?> cancelOvertime() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = state.user.data?.id;
    if (userId == null) return 'Data pengguna tidak ditemukan';

    final overtimeId = prefs.getString('active_overtime_id_$userId');
    if (overtimeId != null) {
      final result = await cancelOvertimeSessionUseCase.call(overtimeId);
      final errorMessage = result.fold<String?>(
        (failure) => _failureMessage(
          failure,
          'Gagal membatalkan lembur. Silakan coba lagi.',
        ),
        (_) => null,
      );
      if (errorMessage != null) return errorMessage;
    }

    await endOvertime();
    return null;
  }

  DateTime? _combineOvertimeDateTime(DateTime? date, DateTime? time) {
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> clearStateOnLogout() async {
    emit(const AppState());
  }

  void init() async {
    await getAuthSession();
    await getCurrentUser();
    await loadSettingCache();
    await getSetting();
    await loadCheckedOutDate();
    await loadOvertimeState();
    await Future.wait([getActiveAttendance(), getEffectiveScheduleToday()]);
    await syncTodayAttendanceFromServer();
  }

  Future<void> onRefresh() async {
    final previousUserId = state.user.data?.id;
    await getAuthSession();
    await getCurrentUser();
    final currentUserId = state.user.data?.id;
    if (previousUserId != null && previousUserId != currentUserId) {
      emit(state.copyWith(setting: BaseState.initial()));
    }
    if (!state.setting.isSuccess) {
      await loadSettingCache();
    }
    await getSetting();
    await loadOvertimeState();
    await Future.wait([getActiveAttendance(), getEffectiveScheduleToday()]);
    await syncTodayAttendanceFromServer();
  }
}
