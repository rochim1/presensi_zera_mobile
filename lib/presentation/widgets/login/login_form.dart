import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:presensi_data/core/values/enum.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/_core.dart';
import '../../../injections.dart';
import '../../_presentation.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _fnUrl = FocusNode();
  final FocusNode _fnUsername = FocusNode();
  final FocusNode _fnPassword = FocusNode();
  late TextEditingController _urlController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late Env _environment;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: fl.values?.baseApi);
    _usernameController = TextEditingController(
      text: fl.env!.isDev ? 'pantoo' : '',
    );
    _passwordController = TextEditingController(
      text: fl.env!.isDev ? 'kuitansiku3' : '',
    );
    _environment = fl.env!;
    _loadSavedDevEndpoint();
  }

  Future<void> _loadSavedDevEndpoint() async {
    if (fl.env!.isDev) {
      final prefs = await SharedPreferences.getInstance();
      final savedUrl = prefs.getString('dev_base_url');
      if (savedUrl != null && savedUrl.isNotEmpty) {
        if (mounted) {
          setState(() {
            _urlController.text = savedUrl;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _fnUrl.dispose();
    _fnUsername.dispose();
    _fnPassword.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    // Handle environment configuration for development
    if (fl.env!.isDev) {
      await dotenv.load(fileName: ".env.development");
      if (_environment.isDev) {
        final newBaseApi = _urlController.text.trim();
        fl.baseApi = newBaseApi;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('dev_base_url', newBaseApi);
      }
    }

    if (mounted) {
      context.read<LoginSignInCubit>().login(
        LoginParamsEntity(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          rememberMe: true,
        ),
      );
    }

    // Unfocus all fields
    _fnUsername.unfocus();
    _fnPassword.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingLargeX),
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Brand Logo
              const BrandWidget(),

              // Form title
              Text(
                'Masuk ke Akun Anda',
                textAlign: TextAlign.center,
                style: context.textStyle.headlineSmall?.copyWith(
                  color: AppColors.labelPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: AppDimens.size3L),

              // Development URL field (only in dev mode)
              if (fl.env!.isDev) ...[
                TextFieldBasic(
                  controller: _urlController,
                  focusNode: _fnUrl,
                  title: 'Base URL',
                  hint: 'Masukan URL server',
                  prefixIcon: const Icon(Icons.link_rounded),
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.url,
                  autofillHints: const [AutofillHints.url],
                  validator: (String? value) {
                    return null;
                  },
                ),
                const SizedBox(height: AppDimens.size4M),
              ],

              // Username field
              TextFieldBasic(
                controller: _usernameController,
                focusNode: _fnUsername,
                title: 'Username/Email',
                hint: 'Masukan username atau email Anda',
                prefixIcon: const Icon(Icons.person_outline_rounded),
                inputAction: TextInputAction.next,
                inputType: TextInputType.emailAddress,
                autofillHints: const [
                  AutofillHints.username,
                  AutofillHints.email,
                ],
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return kEmptyValidator.rich(['Username/Email']);
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppDimens.size4M),

              // Password field
              TextFieldPassword(
                controller: _passwordController,
                focusNode: _fnPassword,
                title: 'Password',
                hint: 'Masukan password Anda',
                hasPrefixIcon: true,
                inputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return kEmptyValidator.rich(['Password']);
                  }
                  return null;
                },
                onSubmitted: (_) => _handleLogin(),
              ),

              const SizedBox(height: AppDimens.size3L),

              // Login button
              BlocBuilder<LoginSignInCubit, LoginSignInState>(
                builder: (_, state) {
                  return AppButton(
                    text: 'Masuk',
                    onPressed: _handleLogin,
                    isLoading: state.status.isLoading,
                  );
                },
              ),

              AppDimens.size3M.hSpace,
              _buildRegistrationLink(),

              AppDimens.sizeM.hSpace,
              _buildPrivacyPolicyLink(),

              AppDimens.sizeL.hSpace,
              _buildAdditionalOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Belum punya akun? ',
          style: context.textStyle.bodyMedium?.copyWith(
            color: AppColors.labelSecondary,
          ),
          children: [
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  context.router.push(const RegisterPageRoute());
                },
                child: Text(
                  'Daftar di sini',
                  style: context.textStyle.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: const [
        // Version info
        VersioningLogin(),
      ],
    );
  }

  Widget _buildPrivacyPolicyLink() {
    return Center(
      child: TextButton.icon(
        onPressed: () => AppUtility.launchLink(kUrlKebijakanPrivasi),
        icon: const Icon(Icons.privacy_tip_outlined, size: 18),
        label: const Text('Kebijakan Privasi'),
      ),
    );
  }
}
