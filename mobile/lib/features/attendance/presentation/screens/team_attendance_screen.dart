import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

/// Placeholder for the manager/admin view of the team's attendance.
class TeamAttendanceScreen extends StatelessWidget {
  const TeamAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(
      title: 'Team Attendance',
      icon: Icons.groups_outlined,
    );
  }
}
