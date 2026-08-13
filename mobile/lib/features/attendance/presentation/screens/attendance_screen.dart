import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

/// Placeholder until the attendance feature grows its own domain/data layers.
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(
      title: 'Attendance',
      icon: Icons.schedule_outlined,
    );
  }
}
