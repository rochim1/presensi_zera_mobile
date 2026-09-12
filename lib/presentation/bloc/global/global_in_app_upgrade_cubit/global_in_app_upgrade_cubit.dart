import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter/foundation.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';

part 'global_in_app_upgrade_state.dart';

class GlobalInAppUpgradeCubit extends Cubit<GlobalInAppUpgradeState> {
  GlobalInAppUpgradeCubit() : super(const GlobalInAppUpgradeState());

  Future<void> checkForUpdate() async {
    if (kIsWeb || !fl.env!.isProd) return;

    try {
      final AppUpdateInfo info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        _performImmediateUpdate(info);
      }
    } catch (_) {}
  }

  void _performImmediateUpdate(AppUpdateInfo info) async {
    AppUpdateResult result = await InAppUpdate.performImmediateUpdate();

    if (result == AppUpdateResult.success) {
      emit(
        state.copyWith(
          status: TypeState.loaded,
          info: info,
          result: result,
          message: 'Berhasil memperbaharui Aplikasi',
        ),
      );
    } else if (result == AppUpdateResult.userDeniedUpdate) {
      emit(
        state.copyWith(
          status: TypeState.notLoaded,
          info: info,
          result: result,
          failure: const CustomFailure(
            message:
                'Maaf, pembaruan dibatalkan atau ditolak oleh pengguna. Silakan coba lagi nanti atau hubungi Pengembang.',
          ),
        ),
      );
    } else if (result == AppUpdateResult.inAppUpdateFailed) {
      emit(
        state.copyWith(
          status: TypeState.notLoaded,
          info: info,
          result: result,
          failure: const CustomFailure(
            message:
                'Maaf, terdapat kesalahan lain yang mencegah pengguna memberikan persetujuan atau pembaruan untuk dilanjutkan.',
          ),
        ),
      );
    }
  }
}
