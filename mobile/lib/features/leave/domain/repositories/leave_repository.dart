import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/leave_draft.dart';
import '../entities/leave_request.dart';
import '../entities/leave_status.dart';

class LeaveFilters {
  const LeaveFilters({this.employeeId, this.status});

  /// Ignored by the API for the Employee role — reads are always scoped to
  /// the caller there, same rule as attendance history.
  final int? employeeId;
  final LeaveStatus? status;

  LeaveFilters copyWith({
    int? Function()? employeeId,
    LeaveStatus? Function()? status,
  }) {
    return LeaveFilters(
      employeeId: employeeId == null ? this.employeeId : employeeId(),
      status: status == null ? this.status : status(),
    );
  }
}

abstract interface class LeaveRepository {
  Future<Either<Failure, List<LeaveRequest>>> getLeaveRequests(
    LeaveFilters filters,
  );

  /// Always created as Pending — only [decide] can move it on.
  Future<Either<Failure, LeaveRequest>> createLeaveRequest(
    NewLeaveRequest draft,
  );

  /// Manager/Admin only. A Manager may only decide on their own direct
  /// reports' requests (403 otherwise), and a request can only be decided
  /// once (409 otherwise).
  Future<Either<Failure, LeaveRequest>> decide(int id, LeaveDecision decision);
}
