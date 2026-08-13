import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/failure.dart';
import 'package:mobile/features/auth/domain/entities/role.dart';
import 'package:mobile/features/leave/domain/entities/leave_status.dart';
import 'package:mobile/features/leave/presentation/providers/leave_providers.dart';

import '../../helpers/fake_leave_data_sources.dart';
import '../../helpers/pump_app.dart';

void main() {
  Future<FakeLeaveRemoteDataSource> pumpApprovals(
    WidgetTester tester, {
    FakeLeaveRemoteDataSource? remote,
    Role as = Role.manager,
  }) async {
    final fake =
        remote ??
        FakeLeaveRemoteDataSource(
          requests: [
            leaveModelFor(id: 1, employeeId: 5, employeeName: 'Sam Employee'),
          ],
        );
    await pumpAppAt(
      tester,
      as,
      'Leave Approvals',
      overrides: [leaveRemoteDataSourceProvider.overrideWithValue(fake)],
    );
    return fake;
  }

  testWidgets('the queue opens on Pending and names the requester', (
    tester,
  ) async {
    final remote = await pumpApprovals(tester);

    // Pending is the only status a decision can act on, so it is the default.
    expect(
      remote.filtersLog.map((f) => f.status),
      contains(LeaveStatus.pending),
    );
    expect(find.text('Sam Employee'), findsOneWidget);
    expect(find.text('Approve'), findsOneWidget);
    expect(find.text('Reject'), findsOneWidget);
  });

  testWidgets('approving sends the decision and clears the queue', (
    tester,
  ) async {
    final remote = await pumpApprovals(tester);

    await tester.tap(find.text('Approve'));
    await tester.pumpAndSettle();
    // The decision is confirmed first — it cannot be undone.
    await tester.tap(find.widgetWithText(TextButton, 'Approve').last);
    await tester.pumpAndSettle();

    expect(remote.lastDecision, (1, LeaveStatus.approved));
    expect(find.text('Leave approved.'), findsOneWidget);
    // A decided request drops out of a Pending-filtered queue.
    expect(find.text('Nothing waiting on you'), findsOneWidget);
  });

  testWidgets('a decided request offers no further decision', (tester) async {
    await pumpApprovals(
      tester,
      remote: FakeLeaveRemoteDataSource(
        requests: [
          leaveModelFor(
            id: 1,
            status: LeaveStatus.approved,
            approvedByName: 'Alex Manager',
          ),
        ],
      ),
    );

    // Default filter is Pending, so switch to see the decided one.
    await tester.tap(find.text('Approved'));
    await tester.pumpAndSettle();

    expect(find.text('Approve'), findsNothing);
    expect(find.text('Reject'), findsNothing);
    expect(find.textContaining('Approved by Alex Manager'), findsOneWidget);
  });

  testWidgets("a manager's out-of-team decision surfaces the API refusal", (
    tester,
  ) async {
    final remote = await pumpApprovals(tester);
    remote.error = const ForbiddenFailure(
      'You can only decide on your own team\'s leave requests.',
    );

    await tester.tap(find.text('Reject'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Reject').last);
    await tester.pumpAndSettle();

    expect(
      find.text("You can only decide on your own team's leave requests."),
      findsOneWidget,
    );
  });

  testWidgets('an employee never reaches the approvals queue', (tester) async {
    await pumpShellWithDrawerOpen(tester, Role.employee);

    // Deciding is Manager/Admin at the API, so the entry is absent entirely.
    expect(find.text('Leave Approvals'), findsNothing);
  });
}
