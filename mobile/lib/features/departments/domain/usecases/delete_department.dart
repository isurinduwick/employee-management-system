import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/department_repository.dart';

/// Admin-only at the API. A department with employees still assigned to it
/// is rejected there with a 409, not here.
class DeleteDepartment implements UseCase<Unit, int> {
  const DeleteDepartment(this._repository);

  final DepartmentRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(int params) =>
      _repository.deleteDepartment(params);
}
