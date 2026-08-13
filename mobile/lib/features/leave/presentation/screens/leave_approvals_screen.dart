import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

/// Placeholder for the manager/admin leave approval queue.
class LeaveApprovalsScreen extends StatelessWidget {
  const LeaveApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(
      title: 'Leave Approvals',
      icon: Icons.fact_check_outlined,
    );
  }
}
