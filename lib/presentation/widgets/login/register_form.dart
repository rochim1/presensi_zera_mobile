import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';

import '../../../core/_core.dart';
import '../../_presentation.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  static const Duration _checkDebounceDuration = Duration(milliseconds: 500);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _fnName = FocusNode();
  final FocusNode _fnUsername = FocusNode();
  final FocusNode _fnEmail = FocusNode();
  final FocusNode _fnPhone = FocusNode();
  final FocusNode _fnPassword = FocusNode();
  final FocusNode _fnPasswordConfirm = FocusNode();

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _fnName.dispose();
    _fnUsername.dispose();
    _fnEmail.dispose();
    _fnPhone.dispose();
    _fnPassword.dispose();
    _fnPasswordConfirm.dispose();

    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    Debounce.cancel(kDebRegisterEmail);
    Debounce.cancel(kDebRegisterUsername);
    super.dispose();
  }

  Future<void> _handleRegister(RegisterCubit cubit) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    FocusScope.of(context).unfocus();

    final isAvailable = await cubit.ensureAvailability(
      email: _emailController.text,
      username: _usernameController.text,
    );
    if (!mounted) return;

    if (!isAvailable) {
      _formKey.currentState!.validate();
      return;
    }

    final params = RegisterParamsEntity(
      name: _nameController.text.trim(),
      telpNumber: _phoneController.text.trim(),
      username: cubit.sanitizeUsername(_usernameController.text),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      isAdmin: false,
    );

    Debounce.debounce(kDebForm, kDurSubmit, () {
      cubit.register(params);
    });
  }

  String? _validateName(String? value) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) {
      return kEmptyValidator.rich(['Nama Lengkap']);
    }
    if (val.length < 3) {
      return 'Nama Lengkap minimal 3 karakter';
    }
    return null;
  }

  String? _validateUsername(String? value, RegisterState state) {
    final val = (value ?? '').trim();
    if (val.isEmpty) {
      return kEmptyValidator.rich(['Username']);
    }
    if (val.length < 3) {
      return 'Username minimal 3 karakter';
    }
    if (state.isUsernameAvailable == false) {
      return 'Username sudah digunakan';
    }
    return null;
  }

  String? _validateEmail(String? value, RegisterState state) {
    final val = (value ?? '').trim();
    if (val.isEmpty) {
      return kEmptyValidator.rich(['Email']);
    }
    if (!val.regexEmail) {
      return 'Email tidak valid';
    }
    if (state.isEmailAvailable == false) {
      return 'Email sudah digunakan';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final val = (value ?? '').trim();
    if (val.isEmpty) {
      return kEmptyValidator.rich(['Nomor Telepon']);
    }
    if (!RegExp(r'^\d{8,15}$').hasMatch(val)) {
      return 'Nomor telepon harus 8-15 digit angka';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final val = value ?? '';
    if (val.isEmpty) {
      return kEmptyValidator.rich(['Password']);
    }
    if (val.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  String? _validatePasswordConfirmation(String? value) {
    final val = value ?? '';
    if (val.isEmpty) {
      return kEmptyValidator.rich(['Konfirmasi Password']);
    }
    if (val.length < 8) {
      return 'Konfirmasi Password minimal 8 karakter';
    }
    if (val != _passwordController.text) {
      return kNotMatch;
    }
    return null;
  }

  void _onUsernameChanged(RegisterCubit cubit, String value) {
    final sanitized = cubit.sanitizeUsername(value);
    if (sanitized != value) {
      _usernameController.value = TextEditingValue(
        text: sanitized,
        selection: TextSelection.collapsed(offset: sanitized.length),
      );
    }

    Debounce.debounce(kDebRegisterUsername, _checkDebounceDuration, () {
      cubit.checkUsernameAvailability(sanitized);
    });
  }

  void _onEmailChanged(RegisterCubit cubit, String value) {
    Debounce.debounce(kDebRegisterEmail, _checkDebounceDuration, () {
      cubit.checkEmailAvailability(value);
    });
  }

  Widget _buildAvailabilityIndicator(
    BuildContext context, {
    required bool isChecking,
    required bool? isAvailable,
    required String availableText,
    required String takenText,
  }) {
    if (isChecking) {
      return Padding(
        padding: const EdgeInsets.only(top: AppDimens.size2S),
        child: Row(
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.labelSecondary,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Memeriksa...',
              style: context.textStyle.bodySmall?.copyWith(
                color: AppColors.labelSecondary,
              ),
            ),
          ],
        ),
      );
    }
    if (isAvailable == true) {
      return Padding(
        padding: const EdgeInsets.only(top: AppDimens.size2S),
        child: Row(
          children: [
            const Icon(Icons.check_circle, size: 16, color: Colors.green),
            const SizedBox(width: 6),
            Text(
              availableText,
              style: context.textStyle.bodySmall?.copyWith(color: Colors.green),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingLargeX),
      child: AutofillGroup(
        child: BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            final cubit = context.read<RegisterCubit>();
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BrandWidget(),
                  Text(
                    'Daftar Akun Baru',
                    textAlign: TextAlign.center,
                    style: context.textStyle.headlineSmall?.copyWith(
                      color: AppColors.labelPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimens.sizeL),
                  Text(
                    'Lengkapi data berikut untuk membuat akun.',
                    textAlign: TextAlign.center,
                    style: context.textStyle.bodyMedium?.copyWith(
                      color: AppColors.labelSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimens.size3L),
                  TextFieldBasic(
                    controller: _nameController,
                    focusNode: _fnName,
                    title: 'Nama Lengkap',
                    hint: 'Masukkan nama lengkap',
                    required: true,
                    inputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    validator: _validateName,
                  ),
                  const SizedBox(height: AppDimens.size4M),
                  TextFieldBasic(
                    controller: _usernameController,
                    focusNode: _fnUsername,
                    title: 'Username',
                    hint: 'Masukkan username',
                    required: true,
                    inputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    validator: (value) => _validateUsername(value, state),
                    onChanged: (value) => _onUsernameChanged(cubit, value),
                  ),
                  _buildAvailabilityIndicator(
                    context,
                    isChecking: state.isCheckingUsername,
                    isAvailable: state.isUsernameAvailable,
                    availableText: 'Username tersedia',
                    takenText: 'Username sudah digunakan',
                  ),
                  const SizedBox(height: AppDimens.size4M),
                  TextFieldBasic(
                    controller: _emailController,
                    focusNode: _fnEmail,
                    title: 'Email',
                    hint: 'email@example.com',
                    required: true,
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) => _validateEmail(value, state),
                    onChanged: (value) => _onEmailChanged(cubit, value),
                  ),
                  _buildAvailabilityIndicator(
                    context,
                    isChecking: state.isCheckingEmail,
                    isAvailable: state.isEmailAvailable,
                    availableText: 'Email tersedia',
                    takenText: 'Email sudah digunakan',
                  ),
                  const SizedBox(height: AppDimens.size4M),
                  TextFieldBasic(
                    controller: _phoneController,
                    focusNode: _fnPhone,
                    title: 'Nomor Telepon',
                    hint: '08xxxxxxxxxx',
                    required: true,
                    inputType: TextInputType.phone,
                    inputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 15,
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: AppDimens.size4M),
                  TextFieldPassword(
                    controller: _passwordController,
                    focusNode: _fnPassword,
                    title: 'Password',
                    hint: 'Minimal 8 karakter',
                    inputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: AppDimens.size4M),
                  TextFieldPassword(
                    controller: _passwordConfirmController,
                    focusNode: _fnPasswordConfirm,
                    title: 'Konfirmasi Password',
                    hint: 'Ulangi password',
                    inputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: _validatePasswordConfirmation,
                    onSubmitted: (_) => _handleRegister(cubit),
                  ),
                  const SizedBox(height: AppDimens.size3L),
                  AppButton(
                    text: 'Daftar',
                    onPressed: () => _handleRegister(cubit),
                    isLoading: state.submitStatus.isLoading,
                  ),
                  const SizedBox(height: AppDimens.size3M),
                  Text.rich(
                    TextSpan(
                      text: 'Dengan mendaftar, Anda memahami ',
                      style: context.textStyle.bodySmall?.copyWith(
                        color: AppColors.labelSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Kebijakan Privasi Pantoo HRMS',
                          style: context.textStyle.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                AppUtility.launchLink(kUrlKebijakanPrivasi),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.size3M),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Sudah punya akun? ',
                        style: context.textStyle.bodyMedium?.copyWith(
                          color: AppColors.labelSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: 'Masuk di sini',
                            style: context.textStyle.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (context.router.canPop()) {
                                  context.router.pop();
                                } else {
                                  context.router.replace(LoginPageRoute());
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
