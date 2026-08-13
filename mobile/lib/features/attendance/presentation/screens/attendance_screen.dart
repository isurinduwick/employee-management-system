import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/attendance_providers.dart';
import '../widgets/attendance_history_tile.dart';
import '../widgets/attendance_status_card.dart';

/// Self-service attendance: today's check-in/check-out status plus the
/// signed-in user's own history. Every role lands here — reads and check-ins
/// are always scoped to yourself at the API.
class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  Future<void> _checkIn(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(todayAttendanceProvider.notifier).checkIn();
    if (!context.mounted) return;
    result.match(
      (failure) =>
          showAppSnackBar(context, failure.message, tone: AppTone.danger),
      (_) => showAppSnackBar(context, 'Checked in.', tone: AppTone.success),
    );
  }

  Future<void> _checkOut(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(todayAttendanceProvider.notifier).checkOut();
    if (!context.mounted) return;
    result.match(
      (failure) =>
          showAppSnackBar(context, failure.message, tone: AppTone.danger),
      (_) => showAppSnackBar(context, 'Checked out.', tone: AppTone.success),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayAttendanceProvider);
    final history = ref.watch(myAttendanceHistoryProvider);
    final isSubmitting = today.isLoading && today.hasValue;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () => Future.wait([
          ref.read(todayAttendanceProvider.notifier).refresh(),
          ref.read(myAttendanceHistoryProvider.notifier).refresh(),
        ]),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            today.when(
              skipLoadingOnRefresh: true,
              data: (record) => AttendanceStatusCard(
                today: record,
                isSubmitting: isSubmitting,
                onCheckIn: () => _checkIn(context, ref),
                onCheckOut: () => _checkOut(context, ref),
              ),
              loading: () => const AppCard(
                child: SizedBox(height: 92, child: LoadingView()),
              ),
              error: (error, _) => ErrorView(
                message: "Couldn't load today's status.",
                onRetry: () => ref.invalidate(todayAttendanceProvider),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Recent history',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AsyncValueView(
              value: history,
              errorTitle: "Couldn't load attendance history",
              onRetry: () => ref.invalidate(myAttendanceHistoryProvider),
              loading: Column(
                children: List.generate(
                  3,
                  (_) => const Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: ShimmerBox(height: 92, radius: AppRadius.lg),
                  ),
                ),
              ),
              data: (records) => records.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xl),
                      child: EmptyView(
                        icon: Icons.schedule_outlined,
                        title: 'No attendance recorded yet',
                        message: 'Check in above to start your history.',
                      ),
                    )
                  : Column(
                      children: [
                        for (final record in records)
                          AttendanceHistoryTile(record: record),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
