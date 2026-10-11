import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/pages/home/bloc/home_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';
import 'package:presensi_mobile/presentation/pages/home/bloc/home_state.dart';
import 'package:presensi_mobile/presentation/pages/home/widgets/_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'announcement_expiry_guard.dart';

final Set<String> _popupChecksInFlight = <String>{};

String _localDateKey(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

class AnnouncementSection extends StatelessWidget {
  final HomeState state;

  const AnnouncementSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    Future<void> showAnnouncementsPopup(
      List<Announcement> announcements, [
      void Function(List<Announcement>)? onShown,
    ]) async {
      if (announcements.isEmpty) return;
      await AppBottomSheet.show<void>(
        context: context,
        child: AnnouncementExpiryGuard(
          announcements: announcements,
          onShown: onShown ?? (_) {},
          builder: (sheetContext, active) => _AnnouncementSlider(
            key: ValueKey(active.map((item) => item.id).join(':')),
            announcements: active,
          ),
        ),
        actionsBuilder: (sheetContext) => AppButtonNew(
          onPressed: () => Navigator.of(sheetContext).pop(),
          text: 'Tutup',
          variant: AppButtonNewVariant.tertiary,
          style: AppButtonNewStyle.ghost,
        ),
      );
    }

    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) {
        return previous.announcements.isLoading &&
            !current.announcements.isLoading;
      },
      listener: (context, state) async {
        final data = state.announcements.data;
        if (data != null && data.isNotEmpty) {
          final user = context.read<AppCubit>().state.user.data;
          if (user == null) return;
          final userId = user.id;
          if (!_popupChecksInFlight.add(userId)) return;
          try {
            final preferences = await SharedPreferences.getInstance();
            await WidgetsBinding.instance.endOfFrame;
            if (!context.mounted || ModalRoute.of(context)?.isCurrent != true) {
              return;
            }
            if (context.read<AppCubit>().state.user.data?.id != userId) return;
            final now = DateTime.now();
            final today = _localDateKey(now);
            final popupItems = data.where((e) {
              if (!e.showPopup) return false;
              if (!e.isActiveAt(now)) return false;
              return preferences.getString(
                    'announcement_popup_seen:$userId:${e.id}',
                  ) !=
                  today;
            }).toList();

            if (popupItems.isNotEmpty) {
              await showAnnouncementsPopup(popupItems, (shown) {
                final shownDay = _localDateKey(DateTime.now());
                for (final item in shown) {
                  preferences.setString(
                    'announcement_popup_seen:$userId:${item.id}',
                    shownDay,
                  );
                }
              });
            }
          } finally {
            _popupChecksInFlight.remove(userId);
          }
        }
      },
      child: Builder(
        builder: (context) {
          final now = DateTime.now();
          final validAnnouncements = state.announcements.data
              ?.where((e) => e.isActiveAt(now))
              .toList();

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              spacing: AppDimens.h8,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Info Penting Hari Ini',
                              style: context.textStyle.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.labelPrimary,
                              ),
                            ),
                            AppDimens.sizeS.hSpace,
                            Text(
                              'Cek pengumuman terbaru dari perusahaanmu',
                              style: context.textStyle.bodySmall!.copyWith(
                                color: AppColors.labelSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.announcements.isLoading)
                  SizedBox(
                    height: 196.h,
                    child: LayoutBuilder(
                      builder: (context, constraints) => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.w16,
                          vertical: AppDimens.h8,
                        ),
                        separatorBuilder: (_, _) => AppDimens.w12.wSpace,
                        itemBuilder: (context, index) => SizedBox(
                          width:
                              (constraints.maxWidth - (AppDimens.w16 * 2)) *
                              0.86,
                          child: const AnnouncementCard.shimmer(),
                        ),
                      ),
                    ),
                  )
                else if (validAnnouncements?.isNotEmpty ?? false)
                  SizedBox(
                    height: 196.h,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isSingleAnnouncement =
                            validAnnouncements!.length == 1;
                        final availableWidth =
                            constraints.maxWidth - (AppDimens.w16 * 2);

                        return ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: const {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                              PointerDeviceKind.trackpad,
                              PointerDeviceKind.stylus,
                            },
                          ),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: validAnnouncements.length,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimens.w16,
                              vertical: AppDimens.h8,
                            ),
                            separatorBuilder: (_, _) => AppDimens.w12.wSpace,
                            itemBuilder: (context, index) => SizedBox(
                              width: isSingleAnnouncement
                                  ? availableWidth
                                  : availableWidth * 0.86,
                              child: AnnouncementCard(
                                item: validAnnouncements[index],
                                onTap: () => showAnnouncementsPopup([
                                  validAnnouncements[index],
                                ]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      horizontal: AppDimens.w16,
                      vertical: AppDimens.h8,
                    ),
                    padding: EdgeInsets.symmetric(vertical: AppDimens.h24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppDimens.r16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppDimens.w12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            PhosphorIcons.megaphone,
                            size: 24,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: AppDimens.h16),
                        Text(
                          'Belum ada pengumuman',
                          style: context.textStyle.bodyMedium?.copyWith(
                            color: AppColors.labelSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnnouncementSlider extends StatefulWidget {
  final List<Announcement> announcements;
  const _AnnouncementSlider({super.key, required this.announcements});

  @override
  State<_AnnouncementSlider> createState() => _AnnouncementSliderState();
}

class _AnnouncementSliderState extends State<_AnnouncementSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: AppDimens.h8,
              left: AppDimens.w16,
              right: AppDimens.w16,
            ),
            child: Text(
              widget.announcements[_currentIndex].judul,
              style: context.textStyle.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.labelPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.announcements.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return AnnouncementDetailView(
                  announcement: widget.announcements[index],
                );
              },
            ),
          ),
          SizedBox(height: AppDimens.h16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.announcements.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppColors.primary
                      : AppColors.labelSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
