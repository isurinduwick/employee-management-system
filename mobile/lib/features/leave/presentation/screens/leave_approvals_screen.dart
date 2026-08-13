import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/entities/leave_status.dart';
import '../providers/leave_providers.dart';
import '../widgets/leave_request_tile.dart';

/// The approval queue (Manager/Admin). A Manager can only decide on their own
/// direct reports — the API answers 403 otherwise, and that message is shown
/// as-is rather than guessed at here.
class LeaveApprovalsScreen extends ConsumerWidget {
  const LeaveApprovalsScreen({super.key});

  Future<void> _decide(
    BuildContext context,
    WidgetRef ref,
    LeaveRequest request,
    LeaveDecision decision,
  ) async {
    final isApproval = decision == LeaveDecision.approved;
    final confirmed = await showConfirmDialog(
      context: context,
      title: isApproval ? 'Approve leave?' : 'Reject leave?',
      message:
          '${request.employeeName} — ${request.leaveType.label}, '
          '${request.totalDays} day(s). This cannot be undone.',
      confirmLabel: isApproval ? 'Approve' : 'Reject',
      isDestructive: !isApproval,
    );
    if (!confirmed || !context.mounted) return;

    final result = await ref
        .read(pendingLeaveRequestsProvider.notifier)
        .decide(request.id, decision);

    if (!context.mounted) return;
    result.match(
      (failure) => showAppSnackBar(context, failure.message, tone: AppTone.danger),
      (_) => showAppSnackBar(
        context,
        isApproval ? 'Leave approved.' : 'Leave rejected.',
        tone: isApproval ? AppTone.success : AppTone.neutral,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(pendingLeaveRequestsProvider);
    final filter = ref.watch(approvalsStatusFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _StatusFilterBar(
            selected: filter,
            onChanged: (value) =>
                ref.read(approvalsStatusFilterProvider.notifier).state = value,
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.accent,
              onRefresh: () =>
                  ref.read(pendingLeaveRequestsProvider.notifier).refresh(),
              child: AsyncValueView(
                value: requests,
                errorTitle: "Couldn't load leave requests",
                onRetry: () => ref.invalidate(pendingLeaveRequestsProvider),
                loading: ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: List.generate(
                    3,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: ShimmerBox(height: 128, radius: AppRadius.lg),
                    ),
                  ),
                ),
                data: (items) => items.isEmpty
                    ? ListView(
                        padding: const EdgeInsets.only(top: 80),
                        children: [
                          EmptyView(
                            icon: Icons.fact_check_outlined,
                            title: filter == LeaveStatus.pending
                                ? 'Nothing waiting on you'
                                : 'No ${filter?.label.toLowerCase() ?? ''} requests',
                            message: filter == LeaveStatus.pending
                                ? 'New requests from your team appear here.'
                                : 'Try a different status filter.',
                          ),
                        ],
                      )
                    : ListView(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        children: [
                          for (final request in items)
                            LeaveRequestTile(
                              request: request,
                              showEmployeeName: true,
                              // Only a pending request can still be decided;
                              // the API answers 409 on a second decision.
                              actions: request.isPending
                                  ? _DecisionButtons(
                                      onApprove: () => _decide(
                                        context,
                                        ref,
                                        request,
                                        LeaveDecision.approved,
                                      ),
                                      onReject: () => _decide(
                                        context,
                                        ref,
                                        request,
                                        LeaveDecision.rejected,
                                      ),
                                    )
                                  : null,
                            ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pending / Approved / Rejected / All. Pending is the default, since it is
/// the only status a decision can act on.
class _StatusFilterBar extends StatelessWidget {
  const _StatusFilterBar({required this.selected, required this.onChanged});

  final LeaveStatus? selected;
  final ValueChanged<LeaveStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = <(String, LeaveStatus?)>[
      ('Pending', LeaveStatus.pending),
      ('Approved', LeaveStatus.approved),
      ('Rejected', LeaveStatus.rejected),
      ('All', null),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final (label, status) in options)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  label: Text(label),
                  selected: selected == status,
                  onSelected: (_) => onChanged(status),
                  showCheckmark: false,
                  backgroundColor: AppColors.surface2,
                  selectedColor: AppColors.accentSoft,
                  side: BorderSide(
                    color: selected == status
                        ? AppColors.accent
                        : AppColors.border,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected == status
                        ? AppColors.accent
                        : AppColors.textMuted,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DecisionButtons extends StatelessWidget {
  const _DecisionButtons({required this.onApprove, required this.onReject});

  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSecondaryButton(label: 'Reject', onPressed: onReject),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: AppButton(label: 'Approve', onPressed: onApprove)),
      ],
    );
  }
}
