import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/employee.dart';
import '../entities/employee_draft.dart';

/// Reads are open to any signed-in role; the writes below are Admin-only at
/// the API (`[Authorize(Roles = "Admin")]`), so a non-admin caller gets a
/// [ForbiddenFailure] rather than a silent no-op.
abstract interface class EmployeeRepository {
  Future<Either<Failure, List<Employee>>> getEmployees({int? departmentId});

  Future<Either<Failure, Employee>> createEmployee(NewEmployee employee);

  Future<Either<Failure, Employee>> updateEmployee(int id, EmployeeEdit edit);

  /// Soft delete: the row stays, `isActive` flips to false.
  Future<Either<Failure, Unit>> deactivateEmployee(int id);
}
