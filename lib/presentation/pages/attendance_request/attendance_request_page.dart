import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/widgets/common/month_picker_bottom_sheet.dart';
import 'bloc/attendance_request_state.dart';

@RoutePage()
class AttendanceRequestPage extends StatelessWidget {
  const AttendanceRequestPage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<AttendanceRequestCubit>()..init(),
    child: const AttendanceRequestView(),
  );
}

class AttendanceRequestView extends StatefulWidget {
  const AttendanceRequestView({super.key});
  @override
  State<AttendanceRequestView> createState() => _AttendanceRequestViewState();
}

class _AttendanceRequestViewState extends State<AttendanceRequestView> {
  bool _showingApproval = false;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AttendanceRequestCubit, AttendanceRequestState>(
        builder: (context, state) {
          final cubit = context.read<AttendanceRequestCubit>();
          return PopScope(
            canPop: !_showingApproval,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop && _showingApproval) {
                setState(() => _showingApproval = false);
              }
            },
            child: Scaffold(
              appBar: AppTopBar(
                title: _showingApproval
                    ? 'Approval Request Presensi'
                    : 'Request Presensi',
                backgroundColor: AppColors.transparent,
                onBackTap: _showingApproval
                    ? () => setState(() => _showingApproval = false)
                    : null,
                actions: [
                  AppApprovalNavigationButton(
                    showingApproval: _showingApproval,
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
                          AttendanceRequestFormPageRoute(),
                        );
                        if (result == true && context.mounted) {
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
                          ? const AttendanceRequestApprovalPage(
                              key: ValueKey('attendance-approval'),
                            )
                          : const MyAttendanceRequestPage(
                              key: ValueKey('my-attendance-request'),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}

class _MonthFilter extends StatelessWidget {
  final AttendanceRequestState state;
  final AttendanceRequestCubit cubit;
  const _MonthFilter({required this.state, required this.cubit});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: InkWell(
      onTap: () => MonthPickerBottomSheet.show(
        context,
        initialDate: state.startDate ?? DateTime.now(),
        onMonthSelected: (month) => cubit.applyFilters(
          startDate: DateTime(month.year, month.month, 1),
          endDate: DateTime(month.year, month.month + 1, 0),
          status: state.filterStatus,
          jenisRequest: state.filterJenisRequest,
        ),
      ),
      borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                state.startDate == null
                    ? 'Bulan Ini'
                    : DateFormat('MMMM yyyy', 'id_ID').format(state.startDate!),
                style: context.textStyle.bodyMedium?.copyWith(
                  color: AppColors.labelPrimary,
                ),
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
  );
}
