import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../departments/domain/entities/department.dart';
import '../../../departments/presentation/providers/department_providers.dart';
import '../../../employees/domain/entities/employee.dart';
import '../../../employees/presentation/providers/employees_providers.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../providers/attendance_providers.dart';

/// Employee / department / date-range filters for the Team Attendance screen.
/// Mirrors the web app's filter row: Apply commits the draft, Clear resets
/// both the draft and the applied filters.
class AttendanceFilterPanel extends ConsumerStatefulWidget {
  const AttendanceFilterPanel({super.key});

  @override
  ConsumerState<AttendanceFilterPanel> createState() =>
      _AttendanceFilterPanelState();
}

class _AttendanceFilterPanelState extends ConsumerState<AttendanceFilterPanel> {
  int? _employeeId;
  int? _departmentId;
  DateTime? _startDate;
  DateTime? _endDate;

  void _apply() {
    ref.read(teamAttendanceFiltersProvider.notifier).state = AttendanceFilters(
      employeeId: _employeeId,
      departmentId: _departmentId,
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  void _clear() {
    setState(() {
      _employeeId = null;
      _departmentId = null;
      _startDate = null;
      _endDate = null;
    });
    ref.read(teamAttendanceFiltersProvider.notifier).state =
        const AttendanceFilters();
  }

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(employeesControllerProvider).valueOrNull ?? const <Employee>[];
    final departments = ref.watch(departmentsProvider).valueOrNull ?? const <Department>[];

    return AppCard(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppDropdownField<int?>(
            label: 'Employee',
            hint: 'All employees',
            value: _employeeId,
            items: [null, for (final e in employees) e.id],
            itemLabel: (id) => id == null
                ? 'All employees'
                : employees.firstWhere((e) => e.id == id).fullName,
            onChanged: (id) => setState(() => _employeeId = id),
          ),
          const SizedBox(height: AppSpacing.md),
          AppDropdownField<int?>(
            label: 'Department',
            hint: 'All departments',
            value: _departmentId,
            items: [null, for (final d in departments) d.id],
            itemLabel: (id) => id == null
                ? 'All departments'
                : departments.firstWhere((d) => d.id == id).name,
            onChanged: (id) => setState(() => _departmentId = id),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppDateField(
                  label: 'From',
                  value: _startDate,
                  lastDate: _endDate,
                  onChanged: (date) => setState(() => _startDate = date),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppDateField(
                  label: 'To',
                  value: _endDate,
                  firstDate: _startDate,
                  onChanged: (date) => setState(() => _endDate = date),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppSecondaryButton(label: 'Apply', onPressed: _apply),
              ),
              const SizedBox(width: AppSpacing.md),
              TextButton(onPressed: _clear, child: const Text('Clear')),
            ],
          ),
        ],
      ),
    );
  }
}
