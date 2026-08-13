import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/department.dart';
import '../../domain/repositories/department_repository.dart';
import '../datasources/department_remote_data_source.dart';

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
}
