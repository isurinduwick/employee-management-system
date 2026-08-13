import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/login_form_provider.dart';

/// The credential form itself, split from the screen so the screen stays a
/// layout shell and this stays the piece with the rules.
///
/// Field lengths match the web Login page (frontend/src/pages/Login.tsx) and,
/// through it, the backend's validation attributes.
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  static const emailMinLength = 4;
  static const emailMaxLength = 40;
  static const passwordMinLength = 6;
  static const passwordMaxLength = 12;

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // A stale server-side error next to freshly edited fields is confusing.
    ref.read(loginFormControllerProvider.notifier).clearError();

    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(loginFormControllerProvider.notifier)
        .submit(
          email: _emailController.text,
          password: _passwordController.text,
        );
    // No navigation here: the router redirects as soon as the session lands.
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(loginFormControllerProvider).isLoading;
    final errorMessage = ref.watch(loginErrorProvider);
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Align keeps the mark a 40x40 tile — the Column stretches its
            // children to full width otherwise.
            const Align(
              alignment: Alignment.centerLeft,
              child: BrandMark(glow: true),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Welcome back',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.025,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Sign in to continue to your workspace',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 28),
            AppTextField(
              label: 'Email',
              hint: 'you@company.com',
              controller: _emailController,
              enabled: !isSubmitting,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              maxLength: LoginForm.emailMaxLength,
              validator: Validators.all([
                Validators.notEmpty('Email'),
                Validators.lengthBetween(
                  'Email',
                  LoginForm.emailMinLength,
                  LoginForm.emailMaxLength,
                ),
                Validators.email(),
              ]),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppPasswordField(
              label: 'Password',
              hint: '••••••••',
              controller: _passwordController,
              enabled: !isSubmitting,
              textInputAction: TextInputAction.done,
              maxLength: LoginForm.passwordMaxLength,
              validator: Validators.all([
                Validators.notEmpty('Password'),
                Validators.lengthBetween(
                  'Password',
                  LoginForm.passwordMinLength,
                  LoginForm.passwordMaxLength,
                ),
              ]),
              onSubmitted: (_) => _submit(),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: AppSpacing.lg),
              InlineMessage.error(errorMessage),
            ],
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Sign in',
              isLoading: isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
