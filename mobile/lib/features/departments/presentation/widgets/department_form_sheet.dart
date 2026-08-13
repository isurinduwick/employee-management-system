import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/department.dart';
import '../providers/department_form_provider.dart';

/// Create/edit sheet. Field rules mirror the backend's data annotations on
/// DepartmentCreateDto / DepartmentUpdateDto.
///
/// Pass [department] to edit, or omit it to create. Returns the saved
/// department to the caller, or null if the sheet was dismissed.
class DepartmentFormSheet extends ConsumerStatefulWidget {
  const DepartmentFormSheet({super.key, this.department});

  final Department? department;

  static const nameMaxLength = 100;

  @override
  ConsumerState<DepartmentFormSheet> createState() =>
      _DepartmentFormSheetState();
}

class _DepartmentFormSheetState extends ConsumerState<DepartmentFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final _nameController = TextEditingController(
    text: widget.department?.name ?? '',
  );

  bool get _isEditing => widget.department != null;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    ref.read(departmentFormControllerProvider.notifier).reset();
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(departmentFormControllerProvider.notifier);
    final saved = _isEditing
        ? await controller.edit(widget.department!.id, _nameController.text)
        : await controller.create(_nameController.text);

    if (saved == null || !mounted) return;
    Navigator.of(context).pop(saved);
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(departmentFormControllerProvider).isLoading;
    final errorMessage = ref.watch(departmentFormErrorProvider);

    return AppBottomSheet(
      title: _isEditing ? 'Edit department' : 'New department',
      subtitle: _isEditing
          ? "Update this department's name."
          : 'Create a department to start grouping employees.',
      actions: Row(
        children: [
          Expanded(
            child: AppSecondaryButton(
              label: 'Cancel',
              onPressed: isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: AppButton(
              label: 'Save',
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
            AppTextField(
              label: 'Department name',
              hint: 'Engineering',
              controller: _nameController,
              enabled: !isSubmitting,
              maxLength: DepartmentFormSheet.nameMaxLength,
              textInputAction: TextInputAction.done,
              validator: Validators.notEmpty('Department name'),
              onSubmitted: (_) => _submit(),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: AppSpacing.lg),
              InlineMessage.error(errorMessage),
            ],
          ],
        ),
      ),
    );
  }
}
