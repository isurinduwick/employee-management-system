import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/leave_request.dart';
import 'leave_status_pill.dart';

/// One leave request. [actions] carries the Approve/Reject pair on the
/// approvals queue, and is absent on the requester's own list.
class LeaveRequestTile extends StatelessWidget {
  const LeaveRequestTile({
    super.key,
    required this.request,
    this.showEmployeeName = false,
    this.actions,
  });

  final LeaveRequest request;

  /// The approvals queue spans everyone, so it needs the name; "my requests"
  /// would just repeat the signed-in user's own.
  final bool showEmployeeName;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showEmployeeName)
                        Text(request.employeeName, style: _nameStyle),
                      Text(request.leaveType.label, style: _typeStyle),
                      const SizedBox(height: 2),
                      Text(_dateRange, style: _metaStyle),
                    ],
                  ),
                ),
                LeaveStatusPill(status: request.status),
              ],
            ),
            if (request.reason != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(request.reason!, style: _reasonStyle),
            ],
            if (request.approvedByName != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${request.status.label} by ${request.approvedByName}',
                style: _metaStyle,
              ),
            ],
            if (actions != null) ...[
              const SizedBox(height: AppSpacing.md),
              actions!,
            ],
          ],
        ),
      ),
    );
  }

  /// "15 Aug — 18 Aug 2026 (4 days)", collapsing to a single date for a
  /// one-day request.
  String get _dateRange {
    final days = request.totalDays;
    if (DateFormatting.isSameDay(request.startDate, request.endDate)) {
      return '${DateFormatting.date(request.startDate)} (1 day)';
    }
    return '${DateFormatting.dateShort(request.startDate)} — '
        '${DateFormatting.date(request.endDate)} ($days days)';
  }

  static const _nameStyle = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const _typeStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const _metaStyle = TextStyle(fontSize: 13, color: AppColors.textMuted);
  static const _reasonStyle = TextStyle(fontSize: 13.5, color: AppColors.text);
}
