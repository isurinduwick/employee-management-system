import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/department.dart';
import '../repositories/department_repository.dart';

/// Admin-only at the API. Trims the name so a stray space can't create a
/// duplicate-looking department.
class CreateDepartment implements UseCase<Department, String> {
  const CreateDepartment(this._repository);

  final DepartmentRepository _repository;

  @override
  Future<Either<Failure, Department>> call(String params) =>
      _repository.createDepartment(params.trim());
}
