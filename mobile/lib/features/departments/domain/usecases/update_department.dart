import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/department.dart';
import '../repositories/department_repository.dart';

class UpdateDepartmentParams {
  const UpdateDepartmentParams({required this.id, required this.name});

  final int id;
  final String name;
}

/// Admin-only at the API. Same trimming rule as [CreateDepartment].
class UpdateDepartment implements UseCase<Department, UpdateDepartmentParams> {
  const UpdateDepartment(this._repository);

  final DepartmentRepository _repository;

  @override
  Future<Either<Failure, Department>> call(UpdateDepartmentParams params) =>
      _repository.updateDepartment(params.id, params.name.trim());
}
