import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/pages/home/bloc/home_cubit.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';

class HeaderSection extends StatelessWidget {
  final User? user;
  final int? notificationBadgeCount;
  final int? chatBadgeCount;
  final bool isLoading;
  const HeaderSection({
    super.key,
    this.user,
    this.isLoading = false,
    this.notificationBadgeCount,
    this.chatBadgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: isLoading ? _buildLoading(context) : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    void onTapAvatar() {
      if (isLoading) return;
      context.router.navigate(MainPageRoute(children: [ProfilePageRoute()]));
    }

    return Row(
      children: [
        Expanded(
          child: AppUserInfoTile(
            color: AppColors.white.withValues(alpha: 0.3),
            avatarSize: 40,
            user: user,
            onTap: onTapAvatar,
            padding: EdgeInsets.zero,
            subtitle:
                '${user?.department?.name ?? '-'} • ${user?.organization?.namaResmi ?? '-'}',
            titleBuilder: (context, title) => Text(
              'Halo, $title! 👋',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyle.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                letterSpacing: -0.5,
              ),
            ),
            subtitleBuilder: (context, subtitle) => Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyle.labelSmall!.copyWith(
                color: AppColors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Row(
          spacing: 8,
          children: [
            if (fl.env?.isDev == true)
              AppTopBarActionButton(
                icon: PhosphorIcons.bugBold,
                onTap: () => context.router.push(const DevelopmentPageRoute()),
              ),
            AppTopBarActionButton(
              icon: PhosphorIcons.chatCircleBold,
              badgeCount: chatBadgeCount,
              onTap: () async {
                await context.router.push(const ChatListPageRoute());
                if (context.mounted) {
                  context.read<HomeCubit>().getUnreadChatCount();
                }
              },
            ),
            AppTopBarActionButton(
              icon: PhosphorIcons.bellBold,
              badgeCount: notificationBadgeCount,
              onTap: () => context.router.push(const NotificationPageRoute()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Row(
      children: [
        AppShimmer.circle(size: AppDimens.w48),
        AppDimens.w12.wSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppDimens.h4,
            children: [
              AppShimmer.box(
                width: AppDimens.w96,
                height: AppDimens.h16,
                radius: AppDimens.r4,
              ),
              AppShimmer.box(
                width: AppDimens.w128,
                height: AppDimens.h12,
                radius: AppDimens.r4,
              ),
            ],
          ),
        ),
        Row(
          spacing: AppDimens.w8,
          children: [
            AppShimmer.box(
              width: AppDimens.w40,
              height: AppDimens.w40,
              radius: AppDimens.r12,
            ),
            AppShimmer.box(
              width: AppDimens.w40,
              height: AppDimens.w40,
              radius: AppDimens.r12,
            ),
            AppShimmer.box(
              width: AppDimens.w40,
              height: AppDimens.w40,
              radius: AppDimens.r12,
            ),
          ],
        ),
      ],
    );
  }
}
