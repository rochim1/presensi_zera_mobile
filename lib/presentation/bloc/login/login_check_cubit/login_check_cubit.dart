import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'login_check_state.dart';

class LoginCheckCubit extends Cubit<LoginCheckState> {
  final LoginCheck loginCheck;

  LoginCheckCubit(this.loginCheck) : super(const LoginCheckState());

  Future<void> checkLogin() async {
    final data = await loginCheck.call(NoParams());

    data.fold(
      (failure) => emit(
        state.copyWith(status: TypeState.notLoaded, message: failure.message),
      ),
      (value) =>
          emit(state.copyWith(status: TypeState.loaded, token: value?.token)),
    );
  }
}
