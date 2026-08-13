import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/leave_draft.dart';
import '../entities/leave_request.dart';
import '../repositories/leave_repository.dart';

/// Any authenticated role may request leave for themself.
///
/// The end-before-start rule is checked here as well as at the API, so the
/// form can say so without spending a round trip on a request it knows will
/// be rejected.
class CreateLeaveRequest implements UseCase<LeaveRequest, NewLeaveRequest> {
  const CreateLeaveRequest(this._repository);

  final LeaveRepository _repository;

  @override
  Future<Either<Failure, LeaveRequest>> call(NewLeaveRequest params) async {
    if (params.endDate.isBefore(params.startDate)) {
      return const Left(
        ValidationFailure('The end date cannot be before the start date.'),
      );
    }

    final reason = params.reason?.trim();
    return _repository.createLeaveRequest(
      params.copyWith(
        // The API treats an absent reason as "none"; an empty string would
        // store a blank rather than nothing.
        reason: (reason == null || reason.isEmpty) ? null : reason,
      ),
    );
  }
}
