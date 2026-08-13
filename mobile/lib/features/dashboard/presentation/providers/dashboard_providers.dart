import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/date_format.dart';
import '../../../attendance/domain/entities/attendance_record.dart';
import '../../../attendance/domain/repositories/attendance_repository.dart';
import '../../../attendance/presentation/providers/attendance_providers.dart';
import '../../../auth/domain/entities/role.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../departments/presentation/providers/department_providers.dart';
import '../../../employees/domain/usecases/get_employees.dart';
import '../../../employees/presentation/providers/employees_providers.dart';
import '../../../leave/domain/entities/leave_status.dart';
import '../../../leave/domain/repositories/leave_repository.dart';
import '../../../leave/presentation/providers/leave_providers.dart';
import '../../domain/entities/dashboard_summary.dart';

/// The dashboard, assembled from the other features' use cases.
///
/// Which numbers get fetched depends on the role, so an Employee never issues
/// the company-wide reads they would only be refused for.
final dashboardProvider = FutureProvider<DashboardSummary>((ref) async {
  final session = ref.watch(sessionProvider);
  if (session == null) {
    return const DashboardSummary(
      todayStatus: TodayStatus.notCheckedIn,
      stats: [],
    );
  }

  final todayStatus = DashboardSummary.statusFor(
    await _fetchToday(ref, session.employeeId),
  );

  final stats = switch (session.role) {
    Role.admin => await _adminStats(ref),
    Role.manager => await _managerStats(ref, session.employeeId),
    Role.employee => await _employeeStats(ref, session.employeeId),
  };

  return DashboardSummary(todayStatus: todayStatus, stats: stats);
});

Future<AttendanceRecord?> _fetchToday(Ref ref, int employeeId) async {
  final today = DateFormatting.today();
  final result = await ref.read(getAttendanceUseCaseProvider)(
    AttendanceFilters(
      employeeId: employeeId,
      startDate: today,
      endDate: today,
    ),
  );
  final records = result.getOrElse((failure) => throw failure);
  return records.isEmpty ? null : records.first;
}

Future<List<DashboardStat>> _adminStats(Ref ref) async {
  // Record `.wait` runs these together like the web page's Promise.all, but
  // keeps each result's type instead of collapsing to a common supertype.
  final (employeesResult, departmentsResult, pendingResult) = await (
    ref.read(getEmployeesUseCaseProvider)(const GetEmployeesParams()),
    ref.read(getDepartmentsUseCaseProvider)(const NoParams()),
    ref.read(getLeaveRequestsUseCaseProvider)(
      const LeaveFilters(status: LeaveStatus.pending),
    ),
  ).wait;

  final employees = employeesResult.getOrElse((failure) => throw failure);
  final departments = departmentsResult.getOrElse((failure) => throw failure);
  final pending = pendingResult.getOrElse((failure) => throw failure);

  return [
    DashboardStat(
      label: 'Active Employees',
      value: employees.where((e) => e.isActive).length,
      route: AppRoutes.employees,
    ),
    DashboardStat(
      label: 'Departments',
      value: departments.length,
      route: AppRoutes.departments,
    ),
    DashboardStat(
      label: 'Pending Leave Requests',
      value: pending.length,
      route: AppRoutes.leaveApprovals,
    ),
  ];
}

Future<List<DashboardStat>> _managerStats(Ref ref, int managerId) async {
  final (employeesResult, pendingResult) = await (
    ref.read(getEmployeesUseCaseProvider)(const GetEmployeesParams()),
    ref.read(getLeaveRequestsUseCaseProvider)(
      const LeaveFilters(status: LeaveStatus.pending),
    ),
  ).wait;

  final employees = employeesResult.getOrElse((failure) => throw failure);
  final pending = pendingResult.getOrElse((failure) => throw failure);

  // The API returns every pending request a Manager may see; only their own
  // direct reports' are theirs to act on, which is what the count promises.
  final teamIds = {
    for (final employee in employees)
      if (employee.managerId == managerId) employee.id,
  };

  return [
    DashboardStat(
      label: 'My Team',
      value: teamIds.length,
      route: AppRoutes.employees,
    ),
    DashboardStat(
      label: 'Pending Approvals',
      value: pending.where((r) => teamIds.contains(r.employeeId)).length,
      route: AppRoutes.leaveApprovals,
    ),
  ];
}

Future<List<DashboardStat>> _employeeStats(Ref ref, int employeeId) async {
  final result = await ref.read(getLeaveRequestsUseCaseProvider)(
    LeaveFilters(employeeId: employeeId, status: LeaveStatus.pending),
  );
  final pending = result.getOrElse((failure) => throw failure);

  return [
    DashboardStat(
      label: 'My Pending Requests',
      value: pending.length,
      route: AppRoutes.leave,
    ),
  ];
}
