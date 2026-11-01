import 'handle_pantoo_sign_in.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/_core.dart';
import '../../../injections.dart';

import '../../_presentation.dart';
import 'widgets/auth_responsive_shell.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  final OnLoginResultCallback? onLoginResult;
  const LoginPage({super.key, this.onLoginResult});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<LoginSignInCubit>())],
      child: BlocListener<LoginSignInCubit, LoginSignInState>(
        listener: (context, state) =>
            handlePantooSignIn(context, state, onLoginResult: onLoginResult),
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            if (context.mounted) {
              context.router.replace(
                IntroPageRoute(onLoginResult: onLoginResult),
              );
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.primaryDark,
            body: const AuthResponsiveShell(child: LoginForm()),
          ),
        ),
      ),
    );
  }
}
