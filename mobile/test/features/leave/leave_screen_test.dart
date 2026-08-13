import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failure.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/leave/domain/entities/leave_status.dart';
import 'package:mobile/features/leave/presentation/providers/leave_providers.dart';

import '../../helpers/fake_leave_data_sources.dart';
import '../../helpers/pump_app.dart';

void main() {
  Future<FakeLeaveRemoteDataSource> pumpLeave(
    WidgetTester tester, {
    FakeLeaveRemoteDataSource? remote,
    Role as = Role.employee,
  }) async {
    final fake = remote ?? FakeLeaveRemoteDataSource();
    await pumpAppAt(
      tester,
      as,
      'Leave',
      overrides: [leaveRemoteDataSourceProvider.overrideWithValue(fake)],
    );
    return fake;
  }

  testWidgets('an empty list explains itself', (tester) async {
    await pumpLeave(tester);

    expect(find.text('No leave requests yet'), findsOneWidget);
  });

  testWidgets('my requests are scoped to the signed-in employee', (
    tester,
  ) async {
    final remote = await pumpLeave(
      tester,
      remote: FakeLeaveRemoteDataSource(
        requests: [
          leaveModelFor(id: 1, employeeId: 1),
          // Someone else's request must never appear on "my leave".
          leaveModelFor(id: 2, employeeId: 99, employeeName: 'Other User'),
        ],
      ),
    );

    expect(remote.lastFilters?.employeeId, 1);
    expect(find.text('Other User'), findsNothing);
  });

  testWidgets('a request shows its type, range and status', (tester) async {
    await pumpLeave(
      tester,
      remote: FakeLeaveRemoteDataSource(
        requests: [
          leaveModelFor(
            id: 1,
            leaveType: LeaveType.sick,
            startDate: DateTime(2026, 4, 6),
            endDate: DateTime(2026, 4, 8),
            reason: 'Flu',
          ),
        ],
      ),
    );

    expect(find.text('Sick'), findsOneWidget);
    expect(find.textContaining('3 days'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Flu'), findsOneWidget);
  });

  testWidgets('submitting a request adds it to the list', (tester) async {
    final remote = await pumpLeave(tester);

    await tester.tap(find.text('Request leave'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(remote.lastCreate, isNotNull);
    expect(find.text('Leave request submitted.'), findsOneWidget);
    // The new request replaces the empty state without a refetch.
    expect(find.text('No leave requests yet'), findsNothing);
  });

  testWidgets('a rejected submit keeps the sheet open with the reason', (
    tester,
  ) async {
    final remote = await pumpLeave(tester);
    remote.error = const ValidationFailure('EndDate cannot be before StartDate.');

    await tester.tap(find.text('Request leave'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('EndDate cannot be before StartDate.'), findsOneWidget);
    // Still on the sheet, so the user can correct it.
    expect(find.text('Request leave'), findsWidgets);
  });

  testWidgets('a failed load offers a retry', (tester) async {
    await pumpLeave(
      tester,
      remote: FakeLeaveRemoteDataSource(error: const NetworkFailure()),
    );

    expect(find.text('Try again'), findsWidgets);
  });
}
