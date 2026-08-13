import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/department.dart';

/// Read-only for now: the employee form needs the list to populate its
/// department picker. Create/update/delete land when the Departments screen
/// itself is built.
abstract interface class DepartmentRepository {
  Future<Either<Failure, List<Department>>> getDepartments();
}
