import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

/// Placeholder until the dashboard feature grows its own domain/data layers.
/// Build it out under `features/dashboard/` following `features/auth/`.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
    );
  }
}
