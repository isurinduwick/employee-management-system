import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/department.dart';
import '../../domain/repositories/department_repository.dart';
import '../datasources/department_remote_data_source.dart';
import '../models/department_request_model.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  const DepartmentRepositoryImpl({required this.remote});

  final DepartmentRemoteDataSource remote;

  @override
  Future<Either<Failure, List<Department>>> getDepartments() async {
    try {
      final models = await remote.getDepartments();
      return Right([for (final model in models) model.toEntity()]);
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Department>> createDepartment(String name) async {
    try {
      final model = await remote.createDepartment(
        DepartmentRequestModel(name: name),
      );
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Department>> updateDepartment(
    int id,
    String name,
  ) async {
    try {
      final model = await remote.updateDepartment(
        id,
        DepartmentRequestModel(name: name),
      );
      return Right(model.toEntity());
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDepartment(int id) async {
    try {
      await remote.deleteDepartment(id);
      return const Right(unit);
    } on Object catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
