import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final LoginRegister loginRegister;
  final LoginCheckEmailAvailable loginCheckEmailAvailable;
  final LoginCheckUsernameAvailable loginCheckUsernameAvailable;

  RegisterCubit({
    required this.loginRegister,
    required this.loginCheckEmailAvailable,
    required this.loginCheckUsernameAvailable,
  }) : super(const RegisterState());

  int _emailRequestId = 0;
  int _usernameRequestId = 0;

  Future<bool> checkEmailAvailability(String email) async {
    final value = email.trim();
    if (value.isEmpty || !value.regexEmail) {
      emit(state.copyWith(isEmailAvailable: null, isCheckingEmail: false));
      return false;
    }

    final requestId = ++_emailRequestId;
    emit(state.copyWith(isCheckingEmail: true));

    final result = await loginCheckEmailAvailable.call(value);
    if (requestId != _emailRequestId) {
      return state.isEmailAvailable ?? false;
    }

    return result.fold(
      (_) {
        emit(state.copyWith(isEmailAvailable: null, isCheckingEmail: false));
        return false;
      },
      (value) {
        emit(state.copyWith(isEmailAvailable: value, isCheckingEmail: false));
        return value;
      },
    );
  }

  Future<bool> checkUsernameAvailability(String username) async {
    final value = _sanitizeUsername(username);
    if (value.length < 3) {
      emit(
        state.copyWith(isUsernameAvailable: null, isCheckingUsername: false),
      );
      return false;
    }

    final requestId = ++_usernameRequestId;
    emit(state.copyWith(isCheckingUsername: true));

    final result = await loginCheckUsernameAvailable.call(value);
    if (requestId != _usernameRequestId) {
      return state.isUsernameAvailable ?? false;
    }

    return result.fold(
      (_) {
        emit(
          state.copyWith(isUsernameAvailable: null, isCheckingUsername: false),
        );
        return false;
      },
      (value) {
        emit(
          state.copyWith(isUsernameAvailable: value, isCheckingUsername: false),
        );
        return value;
      },
    );
  }

  Future<bool> ensureAvailability({
    required String email,
    required String username,
  }) async {
    final emailAvailable = await checkEmailAvailability(email);
    final usernameAvailable = await checkUsernameAvailability(username);
    return emailAvailable && usernameAvailable;
  }

  Future<void> register(RegisterParamsEntity params) async {
    emit(
      state.copyWith(
        submitStatus: TypeState.loading,
        failure: null,
        isRegisterSuccess: null,
      ),
    );
    final data = await loginRegister.call(params);
    data.fold(
      (failure) => emit(
        state.copyWith(
          submitStatus: TypeState.notLoaded,
          failure: failure,
          isRegisterSuccess: false,
        ),
      ),
      (value) => emit(
        state.copyWith(
          submitStatus: TypeState.loaded,
          isRegisterSuccess: value,
        ),
      ),
    );
  }

  void clearSubmitStatus() {
    emit(state.copyWith(submitStatus: TypeState.initial, failure: null));
  }

  String sanitizeUsername(String value) => _sanitizeUsername(value);

  String _sanitizeUsername(String value) =>
      value.replaceAll(RegExp(r'\s+'), '');
}
