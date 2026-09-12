import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/widgets/_widgets.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'bloc/team_kpi_cubit.dart';
import 'bloc/team_kpi_state.dart';
import 'widgets/team_summary_cards.dart';
import 'widgets/team_assignment_card.dart';

@RoutePage()
class TeamKpiTab extends StatelessWidget {
  const TeamKpiTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TeamKpiCubit>()..init(),
      child: const TeamKpiView(),
    );
  }
}

class TeamKpiView extends StatelessWidget {
  const TeamKpiView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamKpiCubit, TeamKpiState>(
      builder: (context, state) {
        return AppInfiniteScrollView<KpiAssignment>(
          state: state.assignmentState,
          onRefresh: () async => context.read<TeamKpiCubit>().init(),
          onFetchNext: () => context.read<TeamKpiCubit>().fetchNextPage(),
          padding: EdgeInsets.zero,
          sliversBefore: [
            // Summary Section
            SliverToBoxAdapter(
              child: state.summaryState.when(
                initial: () => const SizedBox(),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                failure: (f) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(f.message, textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () =>
                              context.read<TeamKpiCubit>().fetchSummary(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                ),
                success: (summary) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TeamSummaryCards(summary: summary),
                ),
              ),
            ),
            // Section title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Daftar KPI Tim',
                  style: context.textStyle.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
              child: TeamAssignmentCard(
                assignment: assignment,
                onReview: !hasValidId
                    ? null
                    : () {
                        context.router
                            .push(KpiReviewPageRoute(id: assignmentId))
                            .then((_) {
                              context.read<TeamKpiCubit>().init();
                            });
                      },
                onDetail: !hasValidId
                    ? null
                    : () {
                        context.router.push(
                          KpiReviewPageRoute(id: assignmentId),
                        );
                      },
              ),
            );
          },
        );
      },
    );
  }
}
