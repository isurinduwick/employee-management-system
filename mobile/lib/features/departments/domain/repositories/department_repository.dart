import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/department.dart';

/// Mirrors backend/Controllers/DepartmentsController.cs: reads are open to
/// every role, writes are Admin-only at the API — the repository just
/// forwards, the screen decides what to show.

abstract interface class DepartmentRepository {
  Future<Either<Failure, List<Department>>> getDepartments();
  Future<Either<Failure, Department>> createDepartment(String name);
  Future<Either<Failure, Department>> updateDepartment(int id, String name);
  Future<Either<Failure, Unit>> deleteDepartment(int id);
}
