import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';

import 'bloc/loan_list_cubit.dart';
import 'bloc/loan_list_state.dart';
import 'widgets/loan_card.dart';

@RoutePage()
class LoanPage extends StatelessWidget {
  const LoanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoanListCubit>()..init(),
      child: const LoanView(),
    );
  }
}

class LoanView extends StatelessWidget {
  const LoanView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppCubit>().state.user.data;
    return Scaffold(
      appBar: AppTopBar(
        title: 'Pinjaman (Loan)',
        showBackButton: true,
        onBackTap: () => context.router.maybePop(),
        backgroundColor: AppColors.transparent,
      ),
      body: BlocBuilder<LoanListCubit, LoanListState>(
        builder: (context, state) {
          final cubit = context.read<LoanListCubit>();

          return AppInfiniteScrollView<EmployeeLoan>(
            state: state.loans,
            onRefresh: () async => cubit.onRefresh(),
            onFetchNext: () => cubit.fetchNextPage(),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.w16,
              vertical: AppDimens.paddingSmallX,
            ),
            itemBuilderWithIndex: (context, loan, index) => LoanCard(
              item: loan,
              onTap: () {
                context.router.push(LoanDetailPageRoute(loan: loan));
              },
            ),
            loadingBuilder: (context) => SliverList.separated(
              itemBuilder: (context, index) => const LoanCard.shimmer(),
              separatorBuilder: (context, index) => AppDimens.h12.hSpace,
            ),
            separatorBuilder: (context, index) => AppDimens.h12.hSpace,
          );
        },
      ),
      floatingActionButton:
          (user?.hasPermission('loan', action: 'create') ?? false)
          ? FloatingActionButton.extended(
              onPressed: () async {
                final submitted = await context.router.push<bool>(
                  const LoanFormPageRoute(),
                );
                if (submitted == true && context.mounted) {
                  context.read<LoanListCubit>().onRefresh();
                }
              },
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Ajukan Pinjaman',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
