import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/_core.dart';
import '../../../injections.dart';
import '../../_presentation.dart';
import 'widgets/auth_responsive_shell.dart';

@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: BlocListener<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>
            previous.submitStatus != current.submitStatus,
        listener: (context, state) async {
          if (state.submitStatus.isLoaded &&
              (state.isRegisterSuccess ?? false)) {
            TextInput.finishAutofillContext(shouldSave: true);
            await AppModalBottom.showDefault(
              context,
              contentTitle: 'Registrasi Berhasil',
              contentSubtitle:
                  'Kami telah mengirim email verifikasi ke alamat email Anda. Buka email tersebut dan verifikasi akun sebelum login. Jika belum terlihat, periksa folder Spam atau Junk.',
              hasActionPop: true,
              yesOkLabel: 'Saya Mengerti',
            );
            if (!context.mounted) return;
            if (context.router.canPop()) {
              context.router.pop();
            } else {
              context.router.replace(LoginPageRoute());
            }
          }

          if (state.submitStatus.isLoaded && state.isRegisterSuccess == false) {
            await AppModalBottom.showDefault(
              context,
              emptyState: EmptyState.somethingWrong,
              contentTitle: 'Registrasi Gagal',
              contentSubtitle:
                  'Akun belum berhasil dibuat. Silakan periksa data lalu coba lagi.',
              hasActionPop: true,
              yesOkLabel: 'Tutup',
            );
          }

          if (state.submitStatus.isNotLoaded && state.failure != null) {
            if (!context.mounted) return;
            await AppModalBottom.handleError(
              context,
              state.failure,
              ignoreUnauthorized: true,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primaryDark,
          appBar: AppTopBar(
            title: 'Daftar Akun',
            backgroundColor: AppColors.transparent,
          ),
          extendBodyBehindAppBar: true,
          body: const AuthResponsiveShell(
            topPadding: 76,
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}
