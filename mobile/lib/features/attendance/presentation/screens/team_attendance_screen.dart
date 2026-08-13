import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/attendance_record.dart';
import '../providers/attendance_providers.dart';
import '../widgets/attendance_filter_panel.dart';
import '../widgets/attendance_history_tile.dart';

/// Manager/Admin view of the team's attendance: the same records as the
/// self-service Attendance screen, filtered by employee, department and
/// date range. Mirrors frontend/src/pages/Attendance.tsx, which renders this
/// filter row on the same page for these two roles rather than a separate one.
class TeamAttendanceScreen extends ConsumerWidget {
  const TeamAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canView = ref.watch(canViewTeamAttendanceProvider);
    if (!canView) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: MessageView(
          icon: Icons.lock_outline,
          title: 'Not available',
          message: 'Team attendance is only visible to managers and admins.',
        ),
      );
    }

    final records = ref.watch(teamAttendanceProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async => ref.invalidate(teamAttendanceProvider),
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          children: [
            const AttendanceFilterPanel(),
            const SizedBox(height: AppSpacing.lg),
            AsyncValueView<List<AttendanceRecord>>(
              value: records,
              errorTitle: "Couldn't load attendance",
              onRetry: () => ref.invalidate(teamAttendanceProvider),
              loading: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  children: List.generate(
                    3,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: ShimmerBox(height: 92, radius: AppRadius.lg),
                    ),
                  ),
                ),
              ),
              data: (list) => list.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xl),
                      child: EmptyView(
                        icon: Icons.groups_outlined,
                        title: 'No attendance records found',
                        message:
                            'Try widening the date range or clearing the filters.',
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          for (final record in list)
                            AttendanceHistoryTile(
                              record: record,
                              showEmployeeName: true,
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
