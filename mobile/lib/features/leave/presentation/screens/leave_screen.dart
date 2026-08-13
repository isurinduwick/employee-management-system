import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

/// Placeholder until the leave feature grows its own domain/data layers.
class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(
      title: 'Leave',
      icon: Icons.calendar_month_outlined,
    );
  }
}
