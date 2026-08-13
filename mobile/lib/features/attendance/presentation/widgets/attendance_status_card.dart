import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/attendance_record.dart';

/// Today's check-in/check-out status, mirroring the web app's status card:
/// three copy states (not checked in / checked in / complete) with the
/// matching action enabled.
class AttendanceStatusCard extends StatelessWidget {
  const AttendanceStatusCard({
    super.key,
    required this.today,
    required this.isSubmitting,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  final AttendanceRecord? today;
  final bool isSubmitting;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  @override
  Widget build(BuildContext context) {
    final canCheckIn = !isSubmitting && today == null;
    final canCheckOut = !isSubmitting && today != null && !today!.hasCheckedOut;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.schedule_outlined,
              size: 19,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_title, style: _titleStyle),
                const SizedBox(height: 2),
                Text(_hint, style: _hintStyle),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Check In',
                        isLoading: isSubmitting && today == null,
                        onPressed: canCheckIn ? onCheckIn : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppSecondaryButton(
                        label: 'Check Out',
                        onPressed: canCheckOut ? onCheckOut : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _title {
    if (today == null) return "You haven't checked in today";
    if (!today!.hasCheckedOut) {
      return 'Checked in at ${DateFormatting.time(today!.checkInTime)}';
    }
    return 'Checked in at ${DateFormatting.time(today!.checkInTime)} — '
        'checked out at ${DateFormatting.time(today!.checkOutTime)}';
  }

  String get _hint {
    if (today == null) return 'Check in to start recording today\'s hours.';
    if (!today!.hasCheckedOut) return "Don't forget to check out.";
    return "Today's attendance is complete.";
  }

  static const _titleStyle = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const _hintStyle = TextStyle(fontSize: 13, color: AppColors.textMuted);
}
