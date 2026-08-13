import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/leave_draft.dart';
import '../../domain/entities/leave_status.dart';
import '../providers/leave_form_provider.dart';

/// Request-leave sheet. Field rules mirror LeaveRequestCreateDto — a 500
/// character reason cap, and an end date that can't precede the start.
///
/// Returns the created request to the caller, or null if dismissed.
class LeaveRequestSheet extends ConsumerStatefulWidget {
  const LeaveRequestSheet({super.key});

  static const reasonMaxLength = 500;

  @override
  ConsumerState<LeaveRequestSheet> createState() => _LeaveRequestSheetState();
}

class _LeaveRequestSheetState extends ConsumerState<LeaveRequestSheet> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  LeaveType _leaveType = LeaveType.vacation;
  late DateTime _startDate = DateFormatting.today();
  late DateTime _endDate = DateFormatting.today();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  /// Keeps the range coherent as the user picks: moving the start past the
  /// end drags the end along, rather than leaving an invalid pair on screen.
  void _onStartChanged(DateTime value) {
    setState(() {
      _startDate = value;
      if (_endDate.isBefore(value)) _endDate = value;
    });
  }

  Future<void> _submit() async {
    ref.read(leaveFormControllerProvider.notifier).reset();
    if (!_formKey.currentState!.validate()) return;

    final created = await ref
        .read(leaveFormControllerProvider.notifier)
        .submit(
          NewLeaveRequest(
            leaveType: _leaveType,
            startDate: _startDate,
            endDate: _endDate,
            reason: _reasonController.text,
          ),
        );

    if (created == null || !mounted) return;
    Navigator.of(context).pop(created);
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(leaveFormControllerProvider).isLoading;
    final errorMessage = ref.watch(leaveFormErrorProvider);
    final days = _endDate.difference(_startDate).inDays + 1;

    return AppBottomSheet(
      title: 'Request leave',
      subtitle: 'Your manager reviews this before it takes effect.',
      actions: Row(
        children: [
          Expanded(
            child: AppSecondaryButton(
              label: 'Cancel',
              onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: AppButton(
              label: 'Submit',
              isLoading: isSubmitting,
              onPressed: _submit,
            ),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppDropdownField<LeaveType>(
              label: 'Leave type',
              value: _leaveType,
              items: LeaveType.values,
              itemLabel: (type) => type.label,
              enabled: !isSubmitting,
              onChanged: (type) => setState(() => _leaveType = type!),
            ),
            const SizedBox(height: AppSpacing.md),
            AppDateField(
              label: 'Start date',
              value: _startDate,
              enabled: !isSubmitting,
              onChanged: _onStartChanged,
            ),
            const SizedBox(height: AppSpacing.md),
            AppDateField(
              label: 'End date',
              value: _endDate,
              // Can't precede the start, so don't offer those dates at all.
              firstDate: _startDate,
              enabled: !isSubmitting,
              onChanged: (value) => setState(() => _endDate = value),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              days == 1 ? '1 day' : '$days days',
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Reason (optional)',
              hint: 'Anything your manager should know',
              controller: _reasonController,
              enabled: !isSubmitting,
              maxLength: LeaveRequestSheet.reasonMaxLength,
              maxLines: 3,
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),
              InlineMessage(message: errorMessage, tone: AppTone.danger),
            ],
          ],
        ),
      ),
    );
  }
}
