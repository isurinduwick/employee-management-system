import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/department.dart';
import '../repositories/department_repository.dart';

/// Every department, for pickers and the Departments screen.
class GetDepartments implements UseCase<List<Department>, NoParams> {
  const GetDepartments(this._repository);

  final DepartmentRepository _repository;

  @override
  Future<Either<Failure, List<Department>>> call(NoParams params) =>
      _repository.getDepartments();
}
