import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'state/auth_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const EmsApp());
}

class EmsApp extends StatelessWidget {
  final AuthState? authState;

  const EmsApp({super.key, this.authState});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => authState ?? AuthState(),
      child: MaterialApp(
        title: 'EMS Mobile',
        theme: AppTheme.light(),
        home: const SplashScreen(),
      ),
    );
  }
}
