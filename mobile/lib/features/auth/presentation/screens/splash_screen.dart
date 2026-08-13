import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';

/// Shown while the stored session is being restored.
///
/// Purely visual — `routerProvider`'s redirect moves on to the shell or the
/// login screen as soon as `authControllerProvider` settles.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BrandMark(size: 56, glow: true),
            const SizedBox(height: 18),
            Text(
              'Employee MS',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.02,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 28),
            const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
