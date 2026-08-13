import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/widgets/widgets.dart';
import 'package:mobile/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:mobile/features/attendance/presentation/screens/team_attendance_screen.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/departments/presentation/providers/department_providers.dart';
import 'package:mobile/features/employees/presentation/providers/employees_providers.dart';

import '../../helpers/fake_attendance_data_sources.dart';
import '../../helpers/fake_employee_data_sources.dart';
import '../../helpers/pump_app.dart';

/// Drives the team view through the real router, providers and repository —
/// only the HTTP data sources are faked. The filter panel it embeds also
/// reads the employees and departments endpoints to populate its pickers, so
/// those need faking here too, unlike the self-service Attendance screen.
void main() {
  List<Override> overridesFor(FakeAttendanceRemoteDataSource attendance) => [
    attendanceRemoteDataSourceProvider.overrideWithValue(attendance),
    employeeRemoteDataSourceProvider.overrideWithValue(
      FakeEmployeeRemoteDataSource(
        employees: [
          employeeModelFor(id: 1, firstName: 'Ada', lastName: 'Byron'),
        ],
      ),
    ),
    departmentRemoteDataSourceProvider.overrideWithValue(
      FakeDepartmentRemoteDataSource(),
    ),
  ];

  Future<FakeAttendanceRemoteDataSource> openTeamViewAsAdmin(
    WidgetTester tester, {
    FakeAttendanceRemoteDataSource? remote,
  }) async {
    final attendance =
        remote ??
        FakeAttendanceRemoteDataSource(
          records: [
            attendanceModelFor(id: 1, employeeId: 1, employeeName: 'Ada Byron'),
            attendanceModelFor(
              id: 2,
              employeeId: 2,
              employeeName: 'Grace Hopper',
            ),
          ],
        );
    await pumpAppAt(
      tester,
      Role.admin,
      'Team Attendance',
      overrides: overridesFor(attendance),
    );
    return attendance;
  }

  testWidgets('lists every record with the employee name shown', (
    tester,
  ) async {
    await openTeamViewAsAdmin(tester);

    expect(find.text('Ada Byron'), findsOneWidget);
    expect(find.text('Grace Hopper'), findsOneWidget);
  });

  testWidgets('a manager reaches the same screen', (tester) async {
    await pumpAppAt(
      tester,
      Role.manager,
      'Team Attendance',
      overrides: overridesFor(
        FakeAttendanceRemoteDataSource(
          records: [
            attendanceModelFor(
              id: 1,
              employeeId: 1,
              employeeName: 'Ada Byron',
            ),
          ],
        ),
      ),
    );

    expect(find.text('Ada Byron'), findsOneWidget);
  });

  testWidgets(
    'an employee reaching the route directly sees the not-available state',
    (tester) async {
      await pumpScreen(
        tester,
        const TeamAttendanceScreen(),
        as: Role.employee,
        overrides: overridesFor(FakeAttendanceRemoteDataSource()),
      );

      expect(find.text('Not available'), findsOneWidget);
      // The filter panel never even builds for a role that can't use it.
      expect(find.byType(AppDropdownField<int?>), findsNothing);
    },
  );

  testWidgets('applying the employee filter re-fetches with that filter', (
    tester,
  ) async {
    final remote = await openTeamViewAsAdmin(tester);

    // Employee is the first of the panel's two int? dropdowns; Department the
    // second.
    await tester.tap(find.byType(AppDropdownField<int?>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ada Byron').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(remote.lastFilters?.employeeId, 1);
  });

  testWidgets('clearing resets the filters and reloads everyone', (
    tester,
  ) async {
    final remote = await openTeamViewAsAdmin(tester);

    await tester.tap(find.byType(AppDropdownField<int?>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ada Byron').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(remote.lastFilters?.employeeId, 1);

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(remote.lastFilters?.employeeId, isNull);
    expect(find.text('Grace Hopper'), findsOneWidget);
  });

  testWidgets('an empty result explains itself without hiding the filters', (
    tester,
  ) async {
    await openTeamViewAsAdmin(
      tester,
      remote: FakeAttendanceRemoteDataSource(records: const []),
    );

    expect(find.text('No attendance records found'), findsOneWidget);
    // The filter row stays visible so it can be adjusted.
    expect(find.text('Apply'), findsOneWidget);
  });

  testWidgets('a failed load offers a retry', (tester) async {
    final remote = FakeAttendanceRemoteDataSource(
      error: DioException.connectionError(
        requestOptions: RequestOptions(path: '/attendance'),
        reason: 'refused',
      ),
    );
    await openTeamViewAsAdmin(tester, remote: remote);

    expect(find.text("Couldn't load attendance"), findsOneWidget);

    remote.error = null;
    remote.records = [
      attendanceModelFor(id: 3, employeeId: 1, employeeName: 'Ada Byron'),
    ];
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Ada Byron'), findsOneWidget);
  });
}
