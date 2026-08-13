import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

/// Placeholder until the employees feature grows its own domain/data layers.
class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(
      title: 'Employees',
      icon: Icons.person_outline,
    );
  }
}
