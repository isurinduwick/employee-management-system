import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/employee.dart';
import '../../domain/entities/employee_draft.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_remote_data_source.dart';
import '../models/employee_request_models.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  const EmployeeRepositoryImpl({required this.remote});

  final EmployeeRemoteDataSource remote;

  @override
  Future<Either<Failure, List<Employee>>> getEmployees({
    int? departmentId,
  }) async {
    try {
      final models = await remote.getEmployees(departmentId: departmentId);
      return Right([for (final model in models) model.toEntity()]);
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Employee>> createEmployee(NewEmployee employee) async {
    try {
      final model = await remote.createEmployee(
        EmployeeCreateModel.fromEntity(employee),
      );
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Employee>> updateEmployee(
    int id,
    EmployeeEdit edit,
  ) async {
    try {
      final model = await remote.updateEmployee(
        id,
        EmployeeUpdateModel.fromEntity(edit),
      );
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deactivateEmployee(int id) async {
    try {
      await remote.deactivateEmployee(id);
      return const Right(unit);
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
