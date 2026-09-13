import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/service/websocket_service.dart';
import 'package:presensi_mobile/service/background_location_service.dart';

part 'login_sign_out_state.dart';

class LoginSignOutCubit extends Cubit<LoginSignOutState> {
  final LoginSignOut loginSignOut;

  LoginSignOutCubit(this.loginSignOut) : super(const LoginSignOutState());

  Future<void> logout() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: TypeState.loading));
    try {
      final data = await loginSignOut
          .call(NoParams())
          .timeout(const Duration(seconds: 12));

      await _clearRuntimeSession();
      data.fold(
        (failure) =>
            emit(state.copyWith(status: TypeState.notLoaded, failure: failure)),
        (value) {
          emit(state.copyWith(status: TypeState.loaded, isSuccessed: value));
          if (!kIsWeb) {
            unawaited(
              fa.logEvent(
                name: 'Logout',
                parameters: {'status': value.toString()},
              ),
            );
          }
        },
      );
    } catch (error) {
      await _clearRuntimeSession();
      emit(
        state.copyWith(
          status: TypeState.notLoaded,
          failure: UnknownFailure(
            message: error is TimeoutException
                ? 'Logout timeout. Sesi pada perangkat telah dibersihkan.'
                : 'Logout gagal: $error',
          ),
        ),
      );
    }
  }

  Future<void> _clearRuntimeSession() async {
    WebSocketService.instance.disconnect();
    sl<FlavorConfig>().token = null;
    if (!kIsWeb) {
      try {
        await BackgroundLocationService.stop().timeout(
          const Duration(seconds: 5),
        );
      } catch (_) {
        // Pembersihan sesi dan navigasi tidak boleh tertahan service native.
      }
    }
    await sl<AppCubit>().clearStateOnLogout();
  }
}
