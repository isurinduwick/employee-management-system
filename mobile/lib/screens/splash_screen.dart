import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'login_screen.dart';

// Shown while AuthState restores the persisted session from secure storage,
// then hands off to Home (already signed in) or Login (not signed in).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  void _navigateIfReady(AuthState auth) {
    if (_navigated || auth.isLoading) return;
    _navigated = true;

    final target = auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => target));
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    _navigateIfReady(auth);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.accent, Color(0xFF0B3F5F)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.business_center_rounded, size: 28, color: AppColors.accentContrast),
            ),
            const SizedBox(height: 18),
            const Text(
              'Employee MS',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.text, letterSpacing: -0.02),
            ),
            const SizedBox(height: 28),
            const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
