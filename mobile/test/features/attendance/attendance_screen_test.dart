import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failure.dart';
import 'package:mobile/features/attendance/domain/entities/attendance_status.dart';
import 'package:mobile/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';

import '../../helpers/fake_attendance_data_sources.dart';
import '../../helpers/pump_app.dart';

void main() {
  /// Navigates to the Attendance screen through the real drawer, with the
  /// attendance endpoints faked.
  Future<FakeAttendanceRemoteDataSource> pumpAttendance(
    WidgetTester tester, {
    FakeAttendanceRemoteDataSource? remote,
    Role as = Role.employee,
  }) async {
    final fake = remote ?? FakeAttendanceRemoteDataSource();
    await pumpAppAt(
      tester,
      as,
      'Attendance',
      overrides: [
        attendanceRemoteDataSourceProvider.overrideWithValue(fake),
      ],
    );
    return fake;
  }

  testWidgets('a day with no record invites a check-in', (tester) async {
    await pumpAttendance(tester);

    expect(find.text("You haven't checked in today"), findsOneWidget);
    expect(find.text('No attendance recorded yet'), findsOneWidget);
  });

  testWidgets('checking in records a Mobile device type', (tester) async {
    final remote = await pumpAttendance(tester);

    await tester.tap(find.text('Check In'));
    await tester.pumpAndSettle();

    // The web app writes Web here, so the mobile client must not mislabel
    // its own check-ins.
    expect(remote.lastCheckInDevice, DeviceType.mobile);
    expect(find.text('Checked in.'), findsOneWidget);
  });

  testWidgets('an open check-in offers a check-out', (tester) async {
    await pumpAttendance(
      tester,
      remote: FakeAttendanceRemoteDataSource(
        records: [todayAttendanceModel()],
      ),
    );

    expect(find.textContaining('Checked in at'), findsWidgets);
    expect(find.text("Don't forget to check out."), findsOneWidget);

    await tester.tap(find.text('Check Out'));
    await tester.pumpAndSettle();

    expect(find.text('Checked out.'), findsOneWidget);
  });

  testWidgets('a completed day offers neither action', (tester) async {
    final now = DateTime.now();
    await pumpAttendance(
      tester,
      remote: FakeAttendanceRemoteDataSource(
        records: [
          todayAttendanceModel(
            checkInTime: now.subtract(const Duration(hours: 8)),
            checkOutTime: now,
          ),
        ],
      ),
    );

    expect(find.text("Today's attendance is complete."), findsOneWidget);

    // Both actions are inert once the day is closed — tapping must not fire a
    // second check-out.
    await tester.tap(find.text('Check Out'));
    await tester.pumpAndSettle();
    expect(find.text('Checked out.'), findsNothing);
  });

  testWidgets('history is scoped to the signed-in employee', (tester) async {
    final remote = await pumpAttendance(
      tester,
      remote: FakeAttendanceRemoteDataSource(
        records: [
          attendanceModelFor(id: 1, employeeId: 1),
          // Someone else's row: the screen must never ask for it.
          attendanceModelFor(id: 2, employeeId: 99, employeeName: 'Other User'),
        ],
      ),
    );

    expect(remote.lastFilters?.employeeId, 1);
    expect(find.text('Other User'), findsNothing);
  });

  testWidgets('a failed load offers a retry', (tester) async {
    await pumpAttendance(
      tester,
      remote: FakeAttendanceRemoteDataSource(error: const NetworkFailure()),
    );

    expect(find.text('Try again'), findsWidgets);
  });

  testWidgets('a rejected check-in surfaces the API message', (tester) async {
    final remote = await pumpAttendance(tester);

    // The API answers 409 when you check in twice in one day.
    remote.error = const ServerFailure(
      'You have already checked in today.',
      statusCode: 409,
    );

    await tester.tap(find.text('Check In'));
    await tester.pumpAndSettle();

    expect(find.text('You have already checked in today.'), findsOneWidget);
  });
}
