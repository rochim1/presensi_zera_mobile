import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    emit(state.copyWith(status: TypeState.loading));
    final data = await loginSignOut.call(NoParams());

    data.fold(
      (failure) =>
          emit(state.copyWith(status: TypeState.notLoaded, failure: failure)),
      (value) async {
        // ── Putuskan WebSocket saat logout ──
        WebSocketService.instance.disconnect();
        await BackgroundLocationService.stop();
        // ── Reset state di AppCubit ──
        await sl<AppCubit>().clearStateOnLogout();
        // ──────────────────────────────────────────
        emit(state.copyWith(status: TypeState.loaded, isSuccessed: value));
        //! Analytics Logs the logout event.
        await fa.logEvent(
          name: 'Logout',
          parameters: {'status': value.toString()},
        );
      },
    );
  }
}
