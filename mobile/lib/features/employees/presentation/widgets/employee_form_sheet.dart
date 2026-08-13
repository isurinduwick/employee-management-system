import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/domain/entities/role.dart';
import '../../../departments/domain/entities/department.dart';
import '../../../departments/presentation/providers/department_providers.dart';
import '../../domain/entities/employee.dart';
import '../../domain/entities/employee_draft.dart';
import '../providers/employee_form_provider.dart';
import '../providers/employees_providers.dart';

/// Create/edit sheet. Field rules mirror the backend's data annotations on
/// EmployeeCreateDto / EmployeeUpdateDto.
///
/// Pass [employee] to edit, or omit it to create. Returns the saved employee
/// to the caller, or null if the sheet was dismissed.
class EmployeeFormSheet extends ConsumerStatefulWidget {
  const EmployeeFormSheet({super.key, this.employee});

  final Employee? employee;

  static const codeMaxLength = 20;
  static const nameMaxLength = 100;
  static const passwordMinLength = 8;

  @override
  ConsumerState<EmployeeFormSheet> createState() => _EmployeeFormSheetState();
}

class _EmployeeFormSheetState extends ConsumerState<EmployeeFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final _codeController = TextEditingController(
    text: widget.employee?.employeeCode ?? '',
  );
  late final _firstNameController = TextEditingController(
    text: widget.employee?.firstName ?? '',
  );
  late final _lastNameController = TextEditingController(
    text: widget.employee?.lastName ?? '',
  );
  late final _emailController = TextEditingController(
    text: widget.employee?.email ?? '',
  );
  late final _phoneController = TextEditingController(
    text: widget.employee?.phoneNumber ?? '',
  );
  final _passwordController = TextEditingController();

  late int? _departmentId = widget.employee?.departmentId;
  late Role _role = widget.employee?.role ?? Role.employee;
  late int? _managerId = widget.employee?.managerId;
  late bool _isActive = widget.employee?.isActive ?? true;

  bool get _isEditing => widget.employee != null;

  @override
  void dispose() {
    _codeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    ref.read(employeeFormControllerProvider.notifier).reset();
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(employeeFormControllerProvider.notifier);
    final saved = _isEditing
        ? await controller.edit(
            widget.employee!.id,
            EmployeeEdit(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: _emailController.text,
              phoneNumber: _phoneController.text,
              departmentId: _departmentId!,
              role: _role,
              managerId: _managerId,
              isActive: _isActive,
            ),
          )
        : await controller.create(
            NewEmployee(
              employeeCode: _codeController.text,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: _emailController.text,
              password: _passwordController.text,
              phoneNumber: _phoneController.text,
              departmentId: _departmentId!,
              role: _role,
              managerId: _managerId,
            ),
          );

    if (saved == null || !mounted) return;
    Navigator.of(context).pop(saved);
  }

  @override
  Widget build(BuildContext context) {
    final departments = ref.watch(departmentsProvider);
    final isSubmitting = ref.watch(employeeFormControllerProvider).isLoading;
    final errorMessage = ref.watch(employeeFormErrorProvider);

    // An employee can't manage themselves — the API rejects it too.
    final managerOptions = [
      for (final candidate in ref.watch(employeesControllerProvider).valueOrNull ??
          <Employee>[])
        if (candidate.id != widget.employee?.id) candidate,
    ];

    return AppBottomSheet(
      title: _isEditing ? 'Edit employee' : 'New employee',
      subtitle: _isEditing
          ? "Update this employee's details, role or reporting line."
          : 'Create a login and assign the new hire to a department.',
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
            if (!_isEditing) ...[
              AppTextField(
                label: 'Employee code',
                hint: 'EMP-0001',
                controller: _codeController,
                enabled: !isSubmitting,
                maxLength: EmployeeFormSheet.codeMaxLength,
                textInputAction: TextInputAction.next,
                validator: Validators.notEmpty('Employee code'),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'First name',
                    controller: _firstNameController,
                    enabled: !isSubmitting,
                    maxLength: EmployeeFormSheet.nameMaxLength,
                    textInputAction: TextInputAction.next,
                    validator: Validators.notEmpty('First name'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppTextField(
                    label: 'Last name',
                    controller: _lastNameController,
                    enabled: !isSubmitting,
                    maxLength: EmployeeFormSheet.nameMaxLength,
                    textInputAction: TextInputAction.next,
                    validator: Validators.notEmpty('Last name'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Email',
              hint: 'you@company.com',
              controller: _emailController,
              enabled: !isSubmitting,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.all([
                Validators.notEmpty('Email'),
                Validators.email(),
              ]),
            ),
            if (!_isEditing) ...[
              const SizedBox(height: AppSpacing.lg),
              AppPasswordField(
                label: 'Password',
                hint: 'At least 8 characters',
                controller: _passwordController,
                enabled: !isSubmitting,
                textInputAction: TextInputAction.next,
                validator: Validators.all([
                  Validators.notEmpty('Password'),
                  (value) => (value ?? '').length < EmployeeFormSheet.passwordMinLength
                      ? 'Password must be at least '
                            '${EmployeeFormSheet.passwordMinLength} characters.'
                      : null,
                ]),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Phone number',
              hint: 'Optional',
              controller: _phoneController,
              enabled: !isSubmitting,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildDepartmentField(departments, isSubmitting),
            const SizedBox(height: AppSpacing.lg),
            AppDropdownField<Role>(
              label: 'Role',
              value: _role,
              enabled: !isSubmitting,
              items: Role.values,
              itemLabel: (role) => role.label,
              onChanged: (role) => setState(() => _role = role ?? _role),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppDropdownField<int?>(
              label: 'Manager',
              hint: 'No manager',
              value: _managerId,
              enabled: !isSubmitting,
              items: [null, for (final m in managerOptions) m.id],
              itemLabel: (id) {
                if (id == null) return 'No manager';
                final manager = managerOptions.firstWhere((m) => m.id == id);
                return '${manager.fullName} (${manager.role.label})';
              },
              onChanged: (id) => setState(() => _managerId = id),
            ),
            if (_isEditing) ...[
              const SizedBox(height: AppSpacing.lg),
              AppSwitchTile(
                label: 'Active',
                description: 'Inactive employees can no longer sign in.',
                value: _isActive,
                enabled: !isSubmitting,
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
            if (errorMessage != null) ...[
              const SizedBox(height: AppSpacing.lg),
              InlineMessage.error(errorMessage),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentField(
    AsyncValue<List<Department>> departments,
    bool isSubmitting,
  ) {
    return departments.when(
      data: (list) => AppDropdownField<int>(
        label: 'Department',
        hint: 'Select a department',
        value: _departmentId,
        enabled: !isSubmitting,
        items: [for (final department in list) department.id],
        itemLabel: (id) =>
            list.firstWhere((department) => department.id == id).name,
        onChanged: (id) => setState(() => _departmentId = id),
        validator: (value) => value == null ? 'Department is required.' : null,
      ),
      loading: () => const ShimmerBox(height: 52, radius: AppRadius.sm),
      // Without departments the form can't be completed, so say so rather
      // than showing an empty picker.
      error: (_, _) => const InlineMessage.error(
        "Couldn't load departments. Close and try again.",
      ),
    );
  }
}
