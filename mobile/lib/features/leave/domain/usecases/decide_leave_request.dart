import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/leave_request.dart';
import '../entities/leave_status.dart';
import '../repositories/leave_repository.dart';

class DecideLeaveParams {
  const DecideLeaveParams({required this.id, required this.decision});

  final int id;
  final LeaveDecision decision;
}

/// Manager/Admin only — the API enforces both that and the "own team only"
/// rule for Managers.
class DecideLeaveRequest implements UseCase<LeaveRequest, DecideLeaveParams> {
  const DecideLeaveRequest(this._repository);

  final LeaveRepository _repository;

  @override
  Future<Either<Failure, LeaveRequest>> call(DecideLeaveParams params) =>
      _repository.decide(params.id, params.decision);
}
