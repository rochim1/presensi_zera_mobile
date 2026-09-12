import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';

import 'bloc/announcement_cubit.dart';
import 'bloc/announcement_state.dart';
import '../home/widgets/announcement_card.dart';
import '../home/widgets/announcement_detail_view.dart';
import 'widgets/create_announcement_sheet.dart';

@RoutePage()
class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AnnouncementCubit>()..init(),
      child: const AnnouncementView(),
    );
  }
}

class AnnouncementView extends StatefulWidget {
  const AnnouncementView({super.key});

  @override
  State<AnnouncementView> createState() => _AnnouncementViewState();
}

class _AnnouncementViewState extends State<AnnouncementView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canCreateAnnouncement = context.select<AppCubit, bool>(
      (cubit) =>
          cubit.state.user.data?.hasPermission(
            'pengumuman',
            action: 'create',
          ) ??
          false,
    );
    final canUpdateAnnouncement = context.select<AppCubit, bool>(
      (cubit) =>
          cubit.state.user.data?.hasPermission(
            'pengumuman',
            action: 'update',
          ) ??
          false,
    );
    final canDeleteAnnouncement = context.select<AppCubit, bool>(
      (cubit) =>
          cubit.state.user.data?.hasPermission(
            'pengumuman',
            action: 'delete',
          ) ??
          false,
    );

    Future<String?> saveUpdate(
      Announcement announcement,
      Map<String, dynamic> input,
    ) async {
      try {
        await sl<AnnouncementRemoteDatasource>().updateAnnouncement(
          announcement.id,
          input,
        );
        if (context.mounted) {
          await context.read<AnnouncementCubit>().onRefresh();
        }
        return null;
      } catch (error) {
        return error.toString();
      }
    }

    void showAnnouncementPopup(Announcement announcement) {
      AppBottomSheet.show(
        context: context,
        title: AppBottomSheetTitle(
          title: announcement.judul,
          subtitle: 'Informasi pengumuman perusahaan',
        ),
        child: AnnouncementDetailView(announcement: announcement),
        actionsBuilder: (sheetContext) => _AnnouncementDetailActions(
          canDelete: canDeleteAnnouncement,
          canEdit: canUpdateAnnouncement,
          onDelete: () async {
            Navigator.of(sheetContext).pop();
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Hapus Pengumuman?'),
                content: Text(
                  'Pengumuman "${announcement.judul}" akan dihapus.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('Batal'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            );
            if (confirmed != true || !context.mounted) return;
            try {
              await sl<AnnouncementRemoteDatasource>().deleteAnnouncement(
                announcement.id,
              );
              if (!context.mounted) return;
              await context.read<AnnouncementCubit>().onRefresh();
              if (context.mounted) {
                AppSnackbar.showSuccess(context, 'Pengumuman berhasil dihapus');
              }
            } catch (error) {
              if (context.mounted) {
                AppSnackbar.showError(
                  context,
                  'Gagal menghapus pengumuman: $error',
                );
              }
            }
          },
          onEdit: () {
            Navigator.of(sheetContext).pop();
            CreateAnnouncementSheet.show(
              context,
              initialAnnouncement: announcement,
              onSubmit: (input) => saveUpdate(announcement, input),
            );
          },
          onClose: () => Navigator.of(sheetContext).pop(),
        ),
      );
    }

    return Scaffold(
      appBar: AppTopBar(
        title: 'Pengumuman',
        showBackButton: true,
        onBackTap: () => context.router.maybePop(),
        backgroundColor: AppColors.transparent,
      ),
      floatingActionButton: canCreateAnnouncement
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              onPressed: () => CreateAnnouncementSheet.show(
                context,
                onSubmit: (input) async {
                  try {
                    await sl<AnnouncementRemoteDatasource>().createAnnouncement(
                      input,
                    );
                    if (context.mounted) {
                      await context.read<AnnouncementCubit>().onRefresh();
                    }
                    return null;
                  } catch (error) {
                    return error.toString();
                  }
                },
              ),
              child: const Icon(Icons.add, color: AppColors.white),
            )
          : null,
      body: BlocBuilder<AnnouncementCubit, AnnouncementState>(
        builder: (context, state) {
          final cubit = context.read<AnnouncementCubit>();

          Widget buildList(bool Function(Announcement) filter) {
            final filteredData = state.announcements.data
                .where(filter)
                .toList();
            final filteredState = BasePaginatedState.success(
              data: filteredData,
              page: state.announcements.currentPage,
              hasReachedMax: state.announcements.hasReachedMax,
            );

            return AppInfiniteScrollView<Announcement>(
              state: state.announcements.isLoading
                  ? const BasePaginatedState.loading()
                  : filteredState,
              onRefresh: () async => cubit.onRefresh(),
              onFetchNext: () => cubit.fetchNextPage(),
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.w16,
                vertical: AppDimens.paddingSmallX,
              ),
              itemBuilderWithIndex: (context, announcement, index) =>
                  AnnouncementCard(
                    item: announcement,
                    onTap: () => showAnnouncementPopup(announcement),
                  ),
              loadingBuilder: (context) => SliverList.separated(
                itemBuilder: (context, index) =>
                    const AnnouncementCard.shimmer(),
                separatorBuilder: (context, index) => AppDimens.h12.hSpace,
              ),
              separatorBuilder: (context, index) => AppDimens.h12.hSpace,
            );
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  child: ColoredBox(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.w16,
                        vertical: AppDimens.paddingSmallX,
                      ),
                      child: AppTabBar(
                        tabs: const [
                          'Semua',
                          'Aktif / Berjalan',
                          'Akan Datang',
                          'Berakhir',
                        ],
                        isScrollable: true,
                        currentIndex: _tabController.index,
                        onTap: (index) {
                          _tabController.animateTo(index);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                buildList((_) => true),
                buildList((a) {
                  final status = a.status.toLowerCase();
                  return status.contains('aktif') ||
                      status.contains('berjalan');
                }),
                buildList((a) {
                  final status = a.status.toLowerCase();
                  return status.contains('akan datang') ||
                      status.contains('upcoming');
                }),
                buildList((a) {
                  final status = a.status.toLowerCase();
                  return status.contains('berakhir') ||
                      status.contains('ended') ||
                      status.contains('selesai');
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnnouncementDetailActions extends StatelessWidget {
  final bool canDelete;
  final bool canEdit;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onClose;

  const _AnnouncementDetailActions({
    required this.canDelete,
    required this.canEdit,
    required this.onDelete,
    required this.onEdit,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppDimens.w8,
      children: [
        Expanded(
          child: _AnnouncementDetailActionItem(
            icon: Icons.delete_outline_rounded,
            label: 'Hapus',
            color: AppColors.danger,
            onTap: canDelete ? onDelete : null,
          ),
        ),
        Expanded(
          child: _AnnouncementDetailActionItem(
            icon: Icons.edit_outlined,
            label: 'Edit',
            color: AppColors.primary,
            onTap: canEdit ? onEdit : null,
          ),
        ),
        Expanded(
          child: _AnnouncementDetailActionItem(
            icon: Icons.close_rounded,
            label: 'Tutup',
            color: AppColors.labelSecondary,
            onTap: onClose,
          ),
        ),
      ],
    );
  }
}

class _AnnouncementDetailActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _AnnouncementDetailActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = onTap == null
        ? AppColors.labelSecondary.withValues(alpha: 0.35)
        : color;
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.r10),
        side: BorderSide(color: AppColors.dividerLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimens.h12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppDimens.iconSmall, color: effectiveColor),
              SizedBox(width: AppDimens.w6),
              Text(
                label,
                style: context.textStyle.bodyMedium?.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  static const double _height = 64.0;

  const _StickyTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) => true;
}
