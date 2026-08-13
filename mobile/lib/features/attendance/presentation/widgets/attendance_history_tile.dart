import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/attendance_status.dart';

/// One day's attendance row. [showEmployeeName] is on for the team view and
/// off for "my history", where it would just repeat the signed-in user.
class AttendanceHistoryTile extends StatelessWidget {
  const AttendanceHistoryTile({
    super.key,
    required this.record,
    this.showEmployeeName = false,
  });

  final AttendanceRecord record;
  final bool showEmployeeName;

  AppTone get _tone => switch (record.status) {
    AttendanceStatus.present => AppTone.success,
    AttendanceStatus.late => AppTone.warning,
    AttendanceStatus.halfDay => AppTone.warning,
    AttendanceStatus.onLeave => AppTone.info,
    AttendanceStatus.absent => AppTone.danger,
  };

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showEmployeeName) ...[
                  Text(
                    record.employeeName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  DateFormatting.date(record.workDate),
                  style: TextStyle(
                    fontSize: showEmployeeName ? 12.5 : 14,
                    fontWeight: showEmployeeName
                        ? FontWeight.w400
                        : FontWeight.w600,
                    color: showEmployeeName
                        ? AppColors.textMuted
                        : AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.login,
                      size: 13,
                      color: AppColors.textSubtle,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatting.time(record.checkInTime),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Icon(
                      Icons.logout,
                      size: 13,
                      color: AppColors.textSubtle,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatting.time(record.checkOutTime),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusPill(label: record.status.label, tone: _tone),
              const SizedBox(height: 6),
              Text(
                record.deviceType.label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSubtle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
