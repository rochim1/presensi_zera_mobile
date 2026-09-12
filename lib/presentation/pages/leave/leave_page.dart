import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/widgets/common/month_picker_bottom_sheet.dart';

import 'bloc/leave_state.dart';

@RoutePage()
class LeavePage extends StatelessWidget {
  const LeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LeaveCubit>()..init(),
      child: const LeaveView(),
    );
  }
}

class LeaveView extends StatefulWidget {
  const LeaveView({super.key});

  @override
  State<LeaveView> createState() => _LeaveViewState();
}

class _LeaveViewState extends State<LeaveView> {
  bool _showingApproval = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveCubit, LeaveState>(
      builder: (context, state) {
        final cubit = context.read<LeaveCubit>();

        return PopScope(
          canPop: !_showingApproval,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && _showingApproval) {
              setState(() => _showingApproval = false);
            }
          },
          child: Scaffold(
            appBar: AppTopBar(
              title: _showingApproval ? 'Approval Cuti' : 'Cuti',
              centerTitle: false,
              subtitle: _showingApproval
                  ? 'Tinjau pengajuan cuti karyawan'
                  : 'Kelola pengajuan cuti Anda',
              onBackTap: _showingApproval
                  ? () => setState(() => _showingApproval = false)
                  : null,
              actions: [
                AppApprovalNavigationButton(
                  showingApproval: _showingApproval,
                  returnLabel: 'Cuti Saya',
                  onTap: () =>
                      setState(() => _showingApproval = !_showingApproval),
                ),
              ],
            ),
            floatingActionButton: _showingApproval
                ? null
                : FloatingActionButton(
                    backgroundColor: AppColors.primary,
                    shape: const CircleBorder(),
                    onPressed: () async {
                      final result = await context.router.push(
                        LeaveRequestPageRoute(),
                      );
                      if (!context.mounted) return;
                      if (result is DateTime) {
                        cubit.applyFilters(
                          startDate: DateTime(result.year, result.month, 1),
                          endDate: DateTime(result.year, result.month + 1, 0),
                        );
                        cubit.triggerRefresh();
                      } else if (result == true) {
                        cubit.triggerRefresh();
                      }
                    },
                    child: const Icon(Icons.add, color: AppColors.white),
                  ),
            body: Column(
              children: [
                _MonthFilter(state: state, cubit: cubit),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: _showingApproval
                        ? const LeaveApprovalPage(
                            key: ValueKey('leave-approval'),
                          )
                        : const MyLeavePage(key: ValueKey('my-leave')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MonthFilter extends StatelessWidget {
  final LeaveState state;
  final LeaveCubit cubit;

  const _MonthFilter({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.w16,
        AppDimens.h16,
        AppDimens.w16,
        AppDimens.h8,
      ),
      child: InkWell(
        onTap: () {
          MonthPickerBottomSheet.show(
            context,
            initialDate: state.startDate ?? DateTime.now(),
            onMonthSelected: (month) {
              cubit.applyFilters(
                startDate: DateTime(month.year, month.month, 1),
                endDate: DateTime(month.year, month.month + 1, 0),
              );
            },
          );
        },
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.w16,
            vertical: AppDimens.h14,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            border: Border.all(color: AppColors.dividerLight),
          ),
          child: Row(
            children: [
              const Icon(Icons.date_range, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.startDate != null
                      ? DateFormat(
                          'MMMM yyyy',
                          'id_ID',
                        ).format(state.startDate!)
                      : 'Bulan Ini',
                  style: context.textStyle.bodyMedium?.copyWith(
                    color: AppColors.labelPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.labelSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
