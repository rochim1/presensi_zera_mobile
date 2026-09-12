import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import 'package:intl/intl.dart';
import 'package:presensi_mobile/presentation/widgets/common/month_picker_bottom_sheet.dart';

import '../bloc/payroll_state.dart';
import '../widgets/payroll_slip_card.dart';

@RoutePage()
class MyPayrollPage extends StatelessWidget {
  const MyPayrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayrollCubit, PayrollState>(
      builder: (context, state) {
        final cubit = context.read<PayrollCubit>();

        return Scaffold(
          body: AppInfiniteScrollView<PayrollSlip>(
            onRefresh: () async => cubit.onRefresh(),
            state: state.payrollSlips,
            onFetchNext: cubit.fetchNextPage,
            itemBuilder: (context, item) => PayrollSlipCard(
              slip: item,
              onTap: () =>
                  context.router.push(PayrollDetailPageRoute(slipId: item.id)),
            ),
            separatorBuilder: (context, index) => AppDimens.h12.hSpace,
            loadingBuilder: (context) => SliverList.separated(
              itemBuilder: (context, index) => const PayrollSlipCard.shimmer(),
              separatorBuilder: (context, index) => AppDimens.h12.hSpace,
              itemCount: 5,
            ),
            sliversBefore: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: InkWell(
                    onTap: () {
                      MonthPickerBottomSheet.show(
                        context,
                        initialDate: state.filterDate ?? DateTime.now(),
                        onMonthSelected: (month) {
                          cubit.onChangeFilterDate(month);
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusMedium,
                        ),
                        border: Border.all(color: AppColors.dividerLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.date_range,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.filterDate != null
                                  ? DateFormat(
                                      'MMMM yyyy',
                                      'id_ID',
                                    ).format(state.filterDate!)
                                  : 'Bulan Ini',
                              style: context.textStyle.bodyMedium?.copyWith(
                                color: AppColors.labelPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.labelSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
