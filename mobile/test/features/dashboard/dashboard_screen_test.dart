import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failure.dart';
import 'package:mobile/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:mobile/features/departments/presentation/providers/department_providers.dart';
import 'package:mobile/features/employees/presentation/providers/employees_providers.dart';
import 'package:mobile/features/leave/presentation/providers/leave_providers.dart';

import '../../helpers/fake_attendance_data_sources.dart';
import '../../helpers/fake_auth_data_sources.dart';
import '../../helpers/fake_employee_data_sources.dart';
import '../../helpers/fake_leave_data_sources.dart';
import '../../helpers/pump_app.dart';

void main() {
  /// Boots straight onto the dashboard — it is the app's landing route.
  Future<void> pumpDashboard(
    WidgetTester tester, {
    required Role as,
    FakeEmployeeRemoteDataSource? employees,
    FakeLeaveRemoteDataSource? leave,
    FakeAttendanceRemoteDataSource? attendance,
  }) async {
    await pumpApp(
      tester,
      session: sessionModelFor(as),
      overrides: [
        employeeRemoteDataSourceProvider.overrideWithValue(
          employees ?? FakeEmployeeRemoteDataSource(),
        ),
        // Only the Admin dashboard reads departments, but the override has to
        // be in place for every role — an un-faked source reaches the network.
        departmentRemoteDataSourceProvider.overrideWithValue(
          FakeDepartmentRemoteDataSource(),
        ),
        leaveRemoteDataSourceProvider.overrideWithValue(
          leave ?? FakeLeaveRemoteDataSource(),
        ),
        attendanceRemoteDataSourceProvider.overrideWithValue(
          attendance ?? FakeAttendanceRemoteDataSource(),
        ),
      ],
    );
  }

  group('greeting', () {
    test('changes with the time of day', () {
      expect(DashboardScreen.greeting(DateTime(2026, 4, 1, 9)), 'Good morning');
      expect(
        DashboardScreen.greeting(DateTime(2026, 4, 1, 14)),
        'Good afternoon',
      );
      expect(DashboardScreen.greeting(DateTime(2026, 4, 1, 20)), 'Good evening');
    });
  });

  testWidgets('an admin sees company-wide counts', (tester) async {
    await pumpDashboard(
      tester,
      as: Role.admin,
      employees: FakeEmployeeRemoteDataSource(
        employees: [
          employeeModelFor(id: 1),
          employeeModelFor(id: 2),
          // Deactivated staff are excluded from "Active Employees".
          employeeModelFor(id: 3, isActive: false),
        ],
      ),
      leave: FakeLeaveRemoteDataSource(
        requests: [leaveModelFor(id: 1), leaveModelFor(id: 2)],
      ),
    );

    expect(find.text('Active Employees'), findsOneWidget);
    expect(find.text('2'), findsWidgets);
    expect(find.text('Departments'), findsOneWidget);
    expect(find.text('Pending Leave Requests'), findsOneWidget);
  });

  testWidgets("a manager's counts are scoped to their own reports", (
    tester,
  ) async {
    await pumpDashboard(
      tester,
      as: Role.manager,
      employees: FakeEmployeeRemoteDataSource(
        employees: [
          // sessionModelFor gives the manager employeeId 1.
          employeeModelFor(id: 10, managerId: 1),
          employeeModelFor(id: 11, managerId: 1),
          // Someone else's report — must not be counted.
          employeeModelFor(id: 12, managerId: 99),
        ],
      ),
      leave: FakeLeaveRemoteDataSource(
        requests: [
          leaveModelFor(id: 1, employeeId: 10),
          // Pending, but not from this manager's team.
          leaveModelFor(id: 2, employeeId: 12),
        ],
      ),
    );

    expect(find.text('My Team'), findsOneWidget);
    expect(find.text('Pending Approvals'), findsOneWidget);
    // Two reports, but only one of the pending requests is theirs to decide.
    expect(find.text('2'), findsWidgets);
    expect(find.text('1'), findsWidgets);
    // Admin-only figures never appear.
    expect(find.text('Departments'), findsNothing);
  });

  testWidgets('an employee only sees their own pending requests', (
    tester,
  ) async {
    await pumpDashboard(
      tester,
      as: Role.employee,
      leave: FakeLeaveRemoteDataSource(
        requests: [leaveModelFor(id: 1, employeeId: 1)],
      ),
    );

    expect(find.text('My Pending Requests'), findsOneWidget);
    expect(find.text('Active Employees'), findsNothing);
    expect(find.text('My Team'), findsNothing);
    // Reviewing is a Manager/Admin action.
    expect(find.text('Review approvals'), findsNothing);
  });

  testWidgets('the banner reflects today and offers the next step', (
    tester,
  ) async {
    await pumpDashboard(tester, as: Role.employee);
    expect(find.text("You haven't checked in today"), findsOneWidget);
    expect(find.text('Check in'), findsOneWidget);
  });

  testWidgets('a completed day offers no attendance action', (tester) async {
    final now = DateTime.now();
    await pumpDashboard(
      tester,
      as: Role.employee,
      attendance: FakeAttendanceRemoteDataSource(
        records: [
          todayAttendanceModel(
            checkInTime: now.subtract(const Duration(hours: 8)),
            checkOutTime: now,
          ),
        ],
      ),
    );

    expect(find.text("Today's attendance is complete"), findsOneWidget);
    expect(find.text('Check in'), findsNothing);
    expect(find.text('Go to attendance'), findsNothing);
  });

  testWidgets('a failed load offers a retry', (tester) async {
    await pumpDashboard(
      tester,
      as: Role.admin,
      leave: FakeLeaveRemoteDataSource(error: const NetworkFailure()),
    );

    expect(find.text('Try again'), findsWidgets);
  });
}
