import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/departments/data/models/department_model.dart';
import 'package:mobile/features/departments/presentation/providers/department_providers.dart';
import 'package:mobile/features/departments/presentation/screens/departments_screen.dart';

import '../../helpers/fake_employee_data_sources.dart';
import '../../helpers/pump_app.dart';

/// Drives the department list through the real router, providers, use cases
/// and repository — only the HTTP data source is faked.
void main() {
  List<Override> overridesFor(FakeDepartmentRemoteDataSource departments) => [
    departmentRemoteDataSourceProvider.overrideWithValue(departments),
  ];

  FakeDepartmentRemoteDataSource twoDepartments() =>
      FakeDepartmentRemoteDataSource(
        departments: const [
          DepartmentModel(id: 1, name: 'Engineering', employeeCount: 2),
          DepartmentModel(id: 2, name: 'People Ops', employeeCount: 0),
        ],
      );

  /// Admins reach the list through the drawer, so this drives the real
  /// router. Non-admin roles have no Departments entry — those tests mount
  /// the screen directly with [pumpScreen].
  Future<FakeDepartmentRemoteDataSource> openListAsAdmin(
    WidgetTester tester, {
    FakeDepartmentRemoteDataSource? remote,
  }) async {
    final departments = remote ?? twoDepartments();
    await pumpAppAt(
      tester,
      Role.admin,
      'Departments',
      overrides: overridesFor(departments),
    );
    return departments;
  }

  testWidgets('lists departments fetched from the API', (tester) async {
    await openListAsAdmin(tester);

    expect(find.text('Engineering'), findsOneWidget);
    expect(find.text('People Ops'), findsOneWidget);
    expect(find.text('2 employees'), findsOneWidget);
    expect(find.text('0 employees'), findsOneWidget);
  });

  testWidgets('an admin gets the create affordance', (tester) async {
    await openListAsAdmin(tester);

    expect(find.text('New department'), findsOneWidget);
  });

  testWidgets('a non-admin gets a read-only list', (tester) async {
    await pumpScreen(
      tester,
      const DepartmentsScreen(),
      as: Role.manager,
      overrides: overridesFor(twoDepartments()),
    );

    expect(find.text('Engineering'), findsOneWidget);
    expect(find.text('New department'), findsNothing);
    expect(find.byIcon(Icons.edit_outlined), findsNothing);
    expect(find.byIcon(Icons.delete_outline), findsNothing);
  });

  testWidgets('an admin can create a department through the sheet', (
    tester,
  ) async {
    final remote = await openListAsAdmin(tester);

    await tester.tap(find.text('New department'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Department name'),
      'Sales',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(remote.lastCreate?.name, 'Sales');
    expect(find.text('Sales'), findsOneWidget);
    expect(find.text('Department "Sales" created.'), findsOneWidget);
  });

  testWidgets('an empty name is rejected before it reaches the API', (
    tester,
  ) async {
    final remote = await openListAsAdmin(tester);

    await tester.tap(find.text('New department'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Department name is required.'), findsOneWidget);
    expect(remote.lastCreate, isNull);
  });

  testWidgets('an admin can edit a department through the sheet', (
    tester,
  ) async {
    final remote = await openListAsAdmin(tester);

    await tester.tap(find.byIcon(Icons.edit_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('Edit department'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Department name'),
      'Platform Engineering',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(remote.lastUpdate?.name, 'Platform Engineering');
    expect(find.text('Platform Engineering'), findsOneWidget);
    expect(find.text('Department "Platform Engineering" updated.'), findsOneWidget);
  });

  testWidgets('an admin can delete a department after confirming', (
    tester,
  ) async {
    final remote = await openListAsAdmin(tester);

    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();

    // The confirm dialog guards the destructive action.
    expect(find.textContaining('Delete "Engineering"?'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(remote.deletedId, 1);
    expect(find.text('Engineering'), findsNothing);
    expect(find.text('Department "Engineering" deleted.'), findsOneWidget);
  });

  testWidgets('deleting a department that still has employees shows the API error', (
    tester,
  ) async {
    final remote = await openListAsAdmin(tester);

    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    remote.error = DioException(
      requestOptions: RequestOptions(path: '/departments/1'),
      type: DioExceptionType.badResponse,
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: '/departments/1'),
        statusCode: 409,
        data: 'Cannot delete a department that still has employees assigned to it.',
      ),
    );

    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(
      find.text('Cannot delete a department that still has employees assigned to it.'),
      findsOneWidget,
    );
    // Still there — the delete was rejected, not applied.
    expect(find.text('People Ops'), findsOneWidget);
  });

  testWidgets('an empty list explains itself', (tester) async {
    await openListAsAdmin(
      tester,
      remote: FakeDepartmentRemoteDataSource(departments: const []),
    );

    expect(find.text('No departments yet'), findsOneWidget);
    expect(
      find.text('Create your first department to start grouping employees.'),
      findsOneWidget,
    );
  });

  testWidgets('a failed load offers a retry', (tester) async {
    final remote = FakeDepartmentRemoteDataSource(
      error: DioException.connectionError(
        requestOptions: RequestOptions(path: '/departments'),
        reason: 'refused',
      ),
    );
    await openListAsAdmin(tester, remote: remote);

    expect(find.text("Couldn't load departments"), findsOneWidget);
    expect(
      find.text("Couldn't reach the server. Is the API running?"),
      findsOneWidget,
    );

    // Clearing the fault and retrying re-fetches through the same stack.
    remote.error = null;
    remote.departments = [
      const DepartmentModel(id: 5, name: 'Support', employeeCount: 0),
    ];
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Support'), findsOneWidget);
  });
}
