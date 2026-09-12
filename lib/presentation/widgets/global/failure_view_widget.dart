import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class FailureViewWidget extends StatefulWidget {
  final Failure? failure;
  final EmptyState emptyState;
  final double width;

  const FailureViewWidget({
    super.key,
    required this.failure,
    this.emptyState = EmptyState.somethingWrong,
    this.width = 200.0,
  });

  @override
  State<FailureViewWidget> createState() => _FailureViewWidgetState();
}

class _FailureViewWidgetState extends State<FailureViewWidget> {
  @override
  void initState() {
    super.initState();
    autoLogout();
  }

  void autoLogout() async {
    if (widget.failure?.code != null && widget.failure!.code.isUnauthorized) {
      await sl<LoginSignOutCubit>().logout();

      if (!mounted || !context.mounted) return;
      context.router.pushAndPopUntil(IntroPageRoute(), predicate: (r) => true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppUtility.handleEmptyState(
                widget.failure?.code.isArrayEmpty ?? false
                    ? EmptyState.emptyList
                    : widget.emptyState,
              ),
              width: widget.width,
            ),
            const SizedBox(height: AppDimens.size4S),
            Text(
              '${sl<FlavorConfig>().env?.isDev ?? false ? '[${widget.failure!.code}]\n' : ''} ${widget.failure?.message ?? ''}',
              textAlign: TextAlign.center,
              style: context.textStyle.titleMedium!.copyWith(
                color: AppColors.labelSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
