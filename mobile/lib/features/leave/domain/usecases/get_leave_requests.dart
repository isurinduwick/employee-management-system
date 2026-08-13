import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/leave_request.dart';
import '../repositories/leave_repository.dart';

class GetLeaveRequests implements UseCase<List<LeaveRequest>, LeaveFilters> {
  const GetLeaveRequests(this._repository);

  final LeaveRepository _repository;

  @override
  Future<Either<Failure, List<LeaveRequest>>> call(LeaveFilters params) =>
      _repository.getLeaveRequests(params);
}
