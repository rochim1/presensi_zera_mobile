import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

@RoutePage()
class ProfileAccountPage extends StatelessWidget {
  const ProfileAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    late TextEditingController passwordController = TextEditingController();
    late TextEditingController passwordConfController = TextEditingController();

    void handleSaveButtonPressed(ctx, state) {
      if (state.status.isLoading) {
        Fluttertoast.showToast(msg: kMsgWaiting);
        return;
      }

      if (passwordController.text.isEmpty) return;
      if (passwordController.text == passwordConfController.text) {
        final UserParamsEntity params = UserParamsEntity(
          userId: state.data!.user!.id,
          password: passwordController.text,
        );

        ctx.read<UserPostCubit>().updateAccount(params);
      } else {
        Fluttertoast.showToast(msg: kNotMatch);
      }
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<UserGetLocalCubit>()..getData()),
        BlocProvider(create: (context) => sl<UserGetDataCubit>()),
        BlocProvider(create: (context) => sl<UserPostCubit>()),
      ],
      child: BlocBuilder<UserGetDataCubit, UserGetDataState>(
        builder: (ctxUser, stateData) {
          return BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
            builder: (context, stateLocal) {
              final user = stateData.data?.user ?? stateLocal.data?.user;
              return Scaffold(
                backgroundColor: AppColors.bgPrimary,
                appBar: const AppTopBar(title: 'Pengaturan Akun'),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppCard(
                          showHeaderDivider: true,
                          header: Text(
                            'Informasi Akun',
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          content: Column(
                            children: [
                              ProfileFieldRow(
                                title: 'Email',
                                value: AppUtility.nullHandler(
                                  user?.email,
                                  fallback: '-',
                                ),
                              ),
                              ProfileFieldRow(
                                title: 'Username',
                                value: AppUtility.nullHandler(
                                  user?.username,
                                  fallback: '-',
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppDimens.paddingMedium.hSpace,
                        AppCard(
                          showHeaderDivider: true,
                          header: Text(
                            'Ganti Password',
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                        AppDimens.size3M.hSpace,
                        TextFieldPassword(
                          controller: passwordController,
                          title: 'Password Baru',
                          hint: 'Masukan password baru',
                          hasPrefixIcon: false,
                        ),
                        AppDimens.size3M.hSpace,
                        TextFieldPassword(
                          controller: passwordConfController,
                          title: 'Konfirmasi Password',
                          hint: 'Konfirmasi password baru',
                          hasPrefixIcon: false,
                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(AppDimens.paddingMediumX),
                  child: BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
                    builder: (context, state) {
                      return BlocConsumer<UserPostCubit, UserPostState>(
                        listener: (_, statePost) async {
                          if (statePost.typeState.isLoading) {
                            SmartDialog.showLoading();
                          } else if (statePost.typeState.isLoaded) {
                            SmartDialog.dismiss();

                            passwordController.clear();
                            passwordConfController.clear();

                            await AppModalBottom.showDefault(
                              context,
                              contentTitle: 'Berhasil Ganti Kata Sandi',
                              contentSubtitle:
                                  'Katasandi dari username ${user?.username} berhasil diganti',
                              hasActionPop: true,
                            );
                            if (!context.mounted) return;
                            context.router.pop<bool>(true);
                          } else if (statePost.typeState.isNotLoaded) {
                            SmartDialog.dismiss();
                            AppModalBottom.handleError(
                              context,
                              statePost.failure!,
                            );
                          } else {
                            SmartDialog.dismiss();
                          }
                        },
                        builder: (ctxPost, statePost) {
                          return AppButton(
                            onPressed: () =>
                                handleSaveButtonPressed(ctxPost, statePost),
                            text: 'Simpan',
                            isLoading: statePost.typeState.isLoading,
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
