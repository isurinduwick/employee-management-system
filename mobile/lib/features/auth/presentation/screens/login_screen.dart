import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/login_form.dart';

/// Hosts [LoginForm] on the centred card. The router decides when this screen
/// is shown; it never navigates on its own.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: const AppCard(
                elevated: true,
                radius: AppRadius.xl,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 34),
                child: LoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
