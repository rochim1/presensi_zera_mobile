import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';

part 'login_sign_in_state.dart';

class LoginSignInCubit extends Cubit<LoginSignInState> {
  final LoginSignIn loginSignIn;
  final DeviceInfoPlugin deviceInfo;

  LoginSignInCubit({required this.loginSignIn, required this.deviceInfo})
    : super(const LoginSignInState());

  Future<void> login(LoginParamsEntity params) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: AuthState.loading));

    try {
      String? deviceIdentifier;
      // deviceInfo.androidInfo is a native call and must never be awaited by
      // the browser. Previously this prevented the login mutation from being
      // sent and left the button in its loading state.
      if (!kIsWeb) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceIdentifier = '${androidInfo.model}:${androidInfo.id}';
      }

      final newParams = params.copyWith(macAddress: deviceIdentifier);
      final data = await loginSignIn
          .call(newParams)
          .timeout(Duration(seconds: kIsWeb ? 20 : 30));

      data.fold(
        (failure) => emit(
          state.copyWith(status: AuthState.notLoggedIn, failure: failure),
        ),
        (value) async {
          emit(state.copyWith(status: AuthState.loggedIn, userEntity: value));

          if (!kIsWeb) {
            await fa.logLogin(
              parameters: {
                'id': state.userEntity?.user?.id ?? '',
                'name': state.userEntity?.user?.name ?? '',
              },
            );
          }
        },
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthState.notLoggedIn,
          failure: UnknownFailure(
            message: error is TimeoutException
                ? 'Login timeout. Periksa koneksi ke server.'
                : 'Login gagal: $error',
          ),
        ),
      );
    }
  }
}
