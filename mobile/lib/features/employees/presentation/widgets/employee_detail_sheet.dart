import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/employee.dart';

/// What the caller wants to do next after viewing an employee.
enum EmployeeDetailAction { edit, deactivate }

/// Read-only detail for everyone; admins also get Edit and Deactivate, which
/// pop with the chosen [EmployeeDetailAction] for the screen to carry out.
class EmployeeDetailSheet extends StatelessWidget {
  const EmployeeDetailSheet({
    super.key,
    required this.employee,
    required this.canManage,
  });

  final Employee employee;
  final bool canManage;

  String get _joined {
    final date = employee.createdAt.toLocal();
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: employee.fullName,
      subtitle: employee.email,
      actions: canManage
          ? Row(
              children: [
                if (employee.isActive) ...[
                  Expanded(
                    child: AppSecondaryButton(
                      label: 'Deactivate',
                      icon: Icons.person_off_outlined,
                      onPressed: () => Navigator.of(
                        context,
                      ).pop(EmployeeDetailAction.deactivate),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: AppButton(
                    label: 'Edit',
                    icon: Icons.edit_outlined,
                    onPressed: () =>
                        Navigator.of(context).pop(EmployeeDetailAction.edit),
                  ),
                ),
              ],
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(fullName: employee.fullName, radius: 26),
              const SizedBox(width: AppSpacing.lg),
              StatusPill(
                label: employee.isActive ? 'Active' : 'Inactive',
                tone: employee.isActive ? AppTone.success : AppTone.danger,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          DetailRow(label: 'Employee code', value: employee.employeeCode),
          DetailRow(label: 'Email', value: employee.email),
          DetailRow(label: 'Phone', value: employee.phoneNumber),
          DetailRow(label: 'Department', value: employee.departmentName),
          DetailRow(
            label: 'Role',
            trailing: Align(
              alignment: Alignment.centerLeft,
              child: StatusPill(
                label: employee.role.label,
                tone: AppTone.accent,
              ),
            ),
          ),
          DetailRow(label: 'Manager', value: employee.managerName),
          DetailRow(label: 'Joined', value: _joined),
        ],
      ),
    );
  }
}
