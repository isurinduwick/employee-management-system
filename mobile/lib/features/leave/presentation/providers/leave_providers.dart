import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/error/failure.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/leave_remote_data_source.dart';
import '../../data/repositories/leave_repository_impl.dart';
import '../../domain/entities/leave_draft.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/entities/leave_status.dart';
import '../../domain/repositories/leave_repository.dart';
import '../../domain/usecases/create_leave_request.dart';
import '../../domain/usecases/decide_leave_request.dart';
import '../../domain/usecases/get_leave_requests.dart';

/// Wiring for the leave feature, same chain as `features/employees/`:
/// data source -> repository -> use cases -> controller.

final leaveRemoteDataSourceProvider = Provider<LeaveRemoteDataSource>(
  (ref) => LeaveRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);

final leaveRepositoryProvider = Provider<LeaveRepository>(
  (ref) => LeaveRepositoryImpl(remote: ref.watch(leaveRemoteDataSourceProvider)),
);

final getLeaveRequestsUseCaseProvider = Provider<GetLeaveRequests>(
  (ref) => GetLeaveRequests(ref.watch(leaveRepositoryProvider)),
);

final createLeaveRequestUseCaseProvider = Provider<CreateLeaveRequest>(
  (ref) => CreateLeaveRequest(ref.watch(leaveRepositoryProvider)),
);

final decideLeaveRequestUseCaseProvider = Provider<DecideLeaveRequest>(
  (ref) => DecideLeaveRequest(ref.watch(leaveRepositoryProvider)),
);

/// The signed-in user's own requests.
///
/// No employeeId filter is sent: the API scopes an Employee's reads to
/// themself anyway, and a Manager/Admin viewing "my leave" wants the same
/// thing, so the id is passed explicitly for those roles.
final myLeaveRequestsProvider =
    AsyncNotifierProvider<MyLeaveRequestsController, List<LeaveRequest>>(
      MyLeaveRequestsController.new,
    );

class MyLeaveRequestsController extends AsyncNotifier<List<LeaveRequest>> {
  @override
  Future<List<LeaveRequest>> build() => _fetch();

  Future<List<LeaveRequest>> _fetch() async {
    final session = ref.read(sessionProvider);
    if (session == null) return const [];

    final result = await ref.read(getLeaveRequestsUseCaseProvider)(
      LeaveFilters(employeeId: session.employeeId),
    );
    return result.getOrElse((failure) => throw failure);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }

  Future<Either<Failure, LeaveRequest>> submit(NewLeaveRequest draft) async {
    final result = await ref.read(createLeaveRequestUseCaseProvider)(draft);
    return result.map((created) {
      // Newest first, matching the API's own ordering by AppliedOn.
      state = AsyncData([created, ...?state.valueOrNull]);
      // A new pending request belongs in the approvals queue too.
      ref.invalidate(pendingLeaveRequestsProvider);
      return created;
    });
  }
}

/// Status filter for the approvals queue. Pending by default — that's the
/// only status a decision can act on, so it's what a manager opens the
/// screen to see.
final approvalsStatusFilterProvider = StateProvider<LeaveStatus?>(
  (ref) => LeaveStatus.pending,
);

/// Everyone's requests at the chosen status (Manager/Admin).
///
/// A Manager still only *sees* what the API returns and can only decide on
/// their own reports — this is a view, not an authorisation.
final pendingLeaveRequestsProvider =
    AsyncNotifierProvider<PendingLeaveRequestsController, List<LeaveRequest>>(
      PendingLeaveRequestsController.new,
    );

class PendingLeaveRequestsController extends AsyncNotifier<List<LeaveRequest>> {
  @override
  Future<List<LeaveRequest>> build() {
    // Re-runs whenever the status filter changes.
    ref.watch(approvalsStatusFilterProvider);
    return _fetch();
  }

  Future<List<LeaveRequest>> _fetch() async {
    final status = ref.read(approvalsStatusFilterProvider);
    final result = await ref.read(getLeaveRequestsUseCaseProvider)(
      LeaveFilters(status: status),
    );
    return result.getOrElse((failure) => throw failure);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }

  Future<Either<Failure, LeaveRequest>> decide(
    int id,
    LeaveDecision decision,
  ) async {
    final result = await ref.read(decideLeaveRequestUseCaseProvider)(
      DecideLeaveParams(id: id, decision: decision),
    );
    return result.map((decided) {
      final filter = ref.read(approvalsStatusFilterProvider);
      final current = state.valueOrNull ?? const <LeaveRequest>[];

      // A decided request drops out of a Pending-filtered queue; under any
      // other filter it stays, with its new status.
      state = AsyncData(
        filter == LeaveStatus.pending
            ? [
                for (final request in current)
                  if (request.id != id) request,
              ]
            : [
                for (final request in current)
                  if (request.id == id) decided else request,
              ],
      );
      // The requester's own list now shows a different status.
      ref.invalidate(myLeaveRequestsProvider);
      return decided;
    });
  }
}
