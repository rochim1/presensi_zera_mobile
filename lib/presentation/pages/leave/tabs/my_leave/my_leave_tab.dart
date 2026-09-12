import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/pages/leave/widgets/_widgets.dart';

import '../../bloc/leave_state.dart';
import 'bloc/my_leave_state.dart';

@RoutePage()
class MyLeavePage extends StatelessWidget {
  const MyLeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<MyLeaveCubit>()
            ..onChangeFilterDate(context.read<LeaveCubit>().state.filterDate),
      child: const MyLeaveView(),
    );
  }
}

class MyLeaveView extends StatelessWidget {
  const MyLeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LeaveCubit, LeaveState>(
          listenWhen: (previous, current) =>
              previous.filterDate != current.filterDate ||
              previous.startDate != current.startDate ||
              previous.endDate != current.endDate,
          listener: (context, state) {
            final cubit = context.read<MyLeaveCubit>();
            cubit.onParentFilterChanged(
              filterDate: state.filterDate,
              startDate: state.startDate,
              endDate: state.endDate,
            );
          },
        ),
        BlocListener<LeaveCubit, LeaveState>(
          listenWhen: (previous, current) =>
              previous.refreshCounter != current.refreshCounter,
          listener: (context, state) {
            context.read<MyLeaveCubit>().onRefresh();
          },
        ),
      ],
      child: BlocBuilder<MyLeaveCubit, MyLeaveState>(
        builder: (context, state) {
          final cubit = context.read<MyLeaveCubit>();

          void onTapLeaveRequestCard(LeaveRequest request) {
            AppBottomSheet.show(
              context: context,
              title: const _LeaveDetailTitle(),
              child: LeaveRequestDetailView(request: request),
              actionsBuilder: (sheetContext) => _LeaveDetailActions(
                canModify: request.status == LeaveStatus.diajukan,
                onEdit: () async {
                  Navigator.of(sheetContext).pop();
                  final result = await context.router.push(
                    LeaveRequestPageRoute(request: request),
                  );
                  if (!context.mounted) return;
                  if (result is DateTime) {
                    context.read<LeaveCubit>().applyFilters(
                      startDate: DateTime(result.year, result.month, 1),
                      endDate: DateTime(result.year, result.month + 1, 0),
                    );
                  } else {
                    await cubit.onRefresh();
                  }
                },
                onDelete: () async {
                  Navigator.of(sheetContext).pop();
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Hapus pengajuan cuti?'),
                      content: const Text(
                        'Pengajuan yang dihapus tidak dapat dikembalikan.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    final error = await cubit.deleteRequest(request.id);
                    if (context.mounted && error != null) {
                      AppBottomSheet.showError(
                        context: context,
                        titleText: 'Gagal menghapus',
                        message: error,
                      );
                    }
                  }
                },
                onClose: () => Navigator.of(sheetContext).pop(),
              ),
            );
          }

          return AppInfiniteScrollView<LeaveRequest>(
            onRefresh: cubit.onRefresh,
            state: state.leaveRequests,
            onFetchNext: cubit.fetchNextPage,
            itemBuilder: (context, item) => LeaveRequestCard(
              onTap: () => onTapLeaveRequestCard(item),
              leaveRequest: item,
              showUser: false,
            ),
            separatorBuilder: (context, index) => AppDimens.h12.hSpace,
            loadingBuilder: (context) => SliverList.separated(
              itemBuilder: (context, index) =>
                  const LeaveRequestCard.shimmer(showUser: false),
              separatorBuilder: (context, index) => AppDimens.h12.hSpace,
              itemCount: 5,
            ),
            sliversBefore: [
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppDimens.h16),
                    child: Row(
                      spacing: AppDimens.w8,
                      children: [
                        AppDimens.w8.wSpace,
                        AppFilterChip(
                          label: 'Semua',
                          isSelected: state.filterLeaveStatus == null,
                          onTap: () => cubit.onChangeFilterLeaveStatus(null),
                        ),
                        ...LeaveStatus.values.map(
                          (v) => AppFilterChip(
                            label: switch (v) {
                              LeaveStatus.diajukan => 'Pending',
                              LeaveStatus.diterima => 'Disetujui',
                              LeaveStatus.ditolak => 'Ditolak',
                            },
                            isSelected: state.filterLeaveStatus == v,
                            onTap: () => cubit.onChangeFilterLeaveStatus(v),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LeaveDetailTitle extends StatelessWidget {
  const _LeaveDetailTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Detail Cuti'),
        SizedBox(height: AppDimens.h2),
        Text(
          'Informasi pengajuan cuti',
          style: context.textStyle.bodySmall?.copyWith(
            color: AppColors.labelSecondary,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _LeaveDetailActions extends StatelessWidget {
  final bool canModify;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const _LeaveDetailActions({
    required this.canModify,
    required this.onEdit,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppDimens.w8,
      children: [
        Expanded(
          child: _LeaveDetailActionItem(
            icon: Icons.delete_outline_rounded,
            label: 'Hapus',
            color: AppColors.danger,
            onTap: canModify ? onDelete : null,
          ),
        ),
        Expanded(
          child: _LeaveDetailActionItem(
            icon: Icons.edit_outlined,
            label: 'Edit',
            color: AppColors.primary,
            onTap: canModify ? onEdit : null,
          ),
        ),
        Expanded(
          child: _LeaveDetailActionItem(
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

class _LeaveDetailActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _LeaveDetailActionItem({
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
