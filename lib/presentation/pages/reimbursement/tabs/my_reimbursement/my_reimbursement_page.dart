import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import '../../bloc/reimbursement_state.dart';
import '../../widgets/_widgets.dart';
import 'bloc/my_reimbursement_state.dart';

@RoutePage()
class MyReimbursementPage extends StatelessWidget {
  const MyReimbursementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MyReimbursementCubit>()
        ..onChangeFilterDate(
          context.read<ReimbursementCubit>().state.filterDate,
        ),
      child: const MyReimbursementView(),
    );
  }
}

class MyReimbursementView extends StatelessWidget {
  const MyReimbursementView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReimbursementCubit, ReimbursementState>(
          listenWhen: (prev, curr) =>
              prev.filterDate != curr.filterDate ||
              prev.startDate != curr.startDate ||
              prev.endDate != curr.endDate,
          listener: (context, state) {
            context.read<MyReimbursementCubit>().onChangeFilterDate(
              state.filterDate,
            );
          },
        ),
        BlocListener<ReimbursementCubit, ReimbursementState>(
          listenWhen: (prev, curr) =>
              prev.refreshCounter != curr.refreshCounter,
          listener: (context, state) {
            context.read<MyReimbursementCubit>().onRefresh();
          },
        ),
      ],
      child: BlocBuilder<MyReimbursementCubit, MyReimbursementState>(
        builder: (context, state) {
          final cubit = context.read<MyReimbursementCubit>();

          void onTapReimbursementCard(Reimbursement reimbursement) {
            AppBottomSheet.show(
              context: context,
              title: const AppBottomSheetTitle(title: 'Detail Reimbursement'),
              child: ReimbursementDetailView(reimbursement: reimbursement),
              actionsBuilder: (sheetContext) => AppFlatSheetActions(
                actions: [
                  AppFlatSheetAction(
                    icon: Icons.delete_outline_rounded,
                    label: 'Hapus',
                    color: AppColors.danger,
                    onTap: reimbursement.statusReimbursement == 'diajukan'
                        ? () async {
                            Navigator.of(sheetContext).pop();
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Hapus reimbursement?'),
                                content: const Text(
                                  'Pengajuan yang dihapus tidak dapat dikembalikan.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              final error = await cubit.deleteRequest(
                                reimbursement.id,
                              );
                              if (context.mounted && error != null) {
                                AppBottomSheet.showError(
                                  context: context,
                                  titleText: 'Gagal menghapus',
                                  message: error,
                                );
                              }
                            }
                          }
                        : null,
                  ),
                  AppFlatSheetAction(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    color: AppColors.primary,
                    onTap: reimbursement.statusReimbursement == 'diajukan'
                        ? () async {
                            Navigator.of(sheetContext).pop();
                            await context.router.push(
                              ReimbursementRequestFormPageRoute(
                                request: reimbursement,
                              ),
                            );
                            await cubit.onRefresh();
                          }
                        : null,
                  ),
                  AppFlatSheetAction(
                    icon: Icons.close_rounded,
                    label: 'Tutup',
                    color: AppColors.labelSecondary,
                    onTap: () => Navigator.of(sheetContext).pop(),
                  ),
                ],
              ),
            );
          }

          return AppInfiniteScrollView<Reimbursement>(
            state: state.reimbursements,
            onRefresh: () async => cubit.onRefresh(),
            onFetchNext: () => cubit.fetchNextPage(),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.w16,
              vertical: AppDimens.paddingSmallX,
            ),
            itemBuilder: (context, reimbursement) => ReimbursementCard(
              reimbursement: reimbursement,
              showUser: false,
              onTap: () => onTapReimbursementCard(reimbursement),
            ),
            loadingBuilder: (context) => SliverList.separated(
              itemBuilder: (context, index) =>
                  ReimbursementCard.shimmer(showUser: false),
              separatorBuilder: (context, index) => AppDimens.h12.hSpace,
              itemCount: 10,
            ),
            separatorBuilder: (context, index) => AppDimens.h12.hSpace,
          );
        },
      ),
    );
  }
}
