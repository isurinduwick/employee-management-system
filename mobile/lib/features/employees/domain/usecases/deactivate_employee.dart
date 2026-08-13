import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/employee_repository.dart';

/// Admin-only soft delete: attendance and leave history survive, the employee
/// simply stops being active.
class DeactivateEmployee implements UseCase<Unit, int> {
  const DeactivateEmployee(this._repository);

  final EmployeeRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(int params) =>
      _repository.deactivateEmployee(params);
}
