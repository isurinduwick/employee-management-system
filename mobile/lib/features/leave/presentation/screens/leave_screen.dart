import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/leave_providers.dart';
import '../widgets/leave_request_sheet.dart';
import '../widgets/leave_request_tile.dart';

/// Self-service leave: submit a request and track your own.
/// Every role lands here — requests are always for yourself at the API.
class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  Future<void> _request(BuildContext context, WidgetRef ref) async {
    final created = await showAppBottomSheet(
      context: context,
      child: const LeaveRequestSheet(),
    );

    if (created == null || !context.mounted) return;
    showAppSnackBar(
      context,
      'Leave request submitted.',
      tone: AppTone.success,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(myLeaveRequestsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _request(context, ref),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.accentContrast,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Request leave'),
      ),
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () => ref.read(myLeaveRequestsProvider.notifier).refresh(),
        child: AsyncValueView(
          value: requests,
          errorTitle: "Couldn't load your leave requests",
          onRetry: () => ref.invalidate(myLeaveRequestsProvider),
          loading: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: List.generate(
              3,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
                child: ShimmerBox(height: 104, radius: AppRadius.lg),
              ),
            ),
          ),
          data: (items) => items.isEmpty
              // Still scrollable, so pull-to-refresh works on an empty list.
              ? ListView(
                  padding: const EdgeInsets.only(top: 96),
                  children: const [
                    EmptyView(
                      icon: Icons.calendar_month_outlined,
                      title: 'No leave requests yet',
                      message: 'Request time off and track its status here.',
                    ),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    // Clear of the floating action button.
                    96,
                  ),
                  children: [
                    for (final request in items)
                      LeaveRequestTile(request: request),
                  ],
                ),
        ),
      ),
    );
  }
}
