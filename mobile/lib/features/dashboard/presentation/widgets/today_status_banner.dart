import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/dashboard_summary.dart';

/// Today's attendance state, with the action that moves it along. Same three
/// copy states as the web dashboard's banner.
class TodayStatusBanner extends StatelessWidget {
  const TodayStatusBanner({super.key, required this.status});

  final TodayStatus status;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _tone.background,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              Icons.schedule_outlined,
              size: 19,
              color: _tone.foreground,
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
                // Nothing left to do once the day is closed.
                if (status != TodayStatus.checkedOut) ...[
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: status == TodayStatus.notCheckedIn
                        ? 'Check in'
                        : 'Go to attendance',
                    onPressed: () => context.go(AppRoutes.attendance),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppTone get _tone => switch (status) {
    TodayStatus.notCheckedIn => AppTone.warning,
    TodayStatus.checkedIn => AppTone.accent,
    TodayStatus.checkedOut => AppTone.success,
  };

  String get _title => switch (status) {
    TodayStatus.notCheckedIn => "You haven't checked in today",
    TodayStatus.checkedIn => "You're checked in for today",
    TodayStatus.checkedOut => "Today's attendance is complete",
  };

  String get _hint => switch (status) {
    TodayStatus.notCheckedIn => 'Record your arrival to start the day.',
    TodayStatus.checkedIn => 'Remember to check out when you finish.',
    TodayStatus.checkedOut =>
      'Your check-in and check-out are both recorded.',
  };

  static const _titleStyle = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const _hintStyle = TextStyle(fontSize: 13, color: AppColors.textMuted);
}
