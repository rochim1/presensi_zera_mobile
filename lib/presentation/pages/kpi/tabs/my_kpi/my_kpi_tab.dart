import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'bloc/my_kpi_cubit.dart';
import 'bloc/my_kpi_state.dart';
import 'widgets/kpi_assignment_card.dart';

@RoutePage()
class MyKpiTab extends StatelessWidget {
  const MyKpiTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MyKpiCubit>()..init(),
      child: const MyKpiView(),
    );
  }
}

class MyKpiView extends StatelessWidget {
  const MyKpiView({super.key});

  static const List<String> _statusFilters = [
    'Semua',
    'Draft',
    'Pengumpulan Data',
    'Self Assessment',
    'Menunggu Review',
    'Completed',
    'Acknowledged',
  ];

  static const Map<String, String?> _statusMap = {
    'Semua': null,
    'Draft': 'draft',
    'Pengumpulan Data': 'data_collection',
    'Self Assessment': 'self_review',
    'Menunggu Review': 'manager_review',
    'Completed': 'completed',
    'Acknowledged': 'acknowledged',
  };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyKpiCubit, MyKpiState>(
      listenWhen: (p, c) => p.actionState != c.actionState,
      listener: (context, state) {
        state.actionState.whenOrNull(
          failure: (f) {
            AppSnackbar.showError(context, f.message);
          },
          success: (_) {
            AppSnackbar.showSuccess(context, 'Berhasil acknowledge KPI');
          },
        );
      },
      builder: (context, state) {
        return AppInfiniteScrollView<KpiAssignment>(
          state: state.assignmentState,
          onRefresh: () async => context.read<MyKpiCubit>().fetchAssignments(),
          onFetchNext: () => context.read<MyKpiCubit>().fetchNextPage(),
          padding: EdgeInsets.zero,
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
                      ..._statusFilters.map(
                        (label) => AppFilterChip(
                          label: label,
                          isSelected: state.filterStatus == _statusMap[label],
                          onTap: () {
                            context.read<MyKpiCubit>().setFilterStatus(
                              _statusMap[label],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          itemBuilder: (context, assignment) {
            final assignmentId = assignment.id;
            final hasValidId = assignmentId != null && assignmentId.isNotEmpty;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: KpiAssignmentCard(
                assignment: assignment,
                onSelfAssessment: !hasValidId
                    ? null
                    : () {
                        context.router
                            .push(SelfAssessmentPageRoute(id: assignmentId))
                            .then((_) {
                              context.read<MyKpiCubit>().fetchAssignments();
                            });
                      },
                onAcknowledge: !hasValidId || state.actionState.isLoading
                    ? null
                    : () => _confirmAcknowledge(context, assignmentId),
                onDetail: !hasValidId
                    ? null
                    : () {
                        context.router.push(
                          SelfAssessmentPageRoute(id: assignmentId),
                        );
                      },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmAcknowledge(
    BuildContext context,
    String assignmentId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi KPI'),
        content: const Text(
          'Dengan mengakui hasil ini, status KPI akan berubah dan tidak dapat dikembalikan dari aplikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Akui Hasil'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<MyKpiCubit>().doAcknowledge(assignmentId);
    }
  }
}
