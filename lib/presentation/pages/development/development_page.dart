import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

@RoutePage()
class DevelopmentPage extends StatelessWidget {
  const DevelopmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titleText: 'Dev Information',
        actions: [
          if (kDebugMode)
            ButtonAddAppBar(
              icon: const Icon(Icons.running_with_errors_rounded),
              onTap: () {
                if (!kIsWeb) fs.crash();
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: AppDimens.bottomNavbarHeight,
            color: AppColors.primary,
          ),
          Container(
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimens.radiusLarge),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.paddingMediumX),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'App Information',
                    style: context.textStyle.titleMedium!.copyWith(
                      color: AppColors.primary,
                      fontSize: AppDimens.size3M,
                    ),
                  ),
                  AppDimens.paddingMediumX.hSpace,
                  ListComponentWidget(
                    label: 'Environment',
                    value: fl.env!.name,
                  ),
                  AppDimens.size2M.hDiv,
                  ListComponentWidget(
                    label: 'App Name',
                    value: fl.values!.appName,
                  ),
                  AppDimens.size2M.hDiv,
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, snapshot) {
                      return ListComponentWidget(
                        label: 'App Version',
                        value: snapshot.hasData
                            ? 'v${snapshot.data?.version}+${snapshot.data?.buildNumber}'
                            : '',
                        isLoaded:
                            snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData,
                      );
                    },
                  ),
                  AppDimens.size2M.hDiv,
                  ListComponentWidget(
                    label: 'Debug',
                    value: fl.values!.debug.toString().capitalize,
                  ),
                  AppDimens.size2M.hDiv,
                  ListComponentWidget(
                    label: 'Print Response',
                    value: fl.values!.printResponse.toString().capitalize,
                  ),
                  AppDimens.size2M.hDiv,
                  ListComponentWidget(
                    label: 'Duration',
                    value: '${fl.values!.delay!.inMilliseconds} Milliseconds',
                  ),
                  AppDimens.paddingMediumX.hSpace,
                  Text(
                    'Graphql Information',
                    style: context.textStyle.titleMedium!.copyWith(
                      color: AppColors.primary,
                      fontSize: AppDimens.size3M,
                    ),
                  ),
                  AppDimens.paddingMediumX.hSpace,
                  BlocProvider(
                    create: (context) => sl<GlobalGetVersionCubit>()..getData(),
                    child:
                        BlocBuilder<
                          GlobalGetVersionCubit,
                          GlobalGetVersionState
                        >(
                          builder: (_, state) {
                            return ListComponentWidget(
                              label: 'BE Version',
                              value: state.version ?? '',
                              isShowTooltip: true,
                              isLoaded: state.status.isLoaded,
                            );
                          },
                        ),
                  ),
                  AppDimens.size2M.hDiv,
                  ListComponentWidget(
                    label: 'Base Api',
                    value: fl.baseApi ?? fl.values!.baseApi!,
                    isShowTooltip: true,
                  ),
                  AppDimens.size2M.hDiv,
                  BlocProvider(
                    create: (context) => sl<UserGetLocalCubit>()..getData(),
                    child: BlocBuilder<UserGetLocalCubit, UserGetLocalState>(
                      builder: (_, state) {
                        return ListComponentWidget(
                          label: 'ID User',
                          value: state.status.isLoaded
                              ? state.data?.userId ?? ''
                              : '',
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(
                                text: state.status.isLoaded
                                    ? state.data?.userId ?? ''
                                    : '',
                              ),
                            ).then((value) {
                              Fluttertoast.showToast(
                                msg: 'Berhasil salin ID user',
                              );
                            });
                          },
                        );
                      },
                    ),
                  ),
                  AppDimens.size2M.hDiv,
                  ListComponentWidget(
                    label: 'Api Key',
                    value: fl.token ?? '',
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: fl.token ?? ''),
                      ).then((value) {
                        Fluttertoast.showToast(msg: 'Berhasil salin JWT');
                      });
                    },
                  ),
                  AppDimens.size2M.hDiv,
                  ListComponentWidget(
                    label: 'FCM Token',
                    value: fl.appId ?? '',
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: fl.appId ?? ''),
                      ).then((value) {
                        Fluttertoast.showToast(msg: 'Berhasil salin FCM Token');
                      });
                    },
                  ),
                  AppDimens.paddingMediumX.hSpace,
                  Text(
                    'Firebase Information',
                    style: context.textStyle.titleMedium!.copyWith(
                      color: AppColors.primary,
                      fontSize: AppDimens.size3M,
                    ),
                  ),
                  AppDimens.paddingMediumX.hSpace,
                  ListComponentWidget(
                    label: 'Api Key',
                    value: fl.values!.options.apiKey,
                  ),
                  AppDimens.size2M.hDiv,
                  ListComponentWidget(
                    label: 'App Id',
                    value: fl.values!.options.appId,
                  ),
                  AppDimens.size2M.hDiv,
                  ListComponentWidget(
                    label: 'Messaging Sender Id',
                    value: fl.values!.options.messagingSenderId,
                    isShowTooltip: false,
                  ),
                  AppDimens.size2M.hDiv,
                  ListComponentWidget(
                    label: 'Project Id',
                    value: fl.values!.options.projectId,
                    isShowTooltip: false,
                  ),
                  AppDimens.size2M.hDiv,
                  ListComponentWidget(
                    label: 'Storage Bucket',
                    value: fl.values!.options.storageBucket,
                    isShowTooltip: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
