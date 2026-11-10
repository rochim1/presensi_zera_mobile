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
import 'bloc/reimbursement_state.dart';

@RoutePage()
class ReimbursementPage extends StatelessWidget {
  final bool initialApproval;

  const ReimbursementPage({super.key, this.initialApproval = false});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<ReimbursementCubit>()..init(),
    child: ReimbursementView(initialApproval: initialApproval),
  );
}

class ReimbursementView extends StatefulWidget {
  final bool initialApproval;

  const ReimbursementView({super.key, this.initialApproval = false});
  @override
  State<ReimbursementView> createState() => _ReimbursementViewState();
}

class _ReimbursementViewState extends State<ReimbursementView> {
  late bool _showingApproval;

  @override
  void initState() {
    super.initState();
    _showingApproval = widget.initialApproval;
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ReimbursementCubit, ReimbursementState>(
        builder: (context, state) {
          final cubit = context.read<ReimbursementCubit>();
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
                    ? ('Approval Reimbursement').tr(context)
                    : ('Reimbursement').tr(context)),
                centerTitle: false,
                subtitle: (_showingApproval
                    ? ('Tinjau pengajuan reimbursement karyawan').tr(context)
                    : ('Kelola pengajuan reimbursement Anda').tr(context)),
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
                          ReimbursementRequestFormPageRoute(),
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
                          ? const ApprovalReimbursementPage(
                              key: ValueKey('reimbursement-approval'),
                            )
                          : const MyReimbursementPage(
                              key: ValueKey('my-reimbursement'),
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
  final ReimbursementState state;
  final ReimbursementCubit cubit;
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
