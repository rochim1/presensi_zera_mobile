import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/_core.dart';
import '../../../injections.dart';
import '../../_presentation.dart';

class VersioningLogin extends StatelessWidget {
  const VersioningLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GlobalGetVersionCubit>()..getData(),
      child: BlocBuilder<GlobalGetVersionCubit, GlobalGetVersionState>(
        builder: (context, state) {
          return FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (_, AsyncSnapshot<PackageInfo> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Text(
                  'Versi Aplikasi ${snapshot.data?.version}+${snapshot.data?.buildNumber} ${state.version == null ? '' : '|'} ${state.version ?? ''}',
                  textAlign: TextAlign.center,
                  style: context.textStyle.bodySmall,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
