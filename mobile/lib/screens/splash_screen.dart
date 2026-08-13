import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
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

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_center_rounded, size: 56, color: Color(0xFF4F46E5)),
            SizedBox(height: 16),
            Text('Employee MS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            SizedBox(height: 24),
            SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
          ],
        ),
      ),
    );
  }
}
