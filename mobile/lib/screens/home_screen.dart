import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../state/auth_state.dart';
import 'login_screen.dart';

// Placeholder authenticated landing — the real dashboard/nav shell is a
// later branch, same as the web app's own "placeholder Dashboard" step.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthState>().session!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EMS Mobile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              await context.read<AuthState>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome, ${session.fullName}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(roleToString(session.role), style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
