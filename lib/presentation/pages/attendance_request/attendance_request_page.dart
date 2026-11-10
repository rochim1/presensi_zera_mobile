import 'package:presensi_mobile/l10n/app_language_controller.dart';
import 'package:presensi_mobile/l10n/hr_localization.dart';
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
  final bool initialApproval;

  const AttendanceRequestPage({super.key, this.initialApproval = false});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<AttendanceRequestCubit>()..init(),
    child: AttendanceRequestView(initialApproval: initialApproval),
  );
}

class AttendanceRequestView extends StatefulWidget {
  final bool initialApproval;

  const AttendanceRequestView({super.key, this.initialApproval = false});
  @override
  State<AttendanceRequestView> createState() => _AttendanceRequestViewState();
}

class _AttendanceRequestViewState extends State<AttendanceRequestView> {
  late bool _showingApproval;

  @override
  void initState() {
    super.initState();
    _showingApproval = widget.initialApproval;
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AttendanceRequestCubit, AttendanceRequestState>(
        builder: (context, state) {
          final cubit = context.read<AttendanceRequestCubit>();
          return PopScope(
            canPop: !_showingApproval || widget.initialApproval,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop && _showingApproval) {
                setState(() => _showingApproval = false);
              }
            },
            child: Scaffold(
              appBar: AppTopBar(
                title: (_showingApproval
                    ? ('Approval Request Presensi').tr(context)
                    : ('Request Presensi').tr(context)),
                centerTitle: false,
                subtitle: (_showingApproval
                    ? ('Tinjau pengajuan koreksi presensi karyawan').tr(context)
                    : ('Kelola pengajuan koreksi presensi Anda').tr(context)),
                onBackTap: _showingApproval && !widget.initialApproval
                    ? () => setState(() => _showingApproval = false)
                    : null,
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
              child: HrText(
                state.startDate == null
                    ? 'Bulan Ini'
                    : DateFormat(
                        'MMMM yyyy',
                        AppLanguageController
                            .instance
                            .effectiveLocale
                            .languageCode,
                      ).format(state.startDate!),
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
