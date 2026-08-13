import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/widgets/widgets.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/departments/presentation/providers/department_providers.dart';
import 'package:mobile/features/employees/presentation/providers/employees_providers.dart';
import 'package:mobile/features/employees/presentation/screens/employees_screen.dart';

import '../../helpers/fake_employee_data_sources.dart';
import '../../helpers/pump_app.dart';

/// Drives the directory through the real router, providers, use cases and
/// repository — only the HTTP data sources are faked.
void main() {
  List<Override> overridesFor(FakeEmployeeRemoteDataSource employees) => [
    employeeRemoteDataSourceProvider.overrideWithValue(employees),
    departmentRemoteDataSourceProvider.overrideWithValue(
      FakeDepartmentRemoteDataSource(),
    ),
  ];

  FakeEmployeeRemoteDataSource twoEmployees() => FakeEmployeeRemoteDataSource(
    employees: [
      employeeModelFor(id: 1, firstName: 'Ada', lastName: 'Byron'),
      employeeModelFor(
        id: 2,
        firstName: 'Grace',
        lastName: 'Hopper',
        role: Role.manager,
        isActive: false,
      ),
    ],
  );

  /// Admins reach the directory through the drawer, so this drives the real
  /// router. Non-admin roles have no Employees entry — those tests mount the
  /// screen directly with [pumpScreen].
  Future<FakeEmployeeRemoteDataSource> openDirectoryAsAdmin(
    WidgetTester tester, {
    FakeEmployeeRemoteDataSource? remote,
  }) async {
    final employees = remote ?? twoEmployees();
    await pumpAppAt(
      tester,
      Role.admin,
      'Employees',
      overrides: overridesFor(employees),
    );
    return employees;
  }

  testWidgets('lists employees fetched from the API', (tester) async {
    await openDirectoryAsAdmin(tester);

    expect(find.text('Ada Byron'), findsOneWidget);
    expect(find.text('Grace Hopper'), findsOneWidget);
    expect(find.text('EMP-0001'), findsOneWidget);
    // The deactivated employee is flagged rather than hidden.
    expect(find.text('Inactive'), findsOneWidget);
  });

  testWidgets('an admin gets the create affordance', (tester) async {
    await openDirectoryAsAdmin(tester);

    expect(find.text('New employee'), findsOneWidget);
  });

  testWidgets('a non-admin gets a read-only directory', (tester) async {
    await pumpScreen(
      tester,
      const EmployeesScreen(),
      as: Role.manager,
      overrides: overridesFor(twoEmployees()),
    );

    expect(find.text('Ada Byron'), findsOneWidget);
    // Writes are Admin-only at the API, so the button never appears.
    expect(find.text('New employee'), findsNothing);
  });

  testWidgets('tapping a row opens the detail sheet', (tester) async {
    await pumpScreen(
      tester,
      const EmployeesScreen(),
      as: Role.manager,
      overrides: overridesFor(twoEmployees()),
    );

    await tester.tap(find.text('Ada Byron'));
    await tester.pumpAndSettle();

    expect(find.text('Employee code'), findsOneWidget);
    expect(find.text('Department'), findsOneWidget);
    // Manager can look but not act.
    expect(find.text('Edit'), findsNothing);
    expect(find.text('Deactivate'), findsNothing);
  });

  testWidgets('an admin can deactivate from the detail sheet', (tester) async {
    final remote = await openDirectoryAsAdmin(tester);

    await tester.tap(find.text('Ada Byron'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deactivate'));
    await tester.pumpAndSettle();

    // The confirm dialog guards the destructive action.
    expect(find.textContaining('Deactivate Ada Byron?'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Deactivate'));
    await tester.pumpAndSettle();

    expect(remote.deactivatedId, 1);
    expect(find.text('Ada Byron deactivated.'), findsOneWidget);
  });

  testWidgets('an admin can create an employee through the sheet', (
    tester,
  ) async {
    final remote = await openDirectoryAsAdmin(tester);

    await tester.tap(find.text('New employee'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Employee code'),
      'EMP-0042',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'First name'),
      'Alan',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Last name'),
      'Turing',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'alan@company.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'enigma123',
    );

    // The picker sits below the fold; scroll it clear of the pinned actions
    // before tapping, or the tap lands on Cancel.
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -320),
    );
    await tester.pumpAndSettle();

    // The department options come from the departments endpoint.
    await tester.tap(find.byType(AppDropdownField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Engineering').last);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(remote.lastCreate?.employeeCode, 'EMP-0042');
    expect(remote.lastCreate?.email, 'alan@company.com');
    expect(remote.lastCreate?.departmentId, 1);
    // An omitted phone number goes out as absent, not as an empty string.
    expect(remote.lastCreate?.phoneNumber, isNull);

    expect(find.text('Alan Turing'), findsOneWidget);
    expect(find.text('Alan Turing added.'), findsOneWidget);
  });

  testWidgets('the sheet surfaces a rejected save without closing', (
    tester,
  ) async {
    final remote = await openDirectoryAsAdmin(tester);

    await tester.tap(find.text('New employee'));
    await tester.pumpAndSettle();

    // Missing required fields never reach the API.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Employee code is required.'), findsOneWidget);
    expect(find.text('Department is required.'), findsOneWidget);
    expect(remote.lastCreate, isNull);
    expect(find.text('New employee'), findsWidgets, reason: 'sheet stays open');
  });

  testWidgets('an empty directory explains itself', (tester) async {
    await openDirectoryAsAdmin(
      tester,
      remote: FakeEmployeeRemoteDataSource(employees: const []),
    );

    expect(find.text('No employees yet'), findsOneWidget);
    expect(
      find.text('Add your first employee to get the directory started.'),
      findsOneWidget,
    );
  });

  testWidgets('a failed load offers a retry', (tester) async {
    final remote = FakeEmployeeRemoteDataSource(
      error: DioException.connectionError(
        requestOptions: RequestOptions(path: '/employees'),
        reason: 'refused',
      ),
    );
    await openDirectoryAsAdmin(tester, remote: remote);

    expect(find.text("Couldn't load employees"), findsOneWidget);
    expect(
      find.text("Couldn't reach the server. Is the API running?"),
      findsOneWidget,
    );

    // Clearing the fault and retrying re-fetches through the same stack.
    remote.error = null;
    remote.employees = [employeeModelFor(id: 3, firstName: 'Alan')];
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Alan Cole'), findsOneWidget);
  });
}
