import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/leave_status.dart';

/// Maps a leave status onto the shared pill tones, so Approved/Rejected read
/// the same here as they do everywhere else in the app.
class LeaveStatusPill extends StatelessWidget {
  const LeaveStatusPill({super.key, required this.status});

  final LeaveStatus status;

  @override
  Widget build(BuildContext context) {
    return StatusPill(label: status.label, tone: _tone, icon: _icon);
  }

  AppTone get _tone => switch (status) {
    LeaveStatus.pending => AppTone.warning,
    LeaveStatus.approved => AppTone.success,
    LeaveStatus.rejected => AppTone.danger,
  };

  IconData get _icon => switch (status) {
    LeaveStatus.pending => Icons.schedule_outlined,
    LeaveStatus.approved => Icons.check_circle_outline,
    LeaveStatus.rejected => Icons.cancel_outlined,
  };
}
