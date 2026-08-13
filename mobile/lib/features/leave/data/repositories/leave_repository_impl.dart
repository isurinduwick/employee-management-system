import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/leave_draft.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/entities/leave_status.dart';
import '../../domain/repositories/leave_repository.dart';
import '../datasources/leave_remote_data_source.dart';
import '../models/leave_request_models.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  const LeaveRepositoryImpl({required this.remote});

  final LeaveRemoteDataSource remote;

  @override
  Future<Either<Failure, List<LeaveRequest>>> getLeaveRequests(
    LeaveFilters filters,
  ) async {
    try {
      final models = await remote.getLeaveRequests(filters);
      return Right([for (final model in models) model.toEntity()]);
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, LeaveRequest>> createLeaveRequest(
    NewLeaveRequest draft,
  ) async {
    try {
      final model = await remote.createLeaveRequest(
        LeaveCreateModel(
          leaveType: draft.leaveType,
          startDate: draft.startDate,
          endDate: draft.endDate,
          reason: draft.reason,
        ),
      );
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, LeaveRequest>> decide(
    int id,
    LeaveDecision decision,
  ) async {
    try {
      final model = await remote.decide(
        id,
        LeaveDecisionModel(status: decision.status),
      );
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
