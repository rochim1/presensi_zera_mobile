import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_data/presensi_data.dart';

import '../../../core/_core.dart';
import '../../../injections.dart';
import '../../../service/location_service.dart';
import '../../../service/websocket_service.dart';
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
        listener: (context, state) async {
          if (state.status.isLoggedIn) {
            // ── Connect WebSocket sebagai user/karyawan ─────────
            final token = state.userEntity?.token ?? '';
            if (token.isNotEmpty) {
              final baseUrl =
                  sl<FlavorConfig>().baseApi ??
                  sl<FlavorConfig>().values?.baseApi ??
                  '';
              if (baseUrl.isNotEmpty) {
                WebSocketService.instance.connect(
                  baseUrl: baseUrl,
                  token: token,
                );

                // ── Setup callbacks untuk on-demand tracking ──
                try {
                  final locService = sl<LocationService>();
                  WebSocketService.instance.onGetCurrentLocation = () async {
                    final loc = await locService.getCurrentLocation();
                    return {'latitude': loc.lat, 'longitude': loc.long};
                  };

                  // Cek apakah user sedang kerja (punya presensi aktif) via AppCubit
                  final appCubit = context.read<AppCubit>();
                  WebSocketService.instance.onCheckIsWorking = () async {
                    try {
                      final attendance = appCubit.state.activeAttendance.data;
                      return attendance != null && attendance.jamPulang == null;
                    } catch (e) {
                      debugPrint('[WS] onCheckIsWorking error: $e');
                      return false;
                    }
                  };

                  // Admin-driven: tracking hanya aktif saat admin minta
                } catch (e) {
                  debugPrint('[WS] Failed to setup WS callbacks: $e');
                }
              }
            }
            // ──────────────────────────────────────────

            // Update flavor config token before refreshing AppCubit
            sl<FlavorConfig>().token = token;

            // Do not block navigation on the dashboard's initial API refresh.
            // A slow secondary request previously made a successful login look
            // stuck even after the authentication mutation had completed.
            unawaited(context.read<AppCubit>().onRefresh());

            if (onLoginResult != null) {
              onLoginResult?.call(true, state.userEntity);
            } else if (state.userEntity?.user?.instansiId == null) {
              context.router.pushAndPopUntil(
                InstansiSetupPageRoute(
                  initialEmail: state.userEntity?.user?.email,
                ),
                predicate: (r) => true,
              );
            } else {
              context.router.pushAndPopUntil(
                const MainPageRoute(),
                predicate: (r) => true,
              );
            }
          }
          if (state.status.isNotLoggedIn) {
            AppModalBottom.handleError(
              context,
              state.failure!,
              ignoreUnauthorized: true,
            );
          }
        },
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
