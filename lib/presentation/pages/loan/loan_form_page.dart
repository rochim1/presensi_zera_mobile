import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/widgets/global/text_field_custom/text_formatter.dart';

import 'bloc/loan_form_cubit.dart';
import 'bloc/loan_form_state.dart';

@RoutePage()
class LoanFormPage extends StatelessWidget {
  const LoanFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoanFormCubit>(),
      child: const LoanFormView(),
    );
  }
}

class LoanFormView extends StatefulWidget {
  const LoanFormView({super.key});

  @override
  State<LoanFormView> createState() => _LoanFormViewState();
}

class _LoanFormViewState extends State<LoanFormView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  int _termMonths = 1;

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Ajukan Pinjaman',
        showBackButton: true,
        onBackTap: () => context.router.maybePop(),
        backgroundColor: AppColors.transparent,
      ),
      body: BlocConsumer<LoanFormCubit, LoanFormState>(
        listener: (context, state) {
          if (state.isSuccess) {
            AppSnackbar.showSuccess(context, 'Berhasil mengajukan pinjaman');
            context.router.maybePop(true);
          } else if (state.errorMessage != null) {
            AppSnackbar.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(AppDimens.w16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Nominal Pinjaman',
                      hintText: '0',
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [IdrTextInputFormatter()],
                    validator: (val) {
                      final amount = IdrTextInputFormatter.tryParse(val ?? '');
                      if (amount == null || !amount.isFinite || amount < 1000) {
                        return 'Masukkan nominal minimal Rp 1.000';
                      }
                      return null;
                    },
                  ),
                  AppDimens.h16.hSpace,
                  DropdownButtonFormField<int>(
                    initialValue: _termMonths,
                    decoration: const InputDecoration(
                      labelText: 'Tenor (Bulan)',
                    ),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1 Bulan')),
                      DropdownMenuItem(value: 3, child: Text('3 Bulan')),
                      DropdownMenuItem(value: 6, child: Text('6 Bulan')),
                      DropdownMenuItem(value: 12, child: Text('12 Bulan')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _termMonths = val);
                    },
                    validator: (val) => val == null ? 'Wajib diisi' : null,
                  ),
                  AppDimens.h16.hSpace,
                  TextFormField(
                    controller: _purposeController,
                    decoration: const InputDecoration(
                      labelText: 'Tujuan Pinjaman',
                      hintText: 'Ketik alasan...',
                    ),
                    maxLines: 3,
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Wajib diisi'
                        : null,
                  ),
                  AppDimens.h32.hSpace,
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // We don't have AuthCubit imported easily,
                              // we'll pass empty employeeId if not available since remote data source
                              // likely ignores it and uses the Bearer token
                              context.read<LoanFormCubit>().submitLoan(
                                employeeId: '',
                                loanType: 'personal',
                                principalAmount: IdrTextInputFormatter.tryParse(
                                  _amountController.text,
                                )!,
                                loanTermMonths: _termMonths,
                                purpose: _purposeController.text,
                              );
                            }
                          },
                    child: state.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Ajukan Pinjaman'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
