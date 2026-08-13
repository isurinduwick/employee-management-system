import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/employee.dart';
import '../providers/employee_form_provider.dart';
import '../providers/employees_providers.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_detail_sheet.dart';
import '../widgets/employee_form_sheet.dart';

/// The employee directory. Reads are open to any signed-in role; the create,
/// edit and deactivate affordances only appear for Admins, matching
/// `[Authorize(Roles = "Admin")]` on the API's write endpoints.
class EmployeesScreen extends ConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = ref.watch(employeesControllerProvider);
    final canManage = ref.watch(canManageEmployeesProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => _openForm(context, ref),
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.accentContrast,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('New employee'),
            )
          : null,
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () =>
            ref.read(employeesControllerProvider.notifier).refresh(),
        child: AsyncValueView<List<Employee>>(
          value: employees,
          loading: const ShimmerList(rows: 5, rowHeight: 104),
          errorTitle: "Couldn't load employees",
          onRetry: () => ref.invalidate(employeesControllerProvider),
          data: (list) => list.isEmpty
              ? _EmptyDirectory(canManage: canManage)
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    // Clears the FAB so the last row stays tappable.
                    canManage ? 88 : AppSpacing.lg,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final employee = list[index];
                    return EmployeeCard(
                      employee: employee,
                      onTap: () => _openDetail(context, ref, employee),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    Employee? employee,
  }) async {
    // Clears any error left from a previous save before the sheet opens.
    ref.read(employeeFormControllerProvider.notifier).reset();

    final saved = await showAppBottomSheet<Employee>(
      context: context,
      child: EmployeeFormSheet(employee: employee),
    );

    if (saved == null || !context.mounted) return;
    showAppSnackBar(
      context,
      employee == null
          ? '${saved.fullName} added.'
          : '${saved.fullName} updated.',
      tone: AppTone.success,
    );
  }

  Future<void> _openDetail(
    BuildContext context,
    WidgetRef ref,
    Employee employee,
  ) async {
    final canManage = ref.read(canManageEmployeesProvider);

    final action = await showAppBottomSheet<EmployeeDetailAction>(
      context: context,
      child: EmployeeDetailSheet(employee: employee, canManage: canManage),
    );
    if (action == null || !context.mounted) return;

    switch (action) {
      case EmployeeDetailAction.edit:
        await _openForm(context, ref, employee: employee);
      case EmployeeDetailAction.deactivate:
        await _deactivate(context, ref, employee);
    }
  }

  Future<void> _deactivate(
    BuildContext context,
    WidgetRef ref,
    Employee employee,
  ) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Deactivate ${employee.fullName}?',
      message:
          'They will no longer be able to sign in. Their attendance and '
          'leave history stays intact.',
      confirmLabel: 'Deactivate',
    );
    if (!confirmed || !context.mounted) return;

    final result = await ref
        .read(employeesControllerProvider.notifier)
        .deactivate(employee.id);
    if (!context.mounted) return;

    result.match(
      (failure) =>
          showAppSnackBar(context, failure.message, tone: AppTone.danger),
      (_) => showAppSnackBar(
        context,
        '${employee.fullName} deactivated.',
        tone: AppTone.success,
      ),
    );
  }
}

class _EmptyDirectory extends StatelessWidget {
  const _EmptyDirectory({required this.canManage});

  final bool canManage;

  @override
  Widget build(BuildContext context) {
    // ListView (rather than a bare Center) keeps pull-to-refresh working when
    // there is nothing to scroll.
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        EmptyView(
          icon: Icons.person_outline,
          title: 'No employees yet',
          message: canManage
              ? 'Add your first employee to get the directory started.'
              : null,
        ),
      ],
    );
  }
}
